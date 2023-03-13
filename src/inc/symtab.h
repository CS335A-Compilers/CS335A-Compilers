#include <iostream>
#include "bits/stdc++.h"

#include "ast.h"

using namespace std;

enum PrimitiveType {BYTE, SHORT, INT, LONG, CHAR, FLOAT, DOUBLE, BOOLEAN, };
// symbol table entry is added whenever one of these declaration is done
enum DeclarationType {VARIABLE_DECLARATION, CLASS_DECLARATION, METHOD_DECLARATION, PACKAGE_DECLARATION, IMPORT_DECLARATION, };

class GlobalSymbolTable {
    // level_stack stores the main level and sublevels currently processed;
    public :
        stack<pair<int,int>> level_stack;
        pair<int,int> current_level;
        // 2d symbol_tables vector stores the symbol tables with each row containing each main level and each column containing sublevels of each main level;
        vector<vector<GlobalSymbolTable*>> symbol_tables;
        void increase_level();
        void decrease_level();
    
};

class LocalSymbolTable : public GlobalSymbolTable{
    public:
        pair<int,int> curr_level;
        vector<Node*> symbol_table_entries;
        map<string, int> hashed_names;
        GlobalSymbolTable* parent;
        LocalSymbolTable(pair<int,int> level, GlobalSymbolTable* assign_parent);
        void add_entry(Node* symtab_entry);
        Node* get_entry(string name);
};
 