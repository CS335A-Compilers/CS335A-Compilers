#include "bits/stdc++.h"
#include "inc/expression.h"

using namespace std;

extern void yyerror(char const*);

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
    case 8:
        return (double)(val->num_val[0]);
        break;
    case 9:
        return (double)(val->num_val[0]);
        break;
    default:
        break;
    }
}
double doubleMod(double a, double b) {
    // determine the common factor dynamically based on the number of decimal places in the inputs
    int factor = pow(10, max(std::numeric_limits<double>::digits10 - floor(log10(abs(a))), 
                                        numeric_limits<double>::digits10 - floor(log10(abs(b)))));
    long long intA = static_cast<long long>(a * factor);
    long long intB = static_cast<long long>(b * factor);
    long long intResult = intA % intB;
    double result = static_cast<double>(intResult) / factor;
    return result;
}

Expression* grammar_1(string lex,Expression* e1,bool isprimary,bool isliteral){
    if(e1==NULL)
    return NULL;
    Expression* obj=new Expression(lex,e1->value,isprimary,isliteral);
    return obj;

}
Expression* cond_qn_co(string lex,Expression* e1,Expression* e2,Expression* e3){
    if(e1==NULL||e2==NULL)
        return NULL;
    if(e1->value->boolean_val.size()==0||e2->value->boolean_val.size()==0||e3->value->boolean_val.size()==0)
    {
        yyerror("Incompatible types: cannot be converted to boolean");
        return NULL;
    }//throw error
    if(e1->value->boolean_val[0])
    {
        Expression* obj=new Expression(lex,e2->value,false,false);
        return obj;
    }
    else
    {
        Expression* obj=new Expression(lex,e3->value,false,false);
        return obj;
    }

}
Expression* evalOR_AND(string lex,Expression* e1,string op,Expression* e2){
    if(e1==NULL||e2==NULL)
        return NULL;
    if(e1->value->boolean_val.size()==0||e2->value->boolean_val.size()==0)
        {
            yyerror("Incompatible types: cannot be converted to boolean");
            return NULL;
        }//throw error
    bool val;
    if(op=="||")
        val=e1->value->boolean_val[0]||e2->value->boolean_val[0];
    else if(op=="&&")
        val=e1->value->boolean_val[0] && e2->value->boolean_val[0];

    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj;  
}

Expression* evalBITWISE(string lex,Expression* e1,string op,Expression* e2){
    if(e1==NULL||e2==NULL)
        return NULL;
    if(e1->value->num_val.size()==0||e2->value->num_val.size()==0)
        {
            yyerror("Incompatible types: cannot be converted to type acceted for bitwise operator");
            return NULL;
        } //throw error
    long long int val;
    Value* va;
    if(op=="|")  
        val=e1->value->num_val[0] | e2->value->num_val[0];
    else if(op=="^")
        val=e1->value->num_val[0] ^ e2->value->num_val[0];
    else if(op=="&")
        val=e1->value->num_val[0] & e2->value->num_val[0];
    va= new Value();
    va->num_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj; 
}

//done for prmitive data type only , not for reference data type like array,string,char and object
Expression* evalEQ(string lex,Expression* e1,string op,Expression* e2){
    if(e1==NULL||e2==NULL)
        return NULL;
    if(!((e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)||(e1->value->boolean_val.size()!=0 && e2->value->boolean_val.size()!=0)||(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)||(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)||(e1->value->string_val.size()!=0 && e2->value->string_val.size()!=0)))
        {
            yyerror("Incomparable types: cannot be compared");
            return NULL;
        } //throw error
    bool val;
    Value* va;
    if(op=="==")
    {
        if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            val=e1->value->num_val[0] == e2->value->num_val[0];
            va= new Value();
        }
        else if(e1->value->boolean_val.size()!=0 && e2->value->boolean_val.size()!=0)
        {
            val=e1->value->boolean_val[0] == e2->value->boolean_val[0];
            va= new Value();
        }  
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            val=e1->value->float_val[0] == e2->value->float_val[0];
            va= new Value();
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            val=e1->value->double_val[0] == e2->value->double_val[0];
            va= new Value();
        }
        else if(e1->value->string_val.size()!=0 && e2->value->string_val.size()!=0)
        {
            val=e1->value->string_val[0] == e2->value->string_val[0];
            va= new Value();
        }
    }
    else if(op=="!=")
    {
        if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            val=e1->value->num_val[0] != e2->value->num_val[0];
            va= new Value();
        }
        else if(e1->value->boolean_val.size()!=0 && e2->value->boolean_val.size()!=0)
        {
            val=e1->value->boolean_val[0] != e2->value->boolean_val[0];
            va= new Value();
        }  
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            val=e1->value->float_val[0] != e2->value->float_val[0];
            va= new Value();
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            val=e1->value->double_val[0] != e2->value->double_val[0];
            va= new Value();
        }
        else if(e1->value->string_val.size()!=0 && e2->value->string_val.size()!=0)
        {
            val=e1->value->string_val[0] != e2->value->string_val[0];
            va= new Value();
        }
    }
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj;
}

//not done for char
Expression* evalRELATIONAL(string lex,Expression* e1,string op,Expression* e2){
    if(e1==NULL||e2==NULL)
        return NULL;
    if(e1->value->primitivetypeIndex >= 7)
        {
            yyerror("Incomparable types: cannot be compared");
            return NULL;
        }
    double d1 = getValue(e1->value), d2 = getValue(e2->value);
    bool val;
    if(op==">")
        val=d1>d2;
    if(op=="<")
        val=d1<d2;
    if(op==">=")
        val=d1>=d2;
    if(op=="<=")
        val=d1<=d2;
    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj;
}

Expression* evalSHIFT(string lex,Expression* e1,string op,Expression* e2){
    if(e1==NULL||e2==NULL)
        return NULL;
    if(e1->value->num_val.size()==0||e2->value->num_val.size()==0)
        {
            yyerror("Incompatible types: cannot be conveted");
            return NULL;
        } //throw error
    int val;
    if(op=="<<")
        val=e1->value->num_val[0]<<e2->value->num_val[0];
    else if(op==">>")
        val=e1->value->num_val[0]>>e2->value->num_val[0];
    else if(op==">>>")
        val=(unsigned int)e1->value->num_val[0] >> (unsigned int)e2->value->num_val[0];
    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj;   
}
Expression* evalARITHMETIC(string lex,Expression* e1,string op,Expression* e2){

    if(e1==NULL||e2==NULL)
        return NULL;
    if(e1->value->num_val.size()==0||e2->value->num_val.size()==0||e1->value->float_val.size()==0||e1->value->float_val.size()==0||e1->value->double_val.size()==0||e1->value->double_val.size()==0)
        {
            yyerror("Error: bad operand types for binary operator");
            return NULL;
        } //throw error
    
    Value* va;
    if(op=="-")
    {
        if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            long long int val=e1->value->num_val[0] - e2->value->num_val[0];
            va= new Value();
            va->num_val.push_back(val);
        } 
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=e1->value->float_val[0] - e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
           double val=e1->value->double_val[0] - e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0)
        {
           double  val=(double)e1->value->num_val[0] - e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0)
        {
           double val=e1->value->double_val[0] - (double)e2->value->num_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=(float)e1->value->num_val[0] - e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            float val=e1->value->float_val[0] - (float)e2->value->num_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0)
        {
           double val=(float)e1->value->float_val[0] - e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            double val=e1->value->double_val[0] - (double)e2->value->float_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
    }
       
    else if(op=="+")
    {
            if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            long long int val=e1->value->num_val[0] + e2->value->num_val[0];
            va= new Value();
            va->num_val.push_back(val);
        }
    
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=e1->value->float_val[0] + e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=e1->value->double_val[0] + e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=(double)e1->value->num_val[0] + e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            double val=e1->value->double_val[0] + (double)e2->value->num_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=(float)e1->value->num_val[0] + e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            float val=e1->value->float_val[0] + (float)e2->value->num_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=(double)e1->value->float_val[0] + e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            double val=e1->value->double_val[0] + e2->value->float_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
    }
    else if(op=="*")
    {
        if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            long long int val=e1->value->num_val[0] * e2->value->num_val[0];
            va= new Value();
            va->num_val.push_back(val);
        }
     
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=e1->value->float_val[0] * e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=e1->value->double_val[0] * e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=(double)e1->value->num_val[0] * e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            double val=e1->value->double_val[0] * (double)e2->value->num_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=(double)e1->value->num_val[0] * e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            float val=e1->value->float_val[0] * (double)e2->value->num_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=(double)e1->value->float_val[0] * e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            double val=e1->value->double_val[0] * (double)e2->value->float_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
    }
    else if(op=="%")
    {
        if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            long long int val=e1->value->num_val[0] % e2->value->num_val[0];
            va= new Value();
            va->num_val.push_back(val);
        } 
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=doubleMod(e1->value->float_val[0] , e2->value->float_val[0]);
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=doubleMod(e1->value->double_val[0],e2->value->double_val[0]);
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=doubleMod((double)e1->value->num_val[0] , e2->value->double_val[0]);
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            double val=doubleMod(e1->value->double_val[0] ,(double) e2->value->num_val[0]);
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=doubleMod(e1->value->num_val[0] , e2->value->float_val[0]);
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            float val=doubleMod(e1->value->float_val[0] , e2->value->num_val[0]);
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=doubleMod((double)e1->value->double_val[0] , e2->value->double_val[0]);
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            double val=doubleMod(e1->value->double_val[0] , (double)e2->value->double_val[0]);
            va= new Value();
            va->double_val.push_back(val);
        }
    }
       
    else if(op=="/")
    {
            if(e1->value->num_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            long long int val=e1->value->num_val[0] / e2->value->num_val[0];
            va= new Value();
            va->num_val.push_back(val);
        }
     
        else if(e1->value->float_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=e1->value->float_val[0] / e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=e1->value->double_val[0] / e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=(double)e1->value->num_val[0] / e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            double val=e1->value->double_val[0] / (double)e2->value->num_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->num_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            float val=(float)e1->value->num_val[0] / e2->value->float_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->num_val.size()!=0)
        {
            float val=e1->value->float_val[0] / (float)e2->value->num_val[0];
            va= new Value();
            va->float_val.push_back(val);
        }
        else if(e1->value->float_val.size()!=0 && e2->value->double_val.size()!=0)
        {
            double val=(double)e1->value->float_val[0] / e2->value->double_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
        else if(e1->value->double_val.size()!=0 && e2->value->float_val.size()!=0)
        {
            double val=e1->value->double_val[0] / (double)e2->value->float_val[0];
            va= new Value();
            va->double_val.push_back(val);
        }
    }
    
    Expression* obj=new Expression(lex,va,false,false);
    return obj;   
}

Expression* evalUNARY(string lex,string op,Expression* e1){
    //don't know how to do this
    if(e1==NULL)
        return NULL;
    if(e1->value->primitivetypeIndex >6||e1->value->primitivetypeIndex == 4)
        {
            yyerror("Error: bad operand types for unary operator");
            return NULL;
        } //throw error
    int val;
    if(op=="+")
    {   
        if(e1->value->primitivetypeIndex <3)
            val=e1->value->num_val[0];
        else if(e1->value->primitivetypeIndex ==5)
            val=e1->value->float_val[0];
        else if(e1->value->primitivetypeIndex ==6)
            val=e1->value->double_val[0];
    }
       
    else if(op=="-")
    {   
        if(e1->value->primitivetypeIndex <3)
            val=-e1->value->num_val[0];
        else if(e1->value->primitivetypeIndex ==5)
            val=-e1->value->float_val[0];
        else if(e1->value->primitivetypeIndex ==6)
            val=-e1->value->double_val[0];
    }
    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj; 
}
Expression* evalIC_DC(string lex,string op,Expression* e1){
    if(e1==NULL)
        return NULL;
    if(e1->value->primitivetypeIndex >6)
        {
            yyerror("Error: bad operand types for increment or decrement");
            return NULL;
        } //throw error
    int val;
    if(op=="++")
        val=e1->value->num_val[0]+1;
    else if(op=="--")
        val=e1->value->float_val[0]-1;
    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj;   
}

Expression* evalTL(string lex,Expression* e1){
    if(e1==NULL)
        return NULL;
    if(e1->value->primitivetypeIndex >4)
        {
            yyerror("Error: bad operand types for bitwise complement operator");
            return NULL;
        } //throw error
    int val;
    if(e1->value->primitivetypeIndex<5)
        val=~e1->value->num_val[0];
    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj; 

}

Expression* evalEX(string lex,Expression* e1){
    if(e1==NULL)
        return NULL;
    if(e1->value->primitivetypeIndex!=7)
        {
            yyerror("Error: bad operand type for unary operator '!'");
            return NULL;
        } //throw error
    int val;
    if(e1->value->primitivetypeIndex<5)
        val=!e1->value->num_val[0];
    Value* va= new Value();
    va->boolean_val.push_back(val);
    Expression* obj=new Expression(lex,va,false,false);
    return obj; 

}

 