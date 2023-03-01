#include<bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

class Node {

    public:
        string lexeme;
        vector<Node*> children;
        Node(string lex){
            lexeme = lex;
            children.resize(0);
        }
        void addChildren(vector<Node*> childrens){
            int n = childrens.size();
            for(int i=0;i<n;i++){
                this->children.push_back(childrens[i]);
            }
            return ;
        }
};