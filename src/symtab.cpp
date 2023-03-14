#include "bits/stdc++.h"
#include "inc/symtab.h"

using namespace std;

void GlobalSymbolTable::increase_level(){
    pair<int,int> curr_level = level_stack.top();
    int new_main_level = curr_level.first + 1;
    int new_sub_level = (symbol_tables.size() <= new_main_level) ? 0 : symbol_tables[new_main_level].size();
    pair<int,int> new_level = {new_main_level, new_sub_level};
    level_stack.push(new_level);
    // creating sybmol table entry for new_level;
    if(curr_level.first != 0 || current_level.second != 0){
        GlobalSymbolTable* parent_symbtab = symbol_tables[curr_level.first][curr_level.second];
        LocalSymbolTable* symbtab = new LocalSymbolTable(new_level, parent_symbtab);
        if(symbol_tables.size() <= new_main_level) symbol_tables.push_back({symbtab});
        else symbol_tables[new_main_level].push_back(symbtab);
    }
    else{
        LocalSymbolTable* symbtab = new LocalSymbolTable(new_level, NULL);
        if(symbol_tables.size() <= new_main_level) symbol_tables.push_back({symbtab});
        else symbol_tables[new_main_level].push_back(symbtab);
    }
    current_level = level_stack.top();
    return ;
}

void GlobalSymbolTable::decrease_level(){
    if(!level_stack.empty()){
        level_stack.pop();
    }
    else {
        // throw error
    }
    current_level = level_stack.top();
    return ;
}

GlobalSymbolTable::GlobalSymbolTable(){
    current_level = {0,0};
    level_stack.push(current_level);
    symbol_tables.resize(1, vector<GlobalSymbolTable*> (1));
}

LocalSymbolTable::LocalSymbolTable(pair<int,int> level, GlobalSymbolTable* assign_parent){
    curr_level.first = level.first;
    curr_level.second = level.second;
    parent = assign_parent;
}

void LocalSymbolTable::add_entry(Node* symtab_entry){
    hashed_names.insert({symtab_entry->name, symbol_table_entries.size()});
    symbol_table_entries.push_back(symtab_entry);
    cout<<symtab_entry->lexeme<<" "<<symtab_entry->line_no<<" "<<symtab_entry->name<<endl;
    if(symtab_entry->entry_type == CLASS_DECLARATION){
        NormalClassDeclaration* temp = (NormalClassDeclaration*)(symtab_entry);
        
    }
    else if(symtab_entry->entry_type == METHOD_DECLARATION){
        MethodDeclaration* temp = (MethodDeclaration*)(symtab_entry);

    }
    else if(symtab_entry->entry_type == VARIABLE_DECLARATION){

    }
    else {

    }
    return ;
}

Node* LocalSymbolTable::get_entry(string name){
    if(hashed_names.find(name)!=hashed_names.end())
        return symbol_table_entries[hashed_names[name]];
    else
        return NULL;
}
