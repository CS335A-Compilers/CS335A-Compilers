#include<bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

class Node {

    public:
        char* lexeme;
        vector<Node*> children;
        bool isTerminal;        // Need to implement this 
        long long int id;       // Need to implement this 
        Node(char* lex){
            lexeme = lex;
            children.resize(0);
            isTerminal = false;
        }
        void addChildren(vector<Node*> childrens){
            int n = childrens.size();
            for(int i=0;i<n;i++){
                this->children.push_back(childrens[i]);
            }
            return ;
        }
};