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
    level_stack.pop();
    if(level_stack.empty()){
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
    // cout<<symtab_entry->lexeme<<" "<<symtab_entry->line_no<<" "<<symtab_entry->name<<endl;
    if(symtab_entry->entry_type == CLASS_DECLARATION){
        NormalClassDeclaration* temp = (NormalClassDeclaration*)(symtab_entry);
        // throw error if bad modifier list combination done
        // throw error if constructor method name doesnt match with the class name
    }
    else if(symtab_entry->entry_type == METHOD_DECLARATION){
        MethodDeclaration* temp = (MethodDeclaration*)(symtab_entry);
        // cout<<temp->formal_parameter_list->lists[0]->variable_declarator_id->num_of_dims;
        if(temp->isConstructor){
            // throw error if bad modifier list combination done
        }
    }
    else if(symtab_entry->entry_type == VARIABLE_DECLARATION){
        LocalVariableDeclaration* temp = (LocalVariableDeclaration*)(symtab_entry);
        // cout<<temp->variable_declarator->identifier<<endl;
        // cout<<temp->type->primitivetypeIndex<<endl;
        // cout<<temp->variable_declarator->num_of_dims<<endl;
        // cout<<temp->isFieldVariable;
        // throw error if bad modifier list combination done
    }
    else {

    }
    return ;
}

Node* LocalSymbolTable::get_entry(string name){
    // nested scope 
    if(hashed_names.find(name)!=hashed_names.end())
        return symbol_table_entries[hashed_names[name]];
    
}
