#include "bits/stdc++.h"
#include "inc/3ac.h"

using namespace std;

extern void yyerror(char const*);
extern vector<bool> temporary_registors_in_use;
extern vector<ThreeAC*> threeAC_list;
extern map<string, int> method_address;

ThreeAC::ThreeAC(string operand, int t, int t1, int t2, int form){
    op = operand;
    this->t = t;
    this->t1 = t1;
    this->t2 = t2;
    this->form = form;
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
    cout << "t1 : " << t1 << "t2 : " << t2 << endl;
    int new_t = findEmptyRegistor();
    cout << "new_t : " << new_t << endl;
    if(t1 != -1) temporary_registors_in_use[t1] = false;
    if(t2 != -1) temporary_registors_in_use[t2] = false;
    temporary_registors_in_use[new_t] = true;
    e->registor_index = new_t;
    ThreeAC* inst = new ThreeAC(op, new_t, t1, t2, form);
    threeAC_list.push_back(inst);
    return ;
}

void print3AC(ThreeAC* inst){
    cout << "I am inside print3AC\n";
    cout << inst << endl;
    cout << inst->form << endl;
    if (inst->form == 0)
    {
        if(inst->t1 == -1)
            cout<<"t"<<inst->t<<" "<<inst->op<<" "<<"t"<<inst->t2<<endl;
        else 
            cout<<"t"<<inst->t<<" "<<inst->op<<" "<<"t"<<inst->t1<<" "<<"t"<<inst->t2<<endl;
    }
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

void generate3AC(){
    int n = threeAC_list.size();
    cout << n << endl;
    cout << "I sm inside 3ac\n";
    for (int i = 0; i < n; i++)
    {
        cout << "I am inside for loop\n";
        print3AC(threeAC_list[i]);
    }
    return ;
}