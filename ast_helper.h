#include<bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

#include "ast.h"

using namespace std;

Node* createNode(string str){
    char* lex = strcpy(new char[str.length() + 1], str.c_str());
    Node* node = new Node(lex);
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

char* spaceToUnderscore(char* word){
    int n = strlen(word);
    for(int i=0;i<n;i++){
        if(word[i]==' ') word[i]='_';
    }
    return word;
}

void writeEdges(Node* root, FILE* file){
    if(root == NULL) return ;
    int n = root->children.size();
    if(n==0) return ;
    for(int i=0;i<n;i++){
        char* a = spaceToUnderscore(root->lexeme), *b = spaceToUnderscore(root->children[i]->lexeme);
        fprintf(file, "\t%s -> %s\n", a, b);
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