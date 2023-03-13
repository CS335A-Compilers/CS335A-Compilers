#include "bits/stdc++.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

#include "inc/ast.h"

int Node::node_id = 0;

Node::Node(string lex){
    lexeme = lex;
    children.resize(0);
    isTerminal = false;
    node_id++;
    id = node_id;
}

void Node::addChildren(vector<Node*> childrens){
    int n = childrens.size();
    for(int i=0;i<n;i++){
        this->children.push_back(childrens[i]);
    }
    return ;
}

ListNode::ListNode(string lex, Node* single_parameter, vector<Node*> parameters){
    lexeme = lex;
    lists.resize(0);
    if(single_parameter != NULL)
        lists.push_back(single_parameter);
    for(int i=0;i<parameters.size();i++){
        lists.push_back(parameters[i]);
    }
}

FormalParameter::FormalParameter(string lex, Type* type, Node* identifier, bool isFinal){
    lexeme = lex;
    name = identifier->lexeme;          // assuming dims_zero_or_one is empty
    isFinal = isFinal;
    param_type = type;
}

Type::Type(string lex, int primitivetype){
    lexeme = lex;
    primitivetypeIndex = primitivetype;
}

MethodDeclaration::MethodDeclaration(string lex){
    lexeme = lex;
}