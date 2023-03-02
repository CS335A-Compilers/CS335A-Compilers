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
        if((root->children[i])->isTerminal == false && ((root->children[i])->children).size() == 0) continue;
        Node* ithchild = convertToAST(root->children[i]);
        mainRoot->children.push_back(ithchild);
    }
    return mainRoot;
}

Node* refineAST(Node* root){
    int n = root->children.size();
    if(n==0) return root;
    Node* mainRoot = createNode(root->lexeme) ;
    for(int i=0;i<n;i++){
        if(strcmp(root->children[i]->lexeme, root->lexeme) == 0){
            cout<<root->children[i]->lexeme<<endl;
            Node* ithchild = refineAST(root->children[i]);
            int m = ithchild->children.size();
            for(int j=0;j<m;j++)
                mainRoot->children.push_back(ithchild->children[j]);
        }
        else
            mainRoot->children.push_back(root->children[i]);
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
    char* a = spaceToUnderscore(root->lexeme);
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

void createDOT(Node* root){
    FILE *file; //file pointer
    file = fopen("ast.dot","w");
    fprintf(file, "digraph AST{\n");
    writeEdges(root, file);
    fprintf(file, "}");
    fclose(file);
    return ;
}

void createAST(Node* root){
    Node* ast_root = convertToAST(root);
    // Node* refined_ast = refineAST(ast_root);
    createDOT(ast_root);
    return ;
}