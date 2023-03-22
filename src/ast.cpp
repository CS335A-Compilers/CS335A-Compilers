#include "bits/stdc++.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

#include "inc/symtab.h"

extern int yylineno;
extern void yyerror(char const*);
extern GlobalSymbolTable* global_symtab;

int Node::node_id = 0;

Node::Node(string lex){
    lexeme = lex;
    name = lex;
    children.resize(0);
    isTerminal = false;
    node_id++;
    id = node_id;
    line_no = yylineno;
}

void Node::addChildren(vector<Node*> childrens){
    int n = childrens.size();
    for(int i=0;i<n;i++){
        this->children.push_back(childrens[i]);
    }
    return ;
}

IdentifiersList::IdentifiersList(string lex, string single_ident, vector<string> idents)
    : Node(lex){
    if(single_ident != "")
        identifiers.push_back(single_ident);
    for(int i=0;i<idents.size();i++){
        if(idents[i]!="") {
            identifiers.push_back(idents[i]);
        }
    }
}

FormalParameterList::FormalParameterList(string lex, FormalParameter* single_parameter, vector<FormalParameter*> parameters)
    : Node(lex) {
    lists.resize(0);
    if(single_parameter != NULL)
        lists.push_back(single_parameter);
    for(int i=0;i<parameters.size();i++){
        if(parameters[i]!=NULL)
            lists.push_back(parameters[i]);
    }
}

FormalParameter::FormalParameter(string lex, Type* type, VariableDeclaratorId* variable_dec_id, bool isFinal)
    : Node(lex) {
    isFinal = isFinal;
    param_type = type;
    variable_declarator_id = variable_dec_id;
}

Type::Type(string lex, int primitivetype)
    : Node(lex) {
    primitivetypeIndex = primitivetype;
    line_no = yylineno;
}

MethodDeclaration::MethodDeclaration(string lex)
    : Node(lex) {
    isConstructor = false;
}

MethodDeclaration::MethodDeclaration(const MethodDeclaration* obj)
    : Node(obj->lexeme){
    modifiers = obj->modifiers;
    type = obj->type;
    isConstructor = false;
    formal_parameter_list = obj->formal_parameter_list;
}

Modifier::Modifier(ModifierType type, string lex)
    : Node(lex){
    modifier_type = type;
}

ModifierList::ModifierList(string lex, Modifier* single_modifier, vector<Modifier*> modifiers)
    : Node(lex){
    lists.resize(0);
    if(single_modifier != NULL)
        lists.push_back(single_modifier);
    for(int i=0;i<modifiers.size();i++){
        if(modifiers[i]!=NULL)
            lists.push_back(modifiers[i]);
    }
}

VariableDeclaratorId::VariableDeclaratorId(string lex, string ident, int num, Value* value)
    : Node(lex){    
    identifier = ident;
    name = ident;
    num_of_dims = num;
    initialized_value = value;
}

VariableDeclaratorList::VariableDeclaratorList(string lex, VariableDeclaratorId* single_variable, vector<VariableDeclaratorId*> variables)
    : Node(lex){
    lists.resize(0);
    if(single_variable != NULL)
        lists.push_back(single_variable);
    for(int i=0;i<variables.size();i++){
        if(variables[i]!=NULL)
            lists.push_back(variables[i]);
    }
}

LocalVariableDeclaration::LocalVariableDeclaration(string lex, Type* t, VariableDeclaratorId* variable_decl_id, ModifierList* modif_lists)
    : Node(lex){
    type = t;
    name = variable_decl_id->name;
    modifiers_lists = modif_lists;
    variable_declarator = variable_decl_id;
}

NormalClassDeclaration::NormalClassDeclaration(string lex, ModifierList* list, string identifier)
    : Node(lex){
    modifiers_list = list;
    name = identifier;
}

Dims::Dims(string lex, int num)
    : Node(lex){
    count_dims = num;
}

Expression::Expression(string lex, Value* val, bool primary, bool literal)
    : Node(lex){
    value = val;
    isPrimary = primary;
    isLiteral = literal;
    registor_index = -1;
    
}

/* ####################   Helper funtion related to ast  #################### */

bool typenameErrorChecking(Node* node, pair<int,int> curr_level){
    IdentifiersList* lists = (IdentifiersList*)node;
    int n = lists->identifiers.size();
    if(n==1){
        Node* temp = get_local_symtab(curr_level)->get_entry(lists->identifiers[0]);
        if(temp != NULL) return true;

    }
    else{
        string class_name = lists->identifiers[0];
        
    }
    yyerror("Variable not declared in the scope");
    return false;
    
}

void addVariablesToSymtab(Type* t, VariableDeclaratorList* declarator_list, pair<int,int> curr_level, ModifierList* modif_lists, bool is_field_variable){
    for(int i=0;i<declarator_list->lists.size();i++){
        LocalVariableDeclaration* locale = new LocalVariableDeclaration("local_variable_declaration", t, declarator_list->lists[i], modif_lists);
        locale->isFieldVariable = is_field_variable;
        locale->entry_type = VARIABLE_DECLARATION;
        get_local_symtab(global_symtab->current_level)->add_entry(locale);
    }
    return ;
}

Node* createNode(string str){
    Node* node = new Node(str);
    return node;
}

Node* cloneRoot(Node* root){
    string lex = root->lexeme;
    Node* newRoot = new Node(lex);
    // Need to copy all attributes;
    return newRoot;
}

Node* convertToAST(Node* root){
    int n = root->children.size();
    if(n==1) return convertToAST(root->children[0]);
    else if (n==0) return root;
    Node* mainRoot = cloneRoot(root);
    for(int i=0;i<n;i++){
        if((root->children[i])->isTerminal == false && ((root->children[i])->children).size() == 0) continue;
        Node* ithchild = convertToAST(root->children[i]);
        mainRoot->children.push_back(ithchild);
    }
    return mainRoot;
}

string spaceToUnderscore(string word){
    int n = word.length();
    for(int i=0;i<n;i++){
        if(word[i]==' ') word[i]='_';
    }
    return word;
}

void writeEdges(Node* root, FILE* file){
    if(root == NULL) return ;
    int n = root->children.size();
    if(n==0 && root->isTerminal == false) return ;
    string temp;
    if(root->isTerminal == true) temp = root->lexeme;
    else temp = spaceToUnderscore(root->lexeme);
    char* a = strcpy(new char[temp.length() + 1], temp.c_str());
    if(root->isTerminal == true) fprintf(file, "\t%lld[label = \"%s\", shape = \"doublecircle\"]\n", root->id, a);
    else fprintf(file, "\t%lld[label = %s]\n", root->id, a);
    for(int i=0;i<n;i++){
        if((root->children[i])->isTerminal == false && ((root->children[i])->children).size() == 0) continue;   //not required but written anyway
        fprintf(file, "\t%lld -> %lld\n", root->id, (root->children[i])->id);
    }
    for(int i=0;i<n;i++){
        writeEdges(root->children[i], file);
    }
    return ;
}

void createDOT(Node* root, char* output_file){
    FILE *file; //file pointer
    file = fopen(output_file, "w");
    fprintf(file, "digraph AST{\n");
    writeEdges(root, file);
    fprintf(file, "}");
    fclose(file);
    return ;
}

void createAST(Node* root, char* output_file){
    Node* ast_root = convertToAST(root);
    createDOT(ast_root, output_file);
    return ;
}