#include "bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;

extern void yyerror(char const*);
extern vector<bool> temporary_registors_in_use;
extern vector<ThreeAC*> threeAC_list;
extern map<string, int> method_address;

// std::ofstream out("3ac.txt");
// std::streambuf* coutbuf = std::cout.rdbuf();
// std::cout.rdbuf(outfile.rdbuf());

ThreeAC::ThreeAC(string operand, string t, int r, int r1, int r2, string t1, string t2, int form){
    op = operand;
    this->t = t;
    this->r = r;
    this->t1 = t1;
    this->t2 = t2;
    this->r1 = r1;
    this->r2 = r2;
    this->form = form;
}

void print3AC(ThreeAC* inst){
    if(inst->form == 0){
        if(inst->r != -1) cout<<"t"<<inst->r;
        else cout<<inst->t;
        cout<<" = ";
        if(inst->r1 != -1) cout<<"t"<<inst->r1;
        else cout<<inst->t1;
        cout<<" "<<inst->op<<" ";
        if(inst->r2 != -1) cout<<"t"<<inst->r2;
        else cout<<inst->t2;
        cout<<endl;
    }
    else if(inst->form == 1)
        cout<<"goto "<<inst->r1<<endl;
    else if(inst->form == 2){
        cout<<"if ";
        if(inst->r1 != -1) cout<<"t"<<inst->r1;
        else cout<<"t"<<inst->r1;
        cout<<inst->t1<<" == true goto "<<inst->r2<<endl;
    }
    else if(inst->form == 3)
        cout<<"param "<<inst->op<<endl;
    else if(inst->form == 4)
        cout<<"call "<<inst->op<<endl;
    else if(inst->form == 5)
        cout<<inst->op<<" "<<inst->t<<endl;
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

int addInstruction(Expression* e, Expression* e1, Expression* e2, string op, int form){
    int index = threeAC_list.size();
    string t1="", t2="";
    int r1=-1, r2=-1;
    // cout<<"exp1 : "<<e1->primary_exp_val<<" exp2: "<<e2->primary_exp_val<<endl;
    if(e1 == NULL) {
        r1 = -1;
        t1 = "";
    }
    else{
        if(e1->isPrimary) {
            r1 = -1;
            t1 = e1->primary_exp_val;
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
            r2 = -1;
            t2 = e2->primary_exp_val;
        }
        else {
            r2 = e2->registor_index;
            t2 = "";
        }
    }
    if(e == NULL){
        yyerror("compiler problem!!!");
        return -1;
    }
    // cout<<"t1: "<<t1<<"r1: "<<r1<<"t2: "<<t2<<"r2: "<<r2<<endl;
    string new_t = "";
    int new_r = -1;
    if(e->isPrimary) new_t = e->primary_exp_val; 
    else new_r = findEmptyRegistor();
    if(r1 != -1) temporary_registors_in_use[r1] = false;
    if(r2 != -1) temporary_registors_in_use[r2] = false;
    if(new_r != -1) temporary_registors_in_use[new_r] = true;
    e->registor_index = new_r;
    ThreeAC* inst = new ThreeAC(op, new_t, new_r, r1, r2, t1, t2, form);
    threeAC_list.push_back(inst);
    return index;
}

// if e1->isPrimary then literal or variable name == e1->value->getValue();
// else temporary index = e1->registor_index;