#include "../bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;
extern void yyerror(char const*);

ThreeAC::ThreeAC(string operand, int t, int t1, int t2, int form){
    op = operand;
    this->t = t;
    this->t1 = t1;
    this->t2 = t2;
    this->form = form;
}

void print3AC(ThreeAC* inst){
    if(inst->form == 0)
        cout<<"t"<<inst->t<<" "<<inst->op<<" "<<"t"<<inst->t1<<" "<<"t"<<inst->t2<<endl;
    else if(inst->form == 1)
        cout<<"goto "<<inst->t1<<endl;
    else if(inst->form == 2)
        cout<<"if t"<<inst->t1<<" == true goto "<<inst->t2<<endl;
    else if(inst->form == 3)
        cout<<"param "<<inst->op<<endl;
    else if(inst->form == 4)
        cout<<"call "<<inst->op<<endl;
    else 
        yyerror("something went wrong with the compiler\n");
    return ;
}

int findEmptyRegistor(){
    for(int i=0;i<MAX_REGISTORS;i++){
        if(temporary_registors_in_use[i] == false) return i;
    }
    yyerror("compiler error: registor overfflow\n");
    return -1;
}

void addInstruction(Expression* e, Expression* e1, Expression* e2, string op, int form){
    int t1 = (e1)? e1->registor_index : -1, t2 = (e2)? e2->registor_index : -1;
    int new_t = findEmptyRegistor();
    if(t1 != -1) temporary_registors_in_use[t1] = false;
    if(t2 != -1) temporary_registors_in_use[t2] = false;
    temporary_registors_in_use[new_t] = true;
    e->registor_index = new_t;
    ThreeAC* inst = new ThreeAC(op, new_t, t1, t2, form);
    threeAC_list.push_back(inst);
    return ;
}

void generate3AC(){
    int n = threeAC_list.size();
    for(int i=0;i<n;i++){
        print3AC(threeAC_list[i]);
    }
    return ;
}