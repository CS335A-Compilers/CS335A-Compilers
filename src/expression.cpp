#include "bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;

extern void yyerror(char const*);

// Define an array of strings that corresponds to the type values.
const string typeStrings[] = {"char", "byte", "short", "int", "long", "float", "double", "boolean", "array", "string", "void"};

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
    return obj;
}

// Segmentation fault on character eg : a = (false) ? 'k' : 6;
Expression* cond_qn_co(string lex, Expression* e1, Expression* e2, Expression* e3){
    cout << "i am here\n";
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
    if (e1->value->boolean_val.size() == 0 || (e2->value->primitivetypeIndex != e3->value->primitivetypeIndex && (e2->value->primitivetypeIndex > 6 || e3->value->primitivetypeIndex > 6))){
        yyerror(error.c_str());
        return NULL;
    }//throw error
    Value* va = new Value();
    va->primitivetypeIndex = max(e2->value->primitivetypeIndex, e3->value->primitivetypeIndex);
    Expression *obj = new Expression(lex, va, false, false);
    return obj;
}

Expression* evalOR_AND(string lex, Expression* e1, string op, Expression* e2){
    if (e1 == NULL || e2 == NULL)
        return NULL;
    if (e1->value->boolean_val.size() == 0 || e2->value->boolean_val.size() == 0){
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
    va->primitivetypeIndex = 7;
    Expression *obj = new Expression(lex, va, false, false);
    // addInstruction(obj, e1, e2, op, 0);
    return obj;  
}

Expression* evalBITWISE(string lex, Expression* e1, string op, Expression* e2){
    if (e1 == NULL || e2 == NULL)
        return NULL;
    if ((e1->value->primitivetypeIndex > 4 || e2->value->primitivetypeIndex > 4)){
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
    // addInstruction(obj, e1, e2, op, 0);
    return obj; 
}

//done for prmitive data type only , not for reference data type like array,string,char and object
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
    // if(op=="=="){
    //     if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         val=e1->value->num_val[0] == e2->value->num_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->boolean_val.size()!=0 && e2->value->boolean_val.size()!=0){
    //         val=e1->value->boolean_val[0] == e2->value->boolean_val[0];
    //         va= new Value();
    //     } 
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         val=e1->value->num_val[0] == e2->value->float_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         val=e1->value->float_val[0] == e2->value->num_val[0];
    //         va= new Value();
    //     }  
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         val=e1->value->float_val[0] == e2->value->float_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         val=e1->value->double_val[0] == e2->value->double_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //         val=e1->value->double_val[0] == e2->value->num_val[0];
    //         va= new Value();
    //     }  
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         val=e1->value->num_val[0] == e2->value->double_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         val=e1->value->double_val[0] == e2->value->float_val[0];
    //         va= new Value();
    //     }  
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         val=e1->value->float_val[0] == e2->value->double_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->string_val.size()!=0 && e2->value->string_val.size()!=0){
    //         val=e1->value->string_val[0] == e2->value->string_val[0];
    //         va= new Value();
    //     }
    // }
    // else if(op=="!=")
    // {
    //     if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         val=e1->value->num_val[0] != e2->value->num_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->boolean_val.size()!=0 && e2->value->boolean_val.size()!=0){
    //         val=e1->value->boolean_val[0] != e2->value->boolean_val[0];
    //         va= new Value();
    //     }  
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         val=e1->value->float_val[0] != e2->value->float_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         val=e1->value->double_val[0] != e2->value->double_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         val=e1->value->num_val[0] != e2->value->float_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         val=e1->value->float_val[0] != e2->value->num_val[0];
    //         va= new Value();
    //     } 
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //         val=e1->value->double_val[0] != e2->value->num_val[0];
    //         va= new Value();
    //     }  
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         val=e1->value->num_val[0] != e2->value->double_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         val=e1->value->double_val[0] != e2->value->float_val[0];
    //         va= new Value();
    //     }  
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         val=e1->value->float_val[0] != e2->value->double_val[0];
    //         va= new Value();
    //     }
    //     else if(e1->value->string_val.size()!=0 && e2->value->string_val.size()!=0){
    //         val=e1->value->string_val[0] != e2->value->string_val[0];
    //         va= new Value();
    //     }
    // }
    // va->boolean_val.push_back(val);oi
    va->primitivetypeIndex = 7;
    Expression *obj = new Expression(lex, va, false, false);
    // addInstruction(obj, e1,e2,op, 0);
    return obj;
}

//not done for char
Expression* evalRELATIONAL(string lex, Expression* e1, string op, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > 6 || e2->value->primitivetypeIndex > 6){
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
    // addInstruction(obj, e1,e2,op, 0);
    return obj;
}

// Segmentation fault on character eg : a = 'k' >> 8;
Expression* evalSHIFT(string lex, Expression* e1, string op, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    if(e1->value->primitivetypeIndex > 4 || e2->value->primitivetypeIndex > 4){
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
    // addInstruction(obj, e1,e2,op, 0);
    return obj;   
}

Expression* evalARITHMETIC(string lex, string op, Expression* e1, Expression* e2){
    if(e1 == NULL || e2 == NULL)
        return NULL;
    // wrong type checking;
    cout << e1->value->primitivetypeIndex << " " << e2->value->primitivetypeIndex << endl;
    if (e1->value->primitivetypeIndex > 6 || e2->value->primitivetypeIndex > 6)
    {
        yyerror("Bad operand types for arthimetic operator");
        return NULL;
    }
    Value* va = new Value();
    // if(op=="-"){
    //     if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         long long int val=e1->value->num_val[0] - e2->value->num_val[0];
    //         va= new Value();
    //         va->num_val.push_back(val);
    //     } 
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=e1->value->float_val[0] - e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=e1->value->double_val[0] - e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double  val=(double)e1->value->num_val[0] - e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //        double val=e1->value->double_val[0] - (double)e2->value->num_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=(float)e1->value->num_val[0] - e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         float val=e1->value->float_val[0] - (float)e2->value->num_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(float)e1->value->float_val[0] - e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         double val=e1->value->double_val[0] - (double)e2->value->float_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    // }
       
    // else if(op=="+"){
    //     if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         long long int val=e1->value->num_val[0] + e2->value->num_val[0];
    //         va= new Value();
    //         va->num_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=e1->value->float_val[0] + e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=e1->value->double_val[0] + e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(double)e1->value->num_val[0] + e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //         double val=e1->value->double_val[0] + (double)e2->value->num_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=(float)e1->value->num_val[0] + e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         float val=e1->value->float_val[0] + (float)e2->value->num_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(double)e1->value->float_val[0] + e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         double val=e1->value->double_val[0] + e2->value->float_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    // }
    // else if(op=="*"){
    //     if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         long long int val=e1->value->num_val[0] * e2->value->num_val[0];
    //         va= new Value();
    //         va->num_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=e1->value->float_val[0] * e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=e1->value->double_val[0] * e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(double)e1->value->num_val[0] * e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //         double val=e1->value->double_val[0] * (double)e2->value->num_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=(float)e1->value->num_val[0] * e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         float val=e1->value->float_val[0] * (float)e2->value->num_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(double)e1->value->float_val[0] * e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         double val=e1->value->double_val[0] * (double)e2->value->float_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    // }
    // else if(op=="%")
    // {
    //     if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         long long int val=e1->value->num_val[0] % e2->value->num_val[0];
    //         va= new Value();
    //         va->num_val.push_back(val);
    //     } 
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=doubleMod(e1->value->float_val[0] , e2->value->float_val[0]);
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=doubleMod(e1->value->double_val[0],e2->value->double_val[0]);
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=doubleMod((double)e1->value->num_val[0] , e2->value->double_val[0]);
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //         double val=doubleMod(e1->value->double_val[0] ,(double) e2->value->num_val[0]);
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=doubleMod(e1->value->num_val[0] , e2->value->float_val[0]);
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         float val=doubleMod(e1->value->float_val[0] , e2->value->num_val[0]);
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=doubleMod((double)e1->value->float_val[0] , e2->value->double_val[0]);
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         double val=doubleMod(e1->value->double_val[0] , (double)e2->value->float_val[0]);
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    // }
       
    // else if(op=="/"){
    //         if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0){
    //         long long int val=e1->value->num_val[0] / e2->value->num_val[0];
    //         va= new Value();
    //         va->num_val.push_back(val);
    //     }
     
    //     else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=e1->value->float_val[0] / e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=e1->value->double_val[0] / e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(double)e1->value->num_val[0] / e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0){
    //         double val=e1->value->double_val[0] / (double)e2->value->num_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0){
    //         float val=(float)e1->value->num_val[0] / e2->value->float_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0){
    //         float val=e1->value->float_val[0] / (float)e2->value->num_val[0];
    //         va= new Value();
    //         va->float_val.push_back(val);
    //     }
    //     else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0){
    //         double val=(double)e1->value->float_val[0] / e2->value->double_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    //     else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0){
    //         double val=e1->value->double_val[0] / (double)e2->value->float_val[0];
    //         va= new Value();
    //         va->double_val.push_back(val);
    //     }
    // }
    
    va->primitivetypeIndex = max(e2->value->primitivetypeIndex, e1->value->primitivetypeIndex);
    Expression* obj=new Expression(lex,va,false,false);
    // addInstruction(obj, e1, e2, op, 0);
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
    // addInstruction(obj, e1, NULL, op, 0);
    return obj; 
}

// make different function for preincrement and postincrement;
Expression* evalIC_DC(string lex, string op, Expression* e1){
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
    // addInstruction(obj, e1, NULL, op, 0);
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
    return obj; 

}

 