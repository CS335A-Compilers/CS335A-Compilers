#include "bits/stdc++.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

#include "ast.h"

Node::Node(char* lex){
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

Node* createNode(string str){
    char* lex = strcpy(new char[str.length() + 1], str.c_str());
    Node* node = new Node(lex);
    return node;
}

Node* cloneRoot(Node* root){
    char* lex = root->lexeme;
    Node* newRoot = new Node(lex);
    // Need to copy all attributes;
    return newRoot;
}

Node* convertToAST(Node* root){
    int n = root->children.size();
    if(n==1) return convertToAST(root->children[0]);
    else if (n==0) return root;
    Node* mainRoot = cloneRoot(root);
    for(int i=0;i<n;i++){
        if((root->children[i])->isTerminal == false && ((root->children[i])->children).size() == 0) continue;
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
    if(n==0 && root->isTerminal == false) return ;
    char* a;
    if(root->isTerminal == true) a = root->lexeme;
    else a = spaceToUnderscore(root->lexeme);
    if(root->isTerminal == true) fprintf(file, "\t%lld[label = \"%s\", shape = \"doublecircle\"]\n", root->id, a);
    else fprintf(file, "\t%lld[label = %s]\n", root->id, a);
    for(int i=0;i<n;i++){
        if((root->children[i])->isTerminal == false && ((root->children[i])->children).size() == 0) continue;   //not required but written anyway
        fprintf(file, "\t%lld -> %lld\n", root->id, (root->children[i])->id);
    }
    for(int i=0;i<n;i++){
        writeEdges(root->children[i], file);
    }
    return ;
}

void createDOT(Node* root, char* output_file){
    FILE *file; //file pointer
    file = fopen(output_file, "w");
    fprintf(file, "digraph AST{\n");
    writeEdges(root, file);
    fprintf(file, "}");
    fclose(file);
    return ;
}

void createAST(Node* root, char* output_file){
    Node* ast_root = convertToAST(root);
    createDOT(ast_root, output_file);
    return ;
}