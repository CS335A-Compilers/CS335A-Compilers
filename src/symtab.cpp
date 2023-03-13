#include "bits/stdc++.h"
#include "inc/symtab.h"

using namespace std;

void GlobalSymbolTable::increase_level(){
    pair<int,int> curr_level = {-1,-1};
    bool popped = false;
    if(!level_stack.empty()){
        curr_level = level_stack.top();
        level_stack.pop();
        popped = true;
    }
    int new_main_level = curr_level.first + 1;
    int new_sub_level = symbol_tables[new_main_level].size();
    pair<int,int> new_level = {new_main_level, new_sub_level};
    if(popped) level_stack.push(curr_level);
    level_stack.push(new_level);
    // creating sybmol table entry for new_level;
    if(curr_level.first != -1){
        GlobalSymbolTable* parent_symbtab = symbol_tables[curr_level.first][curr_level.second];
        LocalSymbolTable* symbtab = new LocalSymbolTable(new_level, parent_symbtab);
        symbol_tables[new_main_level].push_back(symbtab);
    }
    else{
        LocalSymbolTable* symbtab = new LocalSymbolTable(new_level, NULL);
        symbol_tables[new_main_level].push_back(symbtab);
    }
    return ;
}

void GlobalSymbolTable::decrease_level(){
    if(!level_stack.empty()){
        level_stack.pop();
    }
    else {
        // throw error
    }
    return ;
}

LocalSymbolTable::LocalSymbolTable(pair<int,int> level, GlobalSymbolTable* assign_parent){
    curr_level.first = level.first;
    curr_level.second = level.second;
    parent = assign_parent;
}

void LocalSymbolTable::add_entry(Node* symtab_entry){
    hashed_names.insert({symtab_entry->name, symbol_table_entries.size()});
    symbol_table_entries.push_back(symtab_entry);
    return ;
}

Node* LocalSymbolTable::get_entry(string name){
    return symbol_table_entries[hashed_names[name]];
    
}
