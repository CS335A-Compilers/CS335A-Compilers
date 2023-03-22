#include <iostream>
#include <bits/stdc++.h>

#include "ast.h"

#define MAX_REGISTORS 8

vector<bool> temporary_registors_in_use(MAX_REGISTORS, false);

class ThreeAC {
    public:
        // the index of this instruction stores the temp registor index
        string op;
        // if ti is -1, it means the instruction does not need that registor
        int t;
        int t1;
        int t2;
        ThreeAC(string operand, int t, int t1, int t2);
};

vector<ThreeAC*> threeAC_list;

void print3AC(ThreeAC* inst);
int findEmptyRegistor();
void addInstruction(Expression* e, Expression* e1, Expression* e2, string op);