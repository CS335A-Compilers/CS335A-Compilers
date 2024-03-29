#include <iostream>
#include "../bits/stdc++.h"

#include "ast.h"

using namespace std;

class GlobalSymbolTable {
    // level_stack stores the main level and sublevels currently processed;
    public :
        stack<pair<int,int>> level_stack;
        pair<int,int> current_level;
        GlobalSymbolTable();
        // 2d symbol_tables vector stores the local symbol tables with each row containing each main level and each column containing sublevels of each main level;
        vector<vector<GlobalSymbolTable*>> symbol_tables;
        void increase_level();
        pair<int,int> get_next_level();
        void decrease_level();
};

class LocalSymbolTable : public GlobalSymbolTable{
    public:
        pair<int,int> curr_level;
        vector<Node*> symbol_table_entries;
        map<string, int> hashed_names;
        GlobalSymbolTable* parent;
        vector<LocalSymbolTable*> children;
        LocalSymbolTable(pair<int, int> level, GlobalSymbolTable *assign_parent);
        bool add_entry(Node* symtab_entry);
        Node* get_entry(string name, int entry_type);
        Node* level_node;
};

LocalSymbolTable* get_local_symtab(pair<int,int> curr_level);
void createSymbolTableCSV();