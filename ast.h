#include<bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

class Node {

    public:
        string lexeme;
        vector<Node*> children;
        Node(string lex){
            lexeme = lex;
        }
        void addChildren(vector<Node*> childrens){
            int n = childrens.size();
            for(int i=0;i<n;i++){
                this->children.push_back(childrens[i]);
            }
            return ;
        }
};

Node* createNode(string lexeme){
    Node* node = new Node(lexeme);
    return node;
}

Node* convertToAST(Node* root){
    int n = root->children.size();
    Node* mainRoot = createNode(root->lexeme) ;
    for(int i=0;i<n;i++){
        Node* ithchild = convertToAST(root->children[i]);
        mainRoot->children.push_back(ithchild);
    }
    return mainRoot;
}