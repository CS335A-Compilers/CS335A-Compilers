#include "../bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;
extern void yyerror(char const*);

ThreeAC::ThreeAC(string operand, int t, int t1, int t2){
    op = operand;
    this->t = t;
    this->t1 = t1;
    this->t2 = t2;
}

void print3AC(ThreeAC* inst){
    cout<<"t"<<inst->t<<" "<<inst->op<<" "<<"t"<<inst->t1<<" "<<"t"<<inst->t2<<endl;
}

int findEmptyRegistor(){
    for(int i=0;i<MAX_REGISTORS;i++){
        if(temporary_registors_in_use[i] == false) return i;
    }
    yyerror("compiler error: registor overfflow\n");
    return -1;
}

void addInstruction(Expression* e, Expression* e1, Expression* e2, string op){
    int t1 = e1->registor_index, t2 = e2->registor_index;
    int new_t = findEmptyRegistor();
    temporary_registors_in_use[t1] = false;
    temporary_registors_in_use[t2] = false;
    temporary_registors_in_use[new_t] = true;
    e->registor_index = new_t;
    ThreeAC* inst = new ThreeAC(op, new_t, t1, t2);
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