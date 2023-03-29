#include "bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;

extern void yyerror(char const*);
extern GlobalSymbolTable* global_symtab;
extern vector<bool> temporary_registors_in_use;

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
    obj->registor_index = e1->registor_index;
    obj->primary_exp_val = e1->primary_exp_val;
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
    // bool val;
    // if (op == "||")
    //     val = e1->value->boolean_val[0] || e2->value->boolean_val[0];
    // else if (op=="&&")
    //     val = e1->value->boolean_val[0] && e2->value->boolean_val[0];

    Value* va = new Value();
    va->primitivetypeIndex = BOOLEAN;
    Expression *obj = new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    // addInstruction(obj, e1, e2, op, 0);
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
    // if(op=="|")  
    //     val=e1->value->num_val[0] | e2->value->num_val[0];
    // else if(op=="^")
    //     val=e1->value->num_val[0] ^ e2->value->num_val[0];
    // else if(op=="&")
    //     val=e1->value->num_val[0] & e2->value->num_val[0];
    // va->num_val.push_back(val);
    va->primitivetypeIndex = max(e2->value->primitivetypeIndex, e1->value->primitivetypeIndex);
    Expression* obj=new Expression(lex,va,false,false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
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
    return obj;
}

//not done for char
Expression* evalRELATIONAL(string lex, Expression* e1, string op, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > DOUBLE || e2->value->primitivetypeIndex > DOUBLE){
        yyerror("Incomparable types: cannot be compared");
        return NULL;
    }
    // bool val;
    // if(e1->value->primitivetypeIndex == 9){
    //     if(op==">")
    //         val=e1->value->string_val[0] > e2->value->string_val[0];
    //     if(op=="<")
    //         val=e1->value->string_val[0] < e2->value->string_val[0];
    //     if(op==">=")
    //         val=e1->value->string_val[0] >= e2->value->string_val[0];
    //     if(op=="<=")
    //         val=e1->value->string_val[0] <= e2->value->string_val[0];
    // }
    // else{
    //     double d1 = getValue(e1->value), d2 = getValue(e2->value);
    //     if(op==">")
    //         val=d1>d2;
    //     if(op=="<")
    //         val=d1<d2;
    //     if(op==">=")
    //         val=d1>=d2;
    //     if(op=="<=")
    //         val=d1<=d2;
    // }
    
    Value* va= new Value();
    va->primitivetypeIndex = 7;
    Expression* obj=new Expression(lex,va,false,false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    return obj;
}

// Segmentation fault on character eg : a = 'k' >> 8;
Expression* evalSHIFT(string lex, Expression* e1, string op, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > LONG || e2->value->primitivetypeIndex > LONG){
        yyerror("Incompatible types: cannot be conveted");
        return NULL;
    }
    // int val;
    // if(op=="<<")
    //     val=e1->value->num_val[0]<<e2->value->num_val[0];
    // else if(op==">>")
    //     val=e1->value->num_val[0]>>e2->value->num_val[0];
    // else if(op==">>>")
    //     val=(unsigned int)e1->value->num_val[0] >> (unsigned int)e2->value->num_val[0];
    Value* va= new Value();
    va->primitivetypeIndex = 4;
    Expression* obj=new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    return obj;   
}

Expression* evalARITHMETIC(string lex, string op, Expression* e1, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    // wrong type checking;
    if (e1->value->primitivetypeIndex > 6 || e2->value->primitivetypeIndex > 6){
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
            obj->code.push_back(addInstruction(temp, NULL, e1, "cast_to_"+ convertingType, 0));
            obj->code.push_back(addInstruction(obj, temp, e2, op ,0));
        }
        else {
            obj->code.push_back(addInstruction(temp, NULL, e2, "cast_to_"+ convertingType, 0));
            obj->code.push_back(addInstruction(obj, temp, e1, op ,0));
        }
    }
    else obj->code.push_back(addInstruction(obj, e1, e2, op, 0));
    return obj;
}

// Segmentation fault on characters
Expression* evalUNARY(string lex, string op, Expression* e1){
    //don't know how to do this
    if(e1 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > 6){
        yyerror("Bad operand types for unary operator");
        return NULL;
    }
    // int val;
    // if(op=="+"){   
    //     if(e1->value->primitivetypeIndex <4)
    //         val=e1->value->num_val[0];
    //     else if(e1->value->primitivetypeIndex ==4)
    //         val=e1->value->float_val[0];
    //     else if(e1->value->primitivetypeIndex ==5)
    //         val=e1->value->double_val[0];
    // }
    
    // else if(op=="-"){
    //     if(e1->value->primitivetypeIndex <4)
    //         val=-e1->value->num_val[0];
    //     else if(e1->value->primitivetypeIndex ==4)
    //         val=-e1->value->float_val[0];
    //     else if(e1->value->primitivetypeIndex ==5)
    //         val=-e1->value->double_val[0];
    // }
    Value* va= new Value();
    va->primitivetypeIndex = e1->value->primitivetypeIndex;
    Expression* obj=new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, NULL, e1, op, 0));
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
    // int val;
    // if(op=="++")
    //     val=e1->value->num_val[0]+1;
    // else if(op=="--")
    //     val=e1->value->float_val[0]-1;
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
    if(preOperation){
        obj->code.push_back(addInstruction(temp1, e1, one, new_op, 0));
        obj->code.push_back(addInstruction(e1, temp1, NULL, "", 0));
        obj->registor_index = temp1->registor_index;
    }
    else{
        obj->code.push_back(addInstruction(temp, e1, NULL, "", 0));
        obj->code.push_back(addInstruction(temp1, e1, one, new_op, 0));
        obj->code.push_back(addInstruction(e1, temp1, NULL, "", 0));
        obj->registor_index = temp->registor_index;
    }
    // obj->code.push_back(addInstruction(obj, NULL, e1, op, 0));
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
    obj->code.push_back(addInstruction(obj, NULL, e1, "~", 0));
    return obj; 

}

Expression* evalEX(string lex, Expression* e1){
    if(e1 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex != 7){
        yyerror("Bad operand type for unary operator '!'");
        return NULL;
    }
    Value* va = new Value();
    va->primitivetypeIndex = 7;
    Expression* obj = new Expression(lex, va, false, false);
    obj->code.push_back(addInstruction(obj, NULL, e1, "!", 0));
    return obj; 

}

Expression* assignValue(Expression* type_name, string op, Expression* exp){
    LocalVariableDeclaration* name = (LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry(type_name->primary_exp_val, -1));
    if(name == NULL){
        yyerror("use of undeclared variable");
        return NULL;
    }
    Expression* obj = new Expression("assignment", NULL, false, false);
    if(name->entry_type == VARIABLE_DECLARATION){
            int name_type = name->type->primitivetypeIndex;
            int exp_type = exp->value->primitivetypeIndex;
            if((name_type <= LONG && exp_type <= LONG) || (name_type == FLOAT && exp_type == FLOAT || name_type == DOUBLE && exp_type == DOUBLE) || (name_type == exp_type) || (exp_type <= LONG && (name_type == FLOAT || name_type == DOUBLE))) {
            if(op == "="){
                // name->variable_declarator->initialized_value = exp->value;
                obj->code.push_back(addInstruction(type_name, exp, NULL, "", 0));
            }
            else{
                int pos = op.find('=');
                string fin_op = op.substr(0, pos);
                Expression* temp = new Expression("typename", NULL, false, false);
                obj->code.push_back(addInstruction(temp, type_name, exp, fin_op, 0));
                obj->code.push_back(addInstruction(type_name, temp, NULL, "", 0));
            }
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
