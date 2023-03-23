#include "bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;

extern void yyerror(char const*);
extern vector<bool> temporary_registors_in_use;
extern vector<ThreeAC*> threeAC_list;
extern map<string, int> method_address;

ThreeAC::ThreeAC(string operand, int t, int r1, int r2, string t1, string t2, int form){
    op = operand;
    this->t = t;
    this->t1 = t1;
    this->t2 = t2;
    this->r1 = r1;
    this->r2 = r2;
    this->form = form;
}

void print3AC(ThreeAC* inst){
    if(inst->form == 0){
        cout<<"t"<<inst->t<<" = ";
        if(inst->r1 != -1) cout<<inst->r1;
        else cout<<"t"<<inst->r1;
        cout<<" "<<inst->op<<" ";
        if(inst->r2 != -1) cout<<inst->r2;
        else cout<<"t"<<inst->r2<<endl;   
    }
    else if(inst->form == 1)
        cout<<"goto "<<inst->r1<<endl;
    else if(inst->form == 2)
        cout<<"if t"<<inst->t1<<" == true goto "<<inst->t2<<endl;
    // else if(inst->form == 3)
    //     cout<<"param "<<inst->op<<endl;
    // else if(inst->form == 4)
    //     cout<<"call "<<inst->op<<endl;
    else 
        yyerror("something went wrong with the compiler!!!\n");
    return ;
}

int findEmptyRegistor(){
    for(int i=0;i<MAX_REGISTORS;i++){
        if(temporary_registors_in_use[i] == false) return i;
    }
    yyerror("compiler error: registor overflow!!!\n");
    return -1;
}

void addInstruction(Expression* e, Expression* e1, Expression* e2, string op, int form){
    string t1, t2;
    int r1, r2;
    if(e1 == NULL) {
        r1 = -1;
        t1 = "";
    }
    else{
        if(e1->isPrimary) {
            r1 = -1;
            t1 = e1->value->getValue();
        }
        else {
            r1 = e1->registor_index;
            t1 = "";
        }
    }
    if(e2 == NULL) {
        r2 = -1;
        t2 = "";
    }
    else{
        if(e2->isPrimary) {
            r1 = -1;
            t1 = e2->value->getValue();
        }
        else {
            r2 = e2->registor_index;
            t2 = "";
        }
    }
    int new_t = findEmptyRegistor();
    if(r1 != -1) temporary_registors_in_use[r1] = false;
    if(r2 != -1) temporary_registors_in_use[r2] = false;
    temporary_registors_in_use[new_t] = true;
    e->registor_index = new_t;
    ThreeAC* inst = new ThreeAC(op, new_t, r1, r2, t1, t2, form);
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

// if e1->isPrimary then literal or variable name == e1->value->getValue();
// else temporary index = e1->registor_index;