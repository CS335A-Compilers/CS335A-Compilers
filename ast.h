#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

#include "bits/stdc++.h"

class Node {

    public:
        char* lexeme;
        static int node_id;
        vector<Node*> children;
        bool isTerminal; 
        long long int id; 
        Node(char* lex){
            lexeme = lex;
            children.resize(0);
            isTerminal = false;
            node_id++;
            id = node_id;
        }
        void addChildren(vector<Node*> childrens){
            int n = childrens.size();
            for(int i=0;i<n;i++){
                this->children.push_back(childrens[i]);
            }
            return ;
        }
};