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
        int t;
        // r1, r2 have register index; t1 and t2 have variable or literal values;
        int r1, r2;
        string t1, t2;
        // 3ac form:
        // 0 represent simple expression of type x = a op b, where a and b can be string or register index
        // 1 represent uncondition jump with r1 consisting of the address to jump
        // 2 represent condition jumps with op consisting the condition, r1/t1 consisting the expression the condition is on, r2 represent the goto address;
        // 3 represent adding params to funtion, op consisting the param name
        // 4 represent method call, op consisting of name of the call, t1 represent the address of the method definition
        int address;
        int form; 
        ThreeAC(string operand, int t, int r1, int r2, string t1, string t2, int form);
};

void print3AC(ThreeAC* inst);
int findEmptyRegistor();
void addInstruction(Expression* e, Expression* e1, Expression* e2, string op, int form);
void generate3AC();
void printRegistor(Expression* exp);