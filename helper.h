#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <bits/stdc++.h>

using namespace std;

// enum TokenKind {KEYWORDS, IDENTIFIERS, SEPARATORS, OPERATORS, LITERALS, PRIMITIVE_TYPE_KEYWORDS};
enum ErrorKind {MULTI_LINE_ERROR, LEXICAL_ERROR, EOF_ERROR, ILLEGALCHAR, BADEXCAPESEQ};

vector<string> LexicalErrors = {"Multilines not allowed.", "Lexical Error present.", "EOF File reached but there is unbalanced seperator", "Illegal character present.", "Bad excape sequence character present."};

string string_buffer;

void init(){
    string_buffer = "";
}

void showError(string temp, enum ErrorKind errorCode){
    // printf("Error at line num: %d\nError: %s\n", yylineno, LexicalErrors[errorCode]);
    switch (errorCode){
        case BADEXCAPESEQ:
            printf("Bad escape sequence: %s\n", temp);
            break;
        case ILLEGALCHAR:
            printf("Illegal Character: %s\n", temp);
            break;
        case LEXICAL_ERROR:
            printf("Bad Lexical Sequence starts from: %s\n", temp);
            break;
        case EOF_ERROR:
            printf("Unbalanced %s present.\n", temp);
            break;
        default:
            printf("Error: %s\n", temp);
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