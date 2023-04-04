#include <iostream>
#include "../bits/stdc++.h"

#include "expression.h"

#define MAX_REGISTORS 100000

class ThreeAC {
    public:
        // op stores the operator used between them; 
        string op;
        // the index of this instruction stores the temp registor index
        // if ti is -1, it means the instruction does not need that registor
        int r;
        string t;
        // r1, r2 have register index; t1 and t2 have variable or literal values;
        int r1, r2;
        string t1, t2;
        // 3ac form:
        // 0 represent simple expression of type x = a op b, where a and b can be string or register index
        // 1 represent same expression as above but with referencing the variable with *
        int address;
        int form;
        ThreeAC(string operand, string t, int r, int r1, int r2, string t1, string t2, int form);
};

void print3AC(ThreeAC* inst);
int findEmptyRegistor();
int addInstruction(Expression* e, Expression* e1, Expression* e2, string op, int form);