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
        Node(char* lex);
        void addChildren(vector<Node*> childrens);
};

Node* createNode(string str);
Node* cloneRoot(Node* root);
Node* convertToAST(Node* root);
char* spaceToUnderscore(char* word);
void  writeEdges(Node* root, FILE* file);
void  createDOT(Node* root, char* output_file);
void  createAST(Node* root, char* output_file);