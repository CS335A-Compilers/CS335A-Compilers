#include "bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;

extern void yyerror(char const*);
extern GlobalSymbolTable* global_symtab;
extern vector<bool> temporary_registors_in_use;
extern vector<ThreeAC*> threeAC_list;
extern vector<int> typeSizes;
extern vector<string> calleeSavedRegistors;
extern vector<string> smallCalleeSavedRegistors;
extern int label_count;
extern vector<bool> calleeSavedInUse;
// Define an array of strings that corresponds to the type values.
vector<string> typeStrings = {"char", "byte", "short", "int", "long", "float", "double", "boolean", "array", "string", "void"};

double getValue(Value* val){
    switch (val->primitivetypeIndex){
    case 0:
        return (double)(val->num_val[0]);
        break;
    case 1:
        return (double)(val->num_val[0]);
        break;
    case 2:
        return (double)(val->num_val[0]);
        break;
    case 3:
        return (double)(val->num_val[0]);
        break;
    case 4:
        return (double)(val->num_val[0]);
        break;
    case 5:
        return (double)(val->float_val[0]);
        break;
    case 6:
        return (double)(val->double_val[0]);
        break;
    case 7:
        return (double)(val->boolean_val[0]);
        break;
    //case 7:
       // return (double)(val->boolean_val[0]);
        //break;
    //case 8:
        //return (double)(val->num_val[0]);
        //break;
    
    default:
        break;
    }
}

double doubleMod(double a, double b) {
    // determine the common factor dynamically based on the number of decimal places in the inputs
    int factor = pow(10, max(numeric_limits<double>::digits10 - floor(log10(abs(a))), 
                                        numeric_limits<double>::digits10 - floor(log10(abs(b)))));
    long long intA = static_cast<long long>(a * factor);
    long long intB = static_cast<long long>(b * factor);
    long long intResult = intA % intB;
    double result = static_cast<double>(intResult) / factor;
    return result;
}

Expression* grammar_1(string lex,Expression* e1,bool isprimary,bool isliteral){
    if (e1 == NULL) return NULL;
    Expression* obj = new Expression(lex, e1->value, isprimary, isliteral);
    obj->value = e1->value;
    obj->registor_index = e1->registor_index;
    obj->name = e1->name;
    obj->primary_exp_val = e1->primary_exp_val;
    obj->reg_index = e1->reg_index;
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    obj->offset = e1->offset;
    return obj;
}

// Segmentation fault on character eg : a = (false) ? 'k' : 6;
Expression* cond_qn_co(string lex, Expression* e1, Expression* e2, Expression* e3){
    if (e1 == NULL || e2 == NULL)
        return NULL;
    /*
    Conditional Ternary Operator : type conversion between "char", "byte", "short", 
                                    "int", "long", "float", "double"
    */
    int type1 = e2->value->primitivetypeIndex;
    int type2 = e3->value->primitivetypeIndex;
    string data_type1, data_type2;
    if (type1 != -1){
        data_type1 = typeStrings[type1];
    }
    if (type2 != -1){
        data_type2 = typeStrings[type2];
    }
    string error = "Type mismatch: cannot convert from " + data_type1 + " to " + data_type2;
    if (e1->value->primitivetypeIndex != BOOLEAN || (e2->value->primitivetypeIndex == 10 || e3->value->primitivetypeIndex == 10)){
        yyerror(error.c_str());
        return NULL;
    }
    Value* va = new Value();
    va->primitivetypeIndex = max(e2->value->primitivetypeIndex, e3->value->primitivetypeIndex);
    Expression *obj = new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, NULL, NULL, "", 0));
    return obj;
}

Expression* evalOR_AND(string lex, Expression* e1, string op, Expression* e2){
    if (e1 == NULL || e2 == NULL)
        return NULL;
    if (e1->value->primitivetypeIndex != BOOLEAN || e2->value->primitivetypeIndex != BOOLEAN){
        int type1 = e1->value->primitivetypeIndex;
        int type2 = e2->value->primitivetypeIndex;
        string data_type1, data_type2;
        if (type1 != -1){
            data_type1 = typeStrings[type1];
        }
        if (type2 != -1){
            data_type2 = typeStrings[type2];
        }
        string error = "The operator " + op + " is undefined for the argument types " + data_type1 + ", " + data_type2;
        yyerror(error.c_str());
        return NULL;
    }

    Value* va = new Value();
    va->primitivetypeIndex = BOOLEAN;
    Expression *obj = new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    calleeSavedInUse[e2->calleeSavedRegistorIndex] = false;
    obj->x86_64.push_back(convertOperator(op) + "\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj;  
}

Expression* evalBITWISE(string lex, Expression* e1, string op, Expression* e2){
    if (e1 == NULL || e2 == NULL)
        return NULL;
    if ((e1->value->primitivetypeIndex > LONG || e2->value->primitivetypeIndex > LONG)){
        yyerror("Incompatible types: cannot be converted to type accepted for bitwise operator");
        return NULL;
    } 
    long long int val;
    Value* va = new Value();
    va->primitivetypeIndex = max(e2->value->primitivetypeIndex, e1->value->primitivetypeIndex);
    Expression* obj=new Expression(lex,va,false,false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    calleeSavedInUse[e2->calleeSavedRegistorIndex] = false;
    obj->x86_64.push_back(convertOperator(op) + "\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    return obj; 
}

//done for prmitive data type only, not for reference data type like array,string,char and object
Expression* evalEQ(string lex,Expression* e1,string op,Expression* e2){
    if(e1==NULL||e2==NULL)
        return NULL;
    int t1 = e1->value->primitivetypeIndex, t2 = e2->value->primitivetypeIndex;
    if (!((t1 < 7 && t2 < 7) || (t1 == t2) && (t1 != 10 && t2 != 10)))
    {
        yyerror("Incomparable operand types: cannot be compared");
        return NULL;
    }
    bool val;
    Value* va = new Value();
    // va->boolean_val.push_back(val);oi
    va->primitivetypeIndex = 7;
    Expression *obj = new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    calleeSavedInUse[e2->calleeSavedRegistorIndex] = false;
    obj->x86_64.push_back("cmpq\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->x86_64.push_back(convertOperator(op) + "\t" + smallCalleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->x86_64.push_back("movzbq\t" + smallCalleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj;
}

Expression* evalRELATIONAL(string lex, Expression* e1, string op, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > DOUBLE || e2->value->primitivetypeIndex > DOUBLE){
        yyerror("Incomparable types: cannot be compared");
        return NULL;
    }
    Value* va= new Value();
    va->primitivetypeIndex = 7;
    Expression* obj=new Expression(lex,va,false,false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    calleeSavedInUse[e2->calleeSavedRegistorIndex] = false;
    obj->x86_64.push_back("cmpq\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->x86_64.push_back(convertOperator(op) + "\t" + smallCalleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->x86_64.push_back("movzbq\t" + smallCalleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj;
}

Expression* evalSHIFT(string lex, Expression* e1, string op, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > LONG || e2->value->primitivetypeIndex > LONG){
        yyerror("Incompatible types: cannot be conveted");
        return NULL;
    }
    Value* va= new Value();
    va->primitivetypeIndex = 4;
    Expression* obj=new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    calleeSavedInUse[e2->calleeSavedRegistorIndex] = false;
    obj->x86_64.push_back(convertOperator(op) + "\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    return obj;   
}

Expression* evalARITHMETIC(string lex, string op, Expression* e1, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if (e1->value->primitivetypeIndex > DOUBLE || e2->value->primitivetypeIndex > DOUBLE){
        yyerror("Bad operand types for arthimetic operator");
        return NULL;
    }
    Value* va = new Value();
    int type1 = e2->value->primitivetypeIndex, type2 = e1->value->primitivetypeIndex;
    va->primitivetypeIndex = max(type1, type2);
    Expression* obj=new Expression(lex,va,false,false);
    if(type1 != type2) {
        string convertingType = typeStrings[va->primitivetypeIndex];
        Expression* temp = new Expression("cast expression", NULL, false, false);
        if(type1 > type2){
            obj->code.push_back(addInstruction(temp, NULL, e1, "(" + convertingType + ")", 0));
            obj->code.push_back(addInstruction(obj, temp, e2, op ,0));
        }
        else {
            obj->code.push_back(addInstruction(temp, NULL, e2, "("+ convertingType + ")", 0));
            obj->code.push_back(addInstruction(obj, temp, e1, op ,0));
        }
    }
    else obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    if(op != "/" && op != "%"){
        obj->x86_64.push_back(convertOperator(op) + "\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    }
    else {
        obj->x86_64.push_back("movq\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", %rax");
        obj->x86_64.push_back("cqo");
        obj->x86_64.push_back("idivq\t" + calleeSavedRegistors[e2->calleeSavedRegistorIndex]);
        if(op == "/"){
            obj->x86_64.push_back("movq\t%rax, " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
        }
        else{
            obj->x86_64.push_back("movq\t%rdx, " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
        }
    }
    calleeSavedInUse[e2->calleeSavedRegistorIndex] = false;
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj;
}

Expression* evalUNARY(string lex, string op, Expression* e1){
    //don't know how to do this
    if(e1 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > 6){
        yyerror("Bad operand types for unary operator");
        return NULL;
    }
    Value* va= new Value();
    va->primitivetypeIndex = e1->value->primitivetypeIndex;
    Expression* obj=new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, NULL, e1, op, 0));
    if(op == "-"){
        obj->x86_64.push_back("neg\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    }
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj; 
}

// make different function for preincrement and postincrement;
Expression* evalIC_DC(string lex, string op, Expression* e1, bool preOperation){
    if(e1 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > 6){
        yyerror("Bad operand types for increment or decrement operator");
        return NULL;
    }
    Value* va = new Value();
    va->primitivetypeIndex = e1->value->primitivetypeIndex;
    Expression* obj = new Expression(lex, va, false, false);
    // assuming for post increment; change afterwards
    Expression* temp = new Expression("increment_expression", NULL, false, false);
    Expression* temp1 = new Expression("increment_expression", NULL, false, false);
    Value* val = new Value();
    val->primitivetypeIndex = INT;
    Expression* one = new Expression("one value", val, true, true);
    one->primary_exp_val = "1";
    string new_op = op.substr(0,1);
    int off = get_local_symtab(global_symtab->current_level)->get_entry(e1->name, VARIABLE_DECLARATION)->offset;
    if(preOperation){
        obj->code.push_back(addInstruction(temp1, e1, one, new_op, 0));
        obj->code.push_back(addInstruction(e1, temp1, NULL, "", 0));
        obj->registor_index = temp1->registor_index;
        obj->x86_64.push_back(convertOperator(new_op)  + "\t$1, " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
        obj->x86_64.push_back("movq\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", -" +  to_string(off) + "(%rbp)");
        obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    }
    else{
        obj->code.push_back(addInstruction(temp, e1, NULL, "", 0));
        obj->code.push_back(addInstruction(temp1, e1, one, new_op, 0));
        obj->code.push_back(addInstruction(e1, temp1, NULL, "", 0));
        obj->registor_index = temp->registor_index;
        int new_reg = findEmptyCalleeSavedRegistor();
        // cout<<"new reg: "<<new_reg<<endl;
        calleeSavedInUse[new_reg] = true;
        obj->x86_64.push_back("movq\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", " + calleeSavedRegistors[new_reg]);
        obj->calleeSavedRegistorIndex = new_reg;
        obj->x86_64.push_back(convertOperator(new_op)  + "\t$1, " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
        obj->x86_64.push_back("movq\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", -" +  to_string(off) + "(%rbp)");
        calleeSavedInUse[e1->calleeSavedRegistorIndex] = false;
    }
    return obj;
}

Expression* evalTL(string lex, Expression* e1){
    if(e1 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > 4){
        yyerror("Bad operand types for bitwise complement operator");
        return NULL;
    }
    Value* va= new Value();
    va->primitivetypeIndex = e1->value->primitivetypeIndex;
    Expression* obj=new Expression(lex, va, false, false);
    int off = get_local_symtab(global_symtab->current_level)->get_entry(e1->name, VARIABLE_DECLARATION)->offset;
    obj->code.push_back(addInstruction(obj, NULL, e1, "~", 0));
    obj->x86_64.push_back("notq\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->x86_64.push_back("movq\t" + calleeSavedRegistors[e1->calleeSavedRegistorIndex] + ", -" + to_string(off) + "(%rbp)");
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj; 
}

Expression* evalEX(string lex, Expression* e1){
    if(e1 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex != 7){
        string err = "Bad operand type for unary operator '!', expected boolean, given " + typeStrings[e1->value->primitivetypeIndex];
        yyerror(const_cast<char*>(err.c_str()));
        return NULL;
    }
    Value* va = new Value();
    va->primitivetypeIndex = 7;
    Expression* obj = new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, NULL, e1, "!", 0));
    obj->x86_64.push_back("xorq\t$1, " + calleeSavedRegistors[e1->calleeSavedRegistorIndex]);
    obj->calleeSavedRegistorIndex = e1->calleeSavedRegistorIndex;
    return obj; 
}

Expression* assignValue(Expression* type_name, string op, Expression* exp, string ident){
    LocalVariableDeclaration* name = (LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry(ident, -1));
    // if(name == NULL){
    //     yyerror("use of undeclared variable");
    //     return NULL;
    // }
    Expression* obj = new Expression("assignment", NULL, false, false);
    if(name->entry_type == VARIABLE_DECLARATION){
        int name_type = name->type->primitivetypeIndex;
        int exp_type = exp->value->primitivetypeIndex;
        if((name_type >= exp_type) || op.length() > 1) {
            int off = get_local_symtab(global_symtab->current_level)->get_entry(ident, -1)->offset;
            int exp_index = exp->calleeSavedRegistorIndex;
            if(op == "="){
                if(name_type != exp_type){
                    Expression* temp = new Expression("cast expression", NULL, false, false);
                    obj->code.push_back(addInstruction(temp, NULL, exp, "(" + typeStrings[name_type] + ")", 0));
                    obj->code.push_back(addInstruction(type_name, temp, NULL, "", 0));
                }
                else{
                    obj->code.push_back(addInstruction(type_name, exp, NULL, "", 0));
                }
                obj->x86_64.push_back("movq\t" + calleeSavedRegistors[exp_index] + ", -" + to_string(off) + "(%rbp)");
            }
            else{
                int pos = op.find('=');
                string fin_op = op.substr(0, pos);
                Expression* temp = new Expression("typename", NULL, false, false);
                if(name_type == exp_type){
                    obj->code.push_back(addInstruction(temp, type_name, exp, fin_op, 0));
                }
                else{
                    Expression* temp1 = new Expression("cast expression", NULL, false, false);
                    obj->code.push_back(addInstruction(temp1, NULL, exp, "(" + typeStrings[name_type] +")", 0));
                    obj->code.push_back(addInstruction(temp, type_name, temp1, fin_op, 0));
                }
                obj->code.push_back(addInstruction(type_name, temp, NULL, "", 0));
                if(fin_op[0] == '>' || fin_op[0] == '<'){
                    // use CL registor to store the exp value
                    obj->x86_64.push_back("movq\t" + calleeSavedRegistors[exp_index] + ", %rcx");
                    obj->x86_64.push_back(convertOperator(fin_op) + "\t" + "%rcx" + ", -" + to_string(off) + "(%rbp)");
                }
                else{
                    obj->x86_64.push_back(convertOperator(fin_op) + "\t" + calleeSavedRegistors[exp_index] + ", -" + to_string(off) + "(%rbp)");
                }
                obj->x86_64.push_back("movq\t-" + to_string(off) + "(%rbp), " + calleeSavedRegistors[exp_index]);
            }
            obj->calleeSavedRegistorIndex = exp_index;
            // obj->value = exp->value;
            return obj;
        }
        else{
            string err = "invalid types for assignment, cannot convert from \"" + typeStrings[exp_type] + "\" to " + typeStrings[name_type] + "\"";
            yyerror(const_cast<char*>(err.c_str()));
            return NULL;
        }
    }
    else{
        string err = "type mismatch, cannot assign value to \"" + name->name + "\"";
        yyerror(const_cast<char*>(err.c_str()));
        return NULL;
    }
}

Expression* assignArrayValue(IdentifiersList* type_name, Expression* index, string op, Expression* exp){
    LocalVariableDeclaration* temp = (LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry(type_name->identifiers[0], VARIABLE_DECLARATION)) ;
    Expression* obj = new Expression("assignment", NULL, false, false);
    if(temp == NULL){
        string err = "use of undeclared variable \"" + type_name->identifiers[0] + "\"";
        yyerror(const_cast<char*>(err.c_str()));
        return NULL;
    }
    int off = temp->offset;
    int nn = findEmptyCalleeSavedRegistor();
    if(op == "="){
        obj->x86_64.push_back("leaq\t-" + to_string(off) + "(%rbp), " + calleeSavedRegistors[nn]);
        obj->x86_64.push_back("movq\t" + calleeSavedRegistors[exp->calleeSavedRegistorIndex] + ", (" + calleeSavedRegistors[nn] + ", " + calleeSavedRegistors[index->calleeSavedRegistorIndex] + ", 8)");
    }
    else{
        int pos = op.find('=');
        string fin_op = op.substr(0, pos);
        obj->x86_64.push_back("leaq\t-" + to_string(off) + "(%rbp), " + calleeSavedRegistors[nn]);
        obj->x86_64.push_back("movq\t(" + calleeSavedRegistors[nn] + ", " + calleeSavedRegistors[index->calleeSavedRegistorIndex] + ", 8), " + calleeSavedRegistors[exp->calleeSavedRegistorIndex] );
        if(fin_op[0] == '>' || fin_op[0] == '<'){
            // use CL registor to store the exp value
            obj->x86_64.push_back("movq\t" + calleeSavedRegistors[exp->calleeSavedRegistorIndex] + ", %rcx");
            obj->x86_64.push_back(convertOperator(fin_op) + "\t" + "%rcx" + ", (" + calleeSavedRegistors[nn] + ", " + calleeSavedRegistors[index->calleeSavedRegistorIndex] + ", 8)");
        }
        obj->x86_64.push_back(convertOperator(fin_op) + "\t" + calleeSavedRegistors[exp->calleeSavedRegistorIndex] + ", (" + calleeSavedRegistors[nn] + ", " + calleeSavedRegistors[index->calleeSavedRegistorIndex] + ", 8)");
    }
    obj->calleeSavedRegistorIndex = exp->calleeSavedRegistorIndex;
    calleeSavedInUse[index->calleeSavedRegistorIndex] = false;
    return obj;
}

void assignLiteralValue(Expression* literal, Expression* e){
    int type = literal->value->primitivetypeIndex;
    if(type == INT) e->value->num_val.push_back(literal->value->num_val[0]);
    else if(type == FLOAT) e->value->float_val.push_back(literal->value->float_val[0]);
    else if(type == BOOLEAN) e->value->boolean_val.push_back(literal->value->boolean_val[0]);
    else if(type == DOUBLE) e->value->double_val.push_back(literal->value->double_val[0]);
    return ;
}

Expression* getArrayAccess(string ident, Expression* e){
    Value* val = new Value();
    LocalVariableDeclaration* temp = (LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry(ident, 0)) ;
    if(temp == NULL){
        string err = "use of undeclared variable \"" + ident + "\"";
        yyerror(const_cast<char*>(err.c_str()));
        return NULL;
    }
    val->primitivetypeIndex = temp->type->primitivetypeIndex;
    Expression* node = new Expression("array_access", val, false, false);
    node->name = ident;
    int t = get_local_symtab(global_symtab->current_level)->get_entry(ident, 0)->reg_index;
    int new_t = findEmptyRegistor();
    temporary_registors_in_use[new_t] = true;
    node->registor_index = new_t;
    Expression* temp1 = new Expression("array_access", NULL, false, false);
    Expression* size_exp = new Expression("size_expression", NULL, true, false);
    size_exp->primary_exp_val = to_string(typeSizes[temp->type->primitivetypeIndex]);
    node->code.push_back(addInstruction(temp1, e, size_exp, "*", 0));
    ThreeAC* inst = new ThreeAC("+", "", new_t, t, temp1->registor_index, "", "", 0);
    node->code.push_back(threeAC_list.size());
    node->primary_exp_val = "*t" + to_string(new_t);
    node->isPrimary = true;
    threeAC_list.push_back(inst);

    int off = get_local_symtab(global_symtab->current_level)->get_entry(ident, VARIABLE_DECLARATION)->offset;
    int nn = findEmptyCalleeSavedRegistor();
    node->x86_64.push_back("leaq\t-" + to_string(off) + "(%rbp), " + calleeSavedRegistors[nn]);
    node->x86_64.push_back("movq\t(" + calleeSavedRegistors[nn] + ", " + calleeSavedRegistors[e->calleeSavedRegistorIndex] + ", 8), " + calleeSavedRegistors[e->calleeSavedRegistorIndex] );
    node->calleeSavedRegistorIndex = e->calleeSavedRegistorIndex;
    return node;   
}