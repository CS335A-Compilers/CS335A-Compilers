#include "bits/stdc++.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

#include "inc/3ac.h"

extern int yylineno;
extern void yyerror(char const*);
extern GlobalSymbolTable* global_symtab;
extern vector<ThreeAC*> threeAC_list;
extern vector<bool> temporary_registors_in_use;
extern vector<int> typeSizes;
extern int stack_frame_pointer;
extern vector<string> calleeSavedRegistors;
extern NormalClassDeclaration* curr_class;
extern vector<bool> calleeSavedInUse;
extern vector<string> typeStrings;
extern int functionOffset;
extern vector<bool> calleeGlobalCalled;
extern int curr_address;

vector<string> entryTypeStrings = {"variable", "class", "method"};

string current_class_name = "";

int Node::node_id = 0;

Node::Node(string lex){
    lexeme = lex;
    name = lex;
    children.resize(0);
    isTerminal = false;
    node_id++;
    id = node_id;
    entry_type = -1;
    isWritten = false;
    current_level = global_symtab->current_level;
    line_no = yylineno;
    reg_index = -1;
    offset = -1;
    is_parameter = false;
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

void IdentifiersList::addIdentifiers(string lists){
    stringstream ss(lists);
    while (ss.good()) {
        string substr;
        getline(ss, substr, '.');
        identifiers.push_back(substr);
    }
}

string IdentifiersList::createString(){
    vector<string> identifiers = this->identifiers;
    string res = "";
    for(int i=0;i<identifiers.size();i++){
        if(i+1 < identifiers.size()) res += identifiers[i] + ".";
        else res+= identifiers[i];
    }
    return res;
}

Value::Value(){
    this->dim1_count = this->dim2_count = this->dim3_count = 0;
    this->is_byte_val = this->is_char_val = this->is_short_val = false;
}

string Value::getValue(){
    string res = "";
    if(primitivetypeIndex <= LONG) res += to_string(num_val[0]);
    else if(primitivetypeIndex == FLOAT) res += to_string(float_val[0]);
    else if(primitivetypeIndex == DOUBLE) res += to_string(double_val[0]);
    else if(primitivetypeIndex == STRING) res += (string_val[0]);
    else if(primitivetypeIndex == CHAR) res += (string_val[0]);
    else {

    }
    return res;
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
    is_parameter = true;
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
    local_variables_size = 0;
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
    current_level = global_symtab->current_level;
}

NormalClassDeclaration::NormalClassDeclaration(string lex, ModifierList* list, string identifier)
    : Node(lex){
    modifiers_list = list;
    name = identifier;
    object_size = 0;
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
    primary_exp_val = "";
    entry_type = EXPRESSIONS;
}

ExpressionList::ExpressionList(string lex, Expression* single_expression, vector<Expression*> expressions)
    : Node(lex){
    lists.resize(0);
    if(single_expression != NULL)
        lists.push_back(single_expression);
    for(int i=0;i<expressions.size();i++){
        if(expressions[i]!=NULL)
            lists.push_back(expressions[i]);
    }
}

string Expression::createString(){
    if(registor_index == -1) return primary_exp_val;
    else return "t" + to_string(registor_index);
}

/* ####################   Helper funtion related to ast  #################### */

bool typenameErrorChecking(Node* node, pair<int,int> curr_level, int entry_type){
    IdentifiersList* lists = (IdentifiersList*)node;
    int n = lists->identifiers.size();
    if(n==1){
        Node* temp = get_local_symtab(curr_level)->get_entry(lists->identifiers[0], entry_type);
        if(temp != NULL) return true;
        else{
            string entry = (entry_type == -1) ? entryTypeStrings[0] : entryTypeStrings[entry_type];
            string err = "use of undeclared " + entry + " \"" + lists->identifiers[0] + "\"";
            yyerror(const_cast<char*>(err.c_str()));
            return false;
        }
    }
    else{
        LocalVariableDeclaration* obj = (LocalVariableDeclaration*)(get_local_symtab(curr_level)->get_entry(lists->identifiers[0], 0));
        // check in obj.field, obj is declared variable or not
        if(obj == NULL) {
            string entry = (entry_type == -1) ? entryTypeStrings[0] : entryTypeStrings[entry_type];
            string err = "use of undeclared " + entry + " \"" + lists->identifiers[0] + "\"";
            yyerror(const_cast<char*>(err.c_str()));
            return false;
        }
        // check in obj.field, is obj an object or not
        if(obj->type->primitivetypeIndex != -1) {
            string err = "primitive data type \"" + typeStrings[obj->type->primitivetypeIndex] + "\" does not have field named \"" + lists->identifiers[1] + "\"";
            yyerror(const_cast<char*>(err.c_str()));
            return false;
        }
        // check if the field variable is present in the obj;
        for(int i=0;i<obj->type->class_instantiated_from->field_variables.size();i++){
            if(obj->type->class_instantiated_from->field_variables[i].first->name == lists->identifiers[1]) return true;
        }
        string err = "the field variable \"" + lists->identifiers[1] + "\" not present in class \"" + obj->type->class_instantiated_from->name + "\"";
        yyerror(const_cast<char*>(err.c_str()));
        return false;
    }
    string entry = (entry_type == -1) ? entryTypeStrings[0] : entryTypeStrings[entry_type];
    string err = "use of undeclared " + entry + " \"" + lists->identifiers[0] + "\"";
    yyerror(const_cast<char*>(err.c_str()));
    return false;
}

bool addVariablesToSymtab(Type* t, VariableDeclaratorList* declarator_list, pair<int,int> curr_level, ModifierList* modif_lists, bool is_field_variable){
    for(int i=0;i<declarator_list->lists.size();i++){        
        if(declarator_list->lists[i]->initialized_value != NULL){
            int exp_type = t->primitivetypeIndex;
            int given_type = declarator_list->lists[i]->initialized_value->primitivetypeIndex;
            if(!((given_type <= LONG && exp_type <= LONG) || (given_type == exp_type) || (given_type <= DOUBLE && (exp_type == FLOAT || exp_type == DOUBLE)))){
                string err = "invalid datatypes, cannot convert from \"" + typeStrings[given_type] + "\" to \"" + typeStrings[exp_type] + "\"";
                yyerror(const_cast<char*>(err.c_str()));
                return false;
            }
        }
        if(declarator_list->lists[i]->initialized_value != NULL && declarator_list->lists[i]->num_of_dims > 0){
            int exp_type = t->primitivetypeIndex;
            int given_type = declarator_list->lists[i]->initialized_value->primitivetypeIndex;
            if(given_type != exp_type){
                string err = "invalid datatypes, cannot convert from \"" + typeStrings[given_type] + "\" to \"" + typeStrings[exp_type] + "\"";
                yyerror(const_cast<char*>(err.c_str()));
                return false;
            }
        }
        // cout<<declarator_list->lists[i]->num_of_dims<<endl;
        LocalVariableDeclaration* locale = new LocalVariableDeclaration("local_variable_declaration", t, declarator_list->lists[i], modif_lists);
        int tt = findEmptyRegistor();
        locale->reg_index = tt;
        locale->offset = functionOffset;
        functionOffset += 8;    // always increasing by 8 bytes, so that mera dimag kharab na ho :(
        temporary_registors_in_use[tt] = true;
        locale->isFieldVariable = is_field_variable;
        locale->entry_type = VARIABLE_DECLARATION;
        locale->name = declarator_list->lists[i]->identifier;
        if(is_field_variable == true){
            curr_class->field_variables.push_back({locale, curr_class->object_size});
            curr_class->object_size += typeSizes[t->primitivetypeIndex];
        }
        get_local_symtab(global_symtab->current_level)->add_entry(locale);
    }
    return true;
}

Value* createObject(string class_name, ExpressionList* exp_list, pair<int,int> curr_level){
    MethodDeclaration* constructor_ptr = (MethodDeclaration*)(get_local_symtab(curr_level)->get_entry(class_name, METHOD_DECLARATION));
    NormalClassDeclaration* class_ptr = (NormalClassDeclaration*)(get_local_symtab(curr_level)->get_entry(class_name, CLASS_DECLARATION));
    if(class_ptr == NULL){
        string err = "use of undeclared class name \"" + class_name + "\"";
        yyerror(const_cast<char*>(err.c_str()));
        return NULL;
    }
    Value* obj = new Value();
    obj->primitivetypeIndex = -1;
    obj->class_type = class_ptr;
    int given_param = exp_list->lists.size();
    if(constructor_ptr == NULL && given_param>0) {
        string err = "invalid number of arguments while creating object of class \"" + class_name + "\"\ngiven " + to_string(given_param)  + " expected 0";
        yyerror(const_cast<char*>(err.c_str()));
        return NULL;
    }
    else if(constructor_ptr == NULL && given_param == 0){
        // cout<<"No constructor present\n";
        return obj;
        // call 3ac code-
    }
    else if(constructor_ptr != NULL){
        // cout<<"Constructor present\n";
        vector<FormalParameter*> parameters = constructor_ptr->formal_parameter_list->lists;
        if(parameters.size() != given_param){
            string err = "invalid number of arguments while creating object of class \"" + class_name + "\"\ngiven " + to_string(given_param)  + " expected " + to_string(parameters.size());
            yyerror(const_cast<char*>(err.c_str()));
            return NULL;
        }
        for(int i=0;i<given_param;i++){
            int given_type = parameters[i]->param_type->primitivetypeIndex, expected_type = exp_list->lists[i]->value->primitivetypeIndex;
            if(given_type != expected_type) {
                string err = "type mismatch in arguments list while creating object of class \"" + class_name + "\"\ngiven datatype" + typeStrings[given_type]  + " expected " + typeStrings[expected_type];
                yyerror(const_cast<char*>(err.c_str()));
                return NULL;
            }
        }
        for(int i=0;i<given_param;i++){
            // print 3ac code for calling funtion with given parameters;
            
        }
        return obj;
    }
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

int create3ACCode(Node* root, bool print){
    int res = 0;
    if(root == NULL) return res;
    if(root->entry_type == CLASS_DECLARATION){
        current_class_name = root->name;
        for(int i=0;i<root->children.size();i++){
            res+=create3ACCode(root->children[i], print);
        }
    }
    else if(root->entry_type == METHOD_DECLARATION){
        if(print){
            cout<<current_class_name<<"."<<root->name<<":\n";
            cout<<"beginfunc\n";
        }
        vector<FormalParameter*> list = ((MethodDeclaration*)(root))->formal_parameter_list->lists;
        vector<int> reg(list.size(), -1);
        for(int i=0;i<list.size();i++){
            int t = list[i]->reg_index;
            reg[i] = t;
            if(print){
                cout<<"\t"<<to_string(curr_address)<<":\t"<<"t"<<to_string(t)<<" = popparam\n";
                curr_address++;
            }
            res++;
        }
        for(int i=0;i<root->children.size();i++){
            res+=create3ACCode(root->children[i], print);
        }
        if(print){
            cout<<"\t"<<to_string(curr_address)<<":\treturn\n";
            curr_address++;
            cout<<"endfunc\n";
            stack_frame_pointer = 0;
        }
        res++;
    }
    else if(root->entry_type == VARIABLE_DECLARATION){
        // variable_declarator_id ASSIGNMENT_OP variable_initializer
        // ignore the declaration if it is a formal parameter declaration
        if(root->is_parameter) return res;
        LocalVariableDeclaration* var = (LocalVariableDeclaration*)(get_local_symtab(root->current_level)->get_entry(root->name, 0));
        // ignoring for field variables
        if(var->isFieldVariable) return res;
        if(root->children.size() > 2) res+=create3ACCode(root->children[2], print);
        if(print){
            cout<<"\t"<<to_string(curr_address)<<":\tpush "<<root->name<<endl;
            curr_address++;
        }
        res++;
        int t = var->type->primitivetypeIndex;
        int x = (t != -1) ? typeSizes[t] : var->type->class_instantiated_from->object_size;
        // cout<<"stack value : "<<x<<endl;
        // if(t == -1) cout<<var->type->class_instantiated_from<<endl;
        int t2 = findEmptyRegistor();
        // getting the offset of the variable declared on the stack
        if(print){
            cout<<"\t"<<to_string(curr_address)<<":\tt"<<to_string(t2)<<" = %sp + "<<stack_frame_pointer<<endl;
            curr_address++;
        }
        res++;
        if(print){
            if(var->variable_declarator->initialized_value != NULL && (var->variable_declarator->initialized_value->dim1_count > 0 || var->type->primitivetypeIndex == -1))
                cout<<"\t"<<to_string(curr_address)<<":\tt"<<to_string(var->reg_index)<<" = t"<<to_string(t2)<<endl;
            else 
                cout<<"\t"<<to_string(curr_address)<<":\tt"<<to_string(var->reg_index)<<" = *t"<<to_string(t2)<<endl;
            curr_address++;
        }
        res++;
        if(print){
            if(var->variable_declarator->initialized_value != NULL && var->variable_declarator->initialized_value->dim1_count > 0)
                x = (x)*(var->variable_declarator->initialized_value->dim1_count);
            stack_frame_pointer+=x;
            cout<<"\t"<<to_string(curr_address)<<":\tstackpointer+00"<<to_string(x)<<endl;
            curr_address++;
        }
        res++;
        if(var->variable_declarator->initialized_value != NULL && var->variable_declarator->initialized_value->dim1_count == 0 && var->type->primitivetypeIndex != -1){
            cout<<"\t"<<to_string(curr_address)<<":\tt"<<to_string(var->reg_index)<<" = "<<((Expression*)root->children[2])->createString()<<endl;
            curr_address++;
        }
        res++;
    }
    else if(root->entry_type == EXPRESSIONS){
        vector<int> codes = root->code;
        for(int i=0;i<root->children.size();i++){
            res+=create3ACCode(root->children[i], print);
        }
        for(int i=0;i<codes.size();i++){
            res++;
            if(print) {
                cout<<"\t"<<to_string(curr_address)<<":\t";
                print3AC(threeAC_list[codes[i]]);
                curr_address++;
            }
        }
    }
    else if(root->entry_type == METHOD_INVOCATION){
        // IDENTIFIERS  OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT
        int n = ((ExpressionList*)(root->children[2]))->lists.size();
        vector<int> reg(n, -1);
        for(int i=0;i<n;i++){
            int t = findEmptyRegistor();
            reg[i] = t;
            Expression* temp = ((ExpressionList*)(root->children[2]))->lists[i];
            res+=create3ACCode(temp, print);
            if(print){
                cout<<"\t"<<to_string(curr_address)<<":\tt"<<to_string(t)<<" = "<<temp->createString()<<endl;
                curr_address++;
            }
            temporary_registors_in_use[t] = true;
            res++;
        }
        for(int i=0;i<n;i++){
            if(print){
                cout<<"\t"<<to_string(curr_address)<<":\tpushparam "<<"t"<<to_string(reg[i])<<endl;
                curr_address++;
            }
            res++;
            temporary_registors_in_use[reg[i]] = false;
        }
        if(print){
            cout<<"\t"<<to_string(curr_address)<<":\tcall "<<root->name<<endl;
            curr_address++;
            cout<<"\t"<<to_string(curr_address)<<":\t"<<((Expression*)(root))->createString()<<" = %rax"<<endl;
            curr_address++;
        }
        res+=2;
    }
    else if(root->entry_type == IF_THEN_STATEMENT){
        // IF_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement
        Expression* temp = (Expression*)root->children[2];
        res+=create3ACCode(temp, print);
        int gotoL1 = create3ACCode(root->children[4], false) + curr_address;
        string str = "\t" + to_string(curr_address) + ":\tif t"+ to_string(temp->registor_index) + " == false goto " + to_string(gotoL1+1);
        if(print) {
            cout<<str<<endl;
            curr_address++;
        }
        res++;
        res+=create3ACCode(root->children[4], print);
    }
    else if(root->entry_type == IF_THEN_ELSE_STATEMENT){
        // IF_KEYWORD  OP_BRCKT expression CLOSE_BRCKT statement_no_short_if ELSE_KEYWORD statement
        Expression* temp = (Expression*)root->children[2];
        res+=create3ACCode(temp, print);
        int gotoL1 = create3ACCode(root->children[4], false) + curr_address;
        string str = "\t" + to_string(curr_address) + ":\tif t"+ to_string(temp->registor_index) + " == false goto " + to_string(gotoL1+2);
        if(print) {
            cout<<str<<endl;
            curr_address++;
        }
        res++;
        res+=create3ACCode(root->children[4], print);
        int gotoL2 = create3ACCode(root->children[6], false) + curr_address;
        string str2 = "\t" + to_string(curr_address) + ":\tgoto " + to_string(gotoL2+1);
        if(print){
            cout<<str2<<endl;
            curr_address++;
        }
        res++;
        res+=create3ACCode(root->children[6], print);
    }
    else if(root->entry_type == WHILE_STATEMENT){
        // WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement
        Expression* temp = (Expression*)root->children[2];
        int loop_posn = curr_address;
        res+=create3ACCode(temp, print);
        int gotoL1 = create3ACCode(root->children[4], false) + curr_address;
        string str = "\t" + to_string(curr_address) + ":\tif t"+ to_string(temp->registor_index) + " == false goto " + to_string(gotoL1+2);
        if(print) {
            cout<<str<<endl;
            curr_address++;
        }
        res++;
        res+=create3ACCode(root->children[4], print);
        string str2 = "\t" + to_string(curr_address) + ":\tgoto " + to_string(loop_posn);
        if(print) {
            cout<<str2<<endl;
            curr_address++;
        }
        res++;
    }
    else if(root->entry_type == FOR_STATEMENT){
        // FOR_KEYWORD OP_BRCKT for_init_zero_or_one SEMICOLON_OP expression_zero_or_one SEMICOLON_OP for_update_zero_or_one CLOSE_BRCKT statement
        res+=create3ACCode(root->children[2], print);
        Expression* temp = (Expression*)root->children[4];
        int loop_posn = curr_address;
        res+=create3ACCode(root->children[4], print);
        int gotoL1 = create3ACCode(root->children[8], false) + curr_address + create3ACCode(root->children[6], false);
        // if(temp->registor_index != -1){
            string str = "\t" + to_string(curr_address) + ":\tif t"+ to_string(temp->registor_index) + " == false goto " + to_string(gotoL1+2);
            if(print) {
                cout<<str<<endl;
                curr_address++;
            }
            res++;
        // }
        res+=create3ACCode(root->children[8], print);
        res+=create3ACCode(root->children[6], print);
        string str2 = "\t" + to_string(curr_address) + ":\tgoto " + to_string(loop_posn);
        if(print) {
            cout<<str2<<endl;
            curr_address++;
        }
        res++;
    }
    else if(root->entry_type == TERNARY_EXPRESSION){
        // conditional_or_expression QN_OP expression COLON_OP condtional_expression
        Expression* temp = (Expression*)root->children[0];
        res+=create3ACCode(temp, print);
        res+=create3ACCode(root->children[2], true);
        int gotoL1 = create3ACCode(root->children[2], false) + curr_address;
        string str = "\t" + to_string(curr_address) + ":\tif t"+ to_string(temp->registor_index) + " == false goto " + to_string(gotoL1+2);
        if(print) {
            cout<<str<<endl;
            curr_address++;
        }
        res++;
        res+=create3ACCode(root->children[2], print);
        int gotoL2 = create3ACCode(root->children[4], false) + curr_address;
        string str2 = "\t" + to_string(curr_address) + ":\tgoto " + to_string(gotoL2+1);
        if(print){
            cout<<str2<<endl;
            curr_address++;
        }
        res++;
        res+=create3ACCode(root->children[4], print);
        // (Expression*)root->registor_index = 
    }
    else{
        for(int i=0;i<root->children.size();i++){
            res+=create3ACCode(root->children[i], print);
        }
    }

    return res;
}

bool checkParams(string name, ExpressionList* exp_list){
    // need to do;
    return true;
}

int findEmptyCalleeSavedRegistor(){
    int n = calleeSavedInUse.size();
    for(int i=0;i<n;i++){
        if(calleeSavedInUse[i] == false) {
            calleeGlobalCalled[i] = true;
            return i;
        }
    }
    return -1;
}

string convertOperator(string op){
    if(op == "+") return "addq";
    else if(op == "-") return "subq";
    else if(op == "*") return "imulq";
    else if(op == "/") return "idivq";
    else if(op == "&") return "andq";
    else if(op == "|") return "orq";
    else if(op == "^") return "xorq";
    else if(op == ">>") return "shrq";
    else if(op == "<<") return "shlq";
}

void createAsm(Node* root){
    if(root == NULL) return ;
    if(root->entry_type == CLASS_DECLARATION){
        for(int i=0;i<root->children.size();i++){
            createAsm(root->children[i]);
        }
    }
    else if(root->entry_type == METHOD_DECLARATION){
        cout<<root->name<<":\n";
        cout<<"\tpushq\t%rbp"<<endl;
	    cout<<"\tmovq\t%rsp, %rbp"<<endl;
        vector<FormalParameter*> list = ((MethodDeclaration*)(root))->formal_parameter_list->lists;
        vector<int> registors = ((MethodDeclaration*)(root))->calleeRegCalled;
        for(int i=0;i<registors.size();i++){
            cout<<"\tpushq "<<calleeSavedRegistors[registors[i]]<<endl;
        }
        for(int i=0;i<list.size();i++){
            // int off = get_local_symtab(root->current_level)->get_entry(list[i]->variable_declarator_id->identifier, VARIABLE_DECLARATION)->offset;
            // pop param
        }
        for(int i=0;i<root->children.size();i++){
            createAsm(root->children[i]);
        }
        for(int i=registors.size()-1;i>=0;i--){
            cout<<"\tpopq\t"<<calleeSavedRegistors[registors[i]]<<endl;
        }
        cout<<"\tpopq\t%rbp"<<endl;
        cout<<"\tret"<<endl;
    }
    else if(root->entry_type == VARIABLE_DECLARATION){
        // variable_declarator_id ASSIGNMENT_OP variable_initializer
        // ignore the declaration if it is a formal parameter declaration
        if(root->is_parameter) return ;
        LocalVariableDeclaration* var = (LocalVariableDeclaration*)(get_local_symtab(root->current_level)->get_entry(root->name, 0));
        // ignoring for field variables
        if(var->isFieldVariable) return ;
        if(root->children.size() > 2) createAsm(root->children[2]);
        if(root->children.size() == 1)
            cout<<"\tmovq\t$0, -"<<var->offset<<"(%rbp)\n";
        else 
            cout<<"\tmovq\t"<<calleeSavedRegistors[root->children[2]->calleeSavedRegistorIndex]<<", -"<<var->offset<<"(%rbp)\n";
    }
    else if(root->entry_type == EXPRESSIONS){
        // vector<int> codes = root->code;
        for(int i=0;i<root->children.size();i++){
            createAsm(root->children[i]);
        }
        for(int i=0;i<root->x86_64.size();i++){
            cout<<"\t"<<root->x86_64[i]<<endl;
        }
    }
    else if(root->entry_type == METHOD_INVOCATION){
        // IDENTIFIERS  OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT
    }
    else if(root->entry_type == IF_THEN_STATEMENT){
        // IF_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement

    }
    else if(root->entry_type == IF_THEN_ELSE_STATEMENT){
        // IF_KEYWORD  OP_BRCKT expression CLOSE_BRCKT statement_no_short_if ELSE_KEYWORD statement
    }
    else if(root->entry_type == WHILE_STATEMENT){
        // WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement
    }
    else if(root->entry_type == FOR_STATEMENT){
        // FOR_KEYWORD OP_BRCKT for_init_zero_or_one SEMICOLON_OP expression_zero_or_one SEMICOLON_OP for_update_zero_or_one CLOSE_BRCKT statement
    }
    else if(root->entry_type == TERNARY_EXPRESSION){
        // conditional_or_expression QN_OP expression COLON_OP condtional_expression
    }
    else{
        for(int i=0;i<root->children.size();i++){
            createAsm(root->children[i]);
        }
        for(int i=0;i<root->x86_64.size();i++){
            cout<<"\t"<<root->x86_64[i]<<endl;
        }
    }
    return ;
}