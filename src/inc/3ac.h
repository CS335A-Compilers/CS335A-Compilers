#include <iostream>
#include "../bits/stdc++.h"

#include "expression.h"

#define MAX_REGISTORS 8

class ThreeAC {
    public:
        // op stores the operator used between them; 
        string op;
        // the index of this instruction stores the temp registor index
        // if ti is -1, it means the instruction does not need that registor
        int t, t1, t2;
        // 3ac form: 
        // 0 represent simple expression of type x = a op b, where a can be -1
        // 1 represent uncondition jump with t1 consisting of the address to jump
        // 2 represent condition jumps with op consisting the condition, t1 consisting the expression the condition is on, t2 represent the goto address;
        // 3 represent adding params to funtion, op consisting the param name
        // 4 represent method call, op consisting of name of the call, t1 represent the address of the method definition
        int address;
        int form; 
        ThreeAC(string operand, int t, int t1, int t2, int form);
};

void print3AC(ThreeAC* inst);
int findEmptyRegistor();
void addInstruction(Expression* e, Expression* e1, Expression* e2, string op, int form);
void generate3AC();
void printRegistor(Expression* exp);