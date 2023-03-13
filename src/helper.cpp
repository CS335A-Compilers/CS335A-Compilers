#include "bits/stdc++.h"
#include "inc/helper.h"

using namespace std;

string string_buffer;

void init(){
    string_buffer = "";
}

void showError(string temp, enum ErrorKind errorCode){
    // printf("Error at line num: %d\nError: %s\n", yylineno, LexicalErrors[errorCode]);
    switch (errorCode){
        case BADEXCAPESEQ:
            cout<<"Bad escape sequence: "<<temp<<endl;
            break;
        case ILLEGALCHAR:
            cout<<"Illegal Character: "<<temp<<endl;
            break;
        case LEXICAL_ERROR:
            cout<<"Bad Lexical Sequence starts from: "<<temp<<endl;
            break;
        case EOF_ERROR:
            cout<<"Unbalanced %s present. "<<temp<<endl;
            break;
        default:
            cout<<"Error:  "<<LexicalErrors[errorCode]<<endl;
            break;
    }
    return ;
}

void pushBuffer(char* temp){
    string_buffer += *temp;
    return ;
}

void initBuffer(char* temp){
    string_buffer = "";
    return ;
}

void endBuffer(char* temp){
    // pushBuffer(temp);
    return ;
}

/*Cant think of any other way to implement this :( */ 
char* convertExcapeChar(char x){
    char* res;
    if(x=='n') *res = '\n';
    else if(x=='f') *res = '\f';
    else if(x=='r') *res = '\r';
    else if(x=='t') *res = '\t';
    else if(x=='b') *res = '\b';
    else if(x=='\\') *res = '\\';
    else if(x=='\'') *res = '\'';
    else if(x=='\"') *res = '\"';
    else {
        string err = "";
        err += x;
        showError(err, BADEXCAPESEQ);
    }
    return res;
}

string convertCurrState(int state){
    string res;
    printf("%d\n", state);
    if(state == 1) res = "comment";
    else if(state == 2) res = "string";
    else if(state == 3) res = "char";
    else if(state == 4 || state == 5) res = "text block";
    return res; 
}

Node* createNode(string str){
    Node* node = new Node(str);
    return node;
}

Node* cloneRoot(Node* root){
    string lex = root->lexeme;
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


string spaceToUnderscore(string word){
    int n = word.length();
    for(int i=0;i<n;i++){
        if(word[i]==' ') word[i]='_';
    }
    return word;
}

void writeEdges(Node* root, FILE* file){
    if(root == NULL) return ;
    int n = root->children.size();
    if(n==0 && root->isTerminal == false) return ;
    string temp;
    if(root->isTerminal == true) temp = root->lexeme;
    else temp = spaceToUnderscore(root->lexeme);
    char* a = strcpy(new char[temp.length() + 1], temp.c_str());
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