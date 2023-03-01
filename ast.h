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

Node* createNode(string lexeme){
    Node* node = new Node(lexeme);
    return node;
}

Node* convertToAST(Node* root){
    int n = root->children.size();
    if(n==1) return convertToAST(root->children[0]);
    else if (n==0) return root;
    Node* mainRoot = createNode(root->lexeme) ;
    for(int i=0;i<n;i++){
        Node* ithchild = convertToAST(root->children[i]);
        mainRoot->children.push_back(ithchild);
    }
    return mainRoot;
}

void writeEdges(Node* root, FILE* file){
    if(root == NULL) return ;
    int n = root->children.size();
    if(n==0) return ;
    for(int i=0;i<n;i++){
        fprintf(file, "%s -> %s", root->lexeme, root->children[i]->lexeme);
    }
    for(int i=0;i<n;i++){
        writeEdges(root->children[i], file);
    }
    return ;
}

void createDOT(Node* root){
    FILE *file; //file pointer
    file = fopen("ast.dot","w");
    fprintf(file, "graph AST{\n");
    writeEdges(root, file);
    fprintf(file, "}");
    fclose(file);
    return ;
}

void createAST(Node* root){
    Node* ast_root = convertToAST(root);
    createDOT(ast_root);
    return ;
}