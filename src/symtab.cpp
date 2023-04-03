#include "bits/stdc++.h"
#include "inc/symtab.h"
#include <string.h>

using namespace std;

extern vector<string> typeStrings;
extern void yyerror(char const*);
extern GlobalSymbolTable* global_symtab;

string filename;
map<string, vector<string>> csv_contents;
// Define an array of strings that corresponds to the type values.
vector<string> class_name;
int class_index = -1;

void GlobalSymbolTable::increase_level(){
    pair<int,int> curr_level = level_stack.top();
    int new_main_level = curr_level.first + 1;
    int new_sub_level = (symbol_tables.size() <= new_main_level) ? 0 : symbol_tables[new_main_level].size();
    pair<int,int> new_level = {new_main_level, new_sub_level};
    level_stack.push(new_level);
    // creating sybmol table entry for new_level;
    GlobalSymbolTable* parent_symbtab = symbol_tables[curr_level.first][curr_level.second];
    LocalSymbolTable *symbtab = new LocalSymbolTable(new_level, parent_symbtab);
    ((LocalSymbolTable *)parent_symbtab)->children.push_back(symbtab);
    if(symbol_tables.size() <= new_main_level) symbol_tables.push_back({symbtab});
    else symbol_tables[new_main_level].push_back(symbtab);
    current_level = level_stack.top();
    return ;
}

pair<int,int> GlobalSymbolTable::get_next_level(){
    pair<int,int> curr_level = level_stack.top();
    int new_main_level = curr_level.first + 1;
    int new_sub_level = (symbol_tables.size() <= new_main_level) ? 0 : symbol_tables[new_main_level].size();
    pair<int,int> new_level = {new_main_level, new_sub_level};
    return new_level;
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
    children.resize(0);
}

// Define an array of strings that corresponds to the modifier types.
const string modifierStrings[] = {"public", "protected", "private", "abstract", "static", "sealed", "nonsealed", "strictfp", "transitive", "final", "volatile", "transient", "native"};

// Modifier list - PUBLIC (0), STATIC (4), FINAL (9), PRIVATE (2)
bool LocalSymbolTable::add_entry(Node* symtab_entry){
    hashed_names.insert({symtab_entry->name, symbol_table_entries.size()});
    symbol_table_entries.push_back(symtab_entry);
    // cout<<symtab_entry->lexeme<<" "<<symtab_entry->line_no<<" "<<symtab_entry->name<<endl;
    if(symtab_entry->entry_type == CLASS_DECLARATION){
        NormalClassDeclaration* temp = (NormalClassDeclaration*)(symtab_entry);
        // cout<<"class entry added: "<<(symtab_entry->name)<<" at level: "<<global_symtab->current_level.first<<" "<<global_symtab->current_level.second<<endl;
        if(temp->modifiers_list == NULL) return true;
        vector<Modifier*> modifiers = temp->modifiers_list->lists;
        // Count the number of each modifier to give error if there are duplicates
        map<ModifierType, int> counts;
        for (Modifier *element : modifiers) {
            counts[element->modifier_type]++;
        }
        string error;
        for (Modifier *element : modifiers){
            if (element->modifier_type != 0 && element->modifier_type != 9){
                error = "Modifier " + modifierStrings[element->modifier_type] + " not allowed in class declaration";
                yyerror(error.c_str());
                return false;
            }
        }
        for (auto z : counts) {
            if (z.second > 1) {
                error = "Duplicate modifier found for the class - " + modifierStrings[z.first];
                yyerror(error.c_str());
                return false;
            }
        }
        // throw error if bad modifier list combination done
        // throw error if constructor method name doesnt match with the class name
    }
    else if(symtab_entry->entry_type == METHOD_DECLARATION){
        MethodDeclaration* temp = (MethodDeclaration*)(symtab_entry);
        // cout<<"method entry added: "<<(symtab_entry->name)<<" at level: "<<global_symtab->current_level.first<<" "<<global_symtab->current_level.second<<endl;
        // cout<<temp->formal_parameter_list->lists[0]->variable_declarator_id->num_of_dims;
        if(temp->modifiers == NULL) return true;
        vector<Modifier*> modifiers = temp->modifiers->lists;
        // Count the number of each modifier to give error if there are duplicates
        map<ModifierType, int> counts;
        for (Modifier *element : modifiers) {
            counts[element->modifier_type]++;
        }
        string error;
        int c = 0;
        for (Modifier *element : modifiers)
        {
            if (element->modifier_type == 0 || element->modifier_type == 2){
                c++;
            }
            if (element->modifier_type != 0 && element->modifier_type != 9 && element->modifier_type != 4 && element->modifier_type != 2){
                error = "Modifier " + modifierStrings[element->modifier_type] + " not allowed in method declaration";
                yyerror(error.c_str());
                return false;
            }
        }
        for (auto z : counts) {
            if (z.second > 1) {
                error = "Duplicate modifier found for the method - " + modifierStrings[z.first];
                yyerror(error.c_str());
                return false;
            }
        }
        if (c > 1){
            error = "Methods can only set one of public / private access modifiers.";
            yyerror(error.c_str());
            return false;
        }
        if(temp->isConstructor){
            // throw error if bad modifier list combination done
        }
    }
    else if(symtab_entry->entry_type == VARIABLE_DECLARATION){
        LocalVariableDeclaration* temp = (LocalVariableDeclaration*)(symtab_entry);
        if(temp->modifiers_lists == NULL) return true;
        vector<Modifier *> modifiers = temp->modifiers_lists->lists;
        // Count the number of each modifier to give error if there are duplicates
        map<ModifierType, int> counts;
        for (Modifier *element : modifiers) {
            counts[element->modifier_type]++;
        }
        string error;
        for (auto z : counts) {
            if (z.second > 1) {
                error = "Duplicate modifier found for the field variable - " + modifierStrings[z.first];
                yyerror(error.c_str());
                return false;
            }
        }
        if (temp->isFieldVariable == true)
        {
            int c = 0;
            for (Modifier *element : modifiers)
            {
                if (element->modifier_type == 0 || element->modifier_type == 2){
                    c++;
                }
                if (element->modifier_type != 0 && element->modifier_type != 9 && element->modifier_type != 4 && element->modifier_type != 2){
                    error = "Modifier " + modifierStrings[element->modifier_type] + " not allowed in field variable declaration";
                    yyerror(error.c_str());
                    return false;
                }
            }
            if (c > 1){
                error = "Methods can only set one of public / private access modifiers.";
                yyerror(error.c_str());
                return false;
            }
        }
        else {
            for (Modifier *element : modifiers)
            {
                if (element->modifier_type != 9){
                    error = "Modifier " + modifierStrings[element->modifier_type] + " not allowed in field variable declaration";
                    yyerror(error.c_str());
                    return false;
                }
            }
        }
        
        if(temp->type->primitivetypeIndex == -1){
            // cout<<"object of class type: "<<temp->type->class_instantiated_from->name<<" declared named : "<<temp->name<<" \n";
        }
        // cout<<"initialized value: "<<temp->variable_declarator->initialized_value->num_val[0];
        // cout<<temp->variable_declarator->num_of_dims<<endl;
        
        // throw error if bad modifier list combination done
    }
    else {

    }
    return true;
}

Node* LocalSymbolTable::get_entry(string name, int entry_type){
    // nested scope 
    LocalSymbolTable* temp = this;
    int pos = name.find('.');
    if(pos != string::npos) name = name.substr(0, pos);

    while(temp != NULL){
        if(temp->hashed_names.find(name)!=temp->hashed_names.end()){
            Node* res = temp->symbol_table_entries[temp->hashed_names[name]];
            if((entry_type == -1) || (entry_type == (int)(res->entry_type))) return res;
            else temp = (LocalSymbolTable*)(temp->parent);
        }
        else{
            temp = (LocalSymbolTable*)(temp->parent);
        }
    }
    // for input of type x it returns x;
    // for input of type obj.x it returns obj;
    return NULL;
}

LocalSymbolTable* get_local_symtab(pair<int,int> curr_level){
    if(global_symtab->symbol_tables.size() <= curr_level.first || global_symtab->symbol_tables[curr_level.first].size() <= curr_level.second){
        // throw compiler error;
    }
    else return ((LocalSymbolTable*)(global_symtab->symbol_tables[curr_level.first][curr_level.second]));
}

void get_csv_entries(LocalSymbolTable* scope){
    if(scope==NULL) return ;
    // get the symbol table entries
    vector<Node*> temp_var(scope->symbol_table_entries);
    for (Node* variable : temp_var){
        if (variable->isWritten ==  false){
            // For class csv file
            if(variable->entry_type == CLASS_DECLARATION){
                variable->isWritten = true;
                csv_contents.insert({variable->name, {}});
                class_name.push_back(variable->name);
                class_index++;
            }

            if(variable->entry_type == METHOD_DECLARATION){
                variable->isWritten = true;
                csv_contents.insert({variable->name, {}});
                int dt_index = ((MethodDeclaration*)(variable))->type->primitivetypeIndex;
                string type;
                if (dt_index == -1){
                }
                else{
                    type = typeStrings[dt_index];
                }
                string str = variable->name + "," + type + "," + variable->lexeme + "," + to_string(variable->line_no);
                csv_contents[class_name[class_index]].push_back(str);
            }
            // For method csv file
            if(variable->entry_type == VARIABLE_DECLARATION){
                int dt_index = ((LocalVariableDeclaration*)(variable))->type->primitivetypeIndex;
                string type;
                if (dt_index == -1){
                    type = ((LocalVariableDeclaration*)(variable))->type->class_instantiated_from->name;
                }
                else{
                    type = typeStrings[dt_index];
                }
                string str = variable->name + "," + type + "," + variable->lexeme + "," + to_string(variable->line_no);
                LocalSymbolTable* temp = get_local_symtab(variable->current_level);
                while(true){
                    if(temp==NULL) break;
                    if(temp->level_node != NULL && temp->level_node->entry_type == METHOD_DECLARATION) {
                        break;
                    }
                    else{
                        temp = (LocalSymbolTable*)temp->parent;
                    }
                }
                if(temp!=NULL && temp->level_node != NULL){
                    variable->isWritten = true;
                    csv_contents[temp->level_node->name].push_back(str);
                }
            }
            
        }
        if (variable->isWritten ==  false){
            // For class csv file
            if(variable->entry_type == VARIABLE_DECLARATION){
                int dt_index = ((LocalVariableDeclaration*)(variable))->type->primitivetypeIndex;
                string type;
                if (dt_index == -1){
                    type = ((LocalVariableDeclaration*)(variable))->type->class_instantiated_from->name;
                }
                else{
                    type = typeStrings[dt_index];
                }
                string str = variable->name + "," + type + "," + variable->lexeme + "," + to_string(variable->line_no);
                LocalSymbolTable* temp = get_local_symtab(variable->current_level);
                while(true){
                    if(temp==NULL) break;
                    if(temp->level_node != NULL && temp->level_node->entry_type == CLASS_DECLARATION) {
                        break;
                    }
                    else{
                        temp = (LocalSymbolTable*)temp->parent;
                    }
                }
                if(temp!=NULL && temp->level_node != NULL){
                    variable->isWritten = true;
                    csv_contents[temp->level_node->name].push_back(str);
                }
            }
        }
    }
    Node* level_node = scope->level_node;
    if (level_node == NULL){
        return;
    }
    if (level_node->entry_type == METHOD_DECLARATION){
        for(int i=0;i<scope->children.size();i++){
            get_csv_entries((scope->children)[i]);
        }
    }
    return ;
}

void print_to_csv() {
    // Loop through the map and write the data to the CSV file
   for (auto z : csv_contents) {
      // Open the CSV file for writing
    //   ofstream file("./output/" + z.first + ".csv");
      // Loop through the vector and write each element to the CSV file
      cout << "Name,Type,Syntactic Category,Line no" << "\n";
      for (auto v : z.second) {
         cout << v << "\n";
      }
    //   file.close();
   }
}

void createSymbolTableCSV(){
    // Print the symbol table
    for(int i = 0;i < global_symtab->symbol_tables.size(); i++){
        for(int j = 0; j < global_symtab->symbol_tables[i].size(); j++){
            // get the local symbol table
            LocalSymbolTable* curr_scope = ((LocalSymbolTable*)global_symtab->symbol_tables[i][j]);
            get_csv_entries(curr_scope);
        }
    }
    print_to_csv();
    return ;
}