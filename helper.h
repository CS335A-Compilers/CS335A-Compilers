#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <bits/stdc++.h>

using namespace std;

#define INITIAL_BUFFER_SIZE 100

int buff_size_max;
int buff_size_curr;

// enum TokenKind {KEYWORDS, IDENTIFIERS, SEPARATORS, OPERATORS, LITERALS, PRIMITIVE_TYPE_KEYWORDS};
enum ErrorKind {MULTI_LINE_ERROR, LEXICAL_ERROR, EOF_ERROR, ILLEGALCHAR, BADEXCAPESEQ};

char* LexicalErrors[] = {"Multilines not allowed.", "Lexical Error present.", "EOF File reached but there is unbalanced seperator", "Illegal character present.", "Bad excape sequence character present."};

char* string_buffer;

void init(){
    string_buffer = (char*)malloc(INITIAL_BUFFER_SIZE*sizeof(char));
    buff_size_curr = 0;
    buff_size_max = INITIAL_BUFFER_SIZE;
}

void showError(char* temp, enum ErrorKind errorCode){
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
    if(buff_size_curr == buff_size_max){
        string_buffer = (char*)realloc(string_buffer,2*buff_size_curr*sizeof(char));
        buff_size_max*=2;
    }
    string_buffer[buff_size_curr] = *temp;
    buff_size_curr++;
    return ;
}

void initBuffer(char* temp){
    string_buffer = (char*)malloc(INITIAL_BUFFER_SIZE*sizeof(char));
    buff_size_curr = 0;
    buff_size_max = INITIAL_BUFFER_SIZE;
    string_buffer[buff_size_curr] = '\0';
    return ;
}

void endBuffer(char* temp1){
    string_buffer[buff_size_curr]='\0';
    char* temp = strdup(string_buffer); 
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
        showError("", BADEXCAPESEQ);
    }
    return res;
}

char* convertCurrState(int state){
    char* res;
    printf("%d\n", state);
    if(state == 1) res = "comment";
    else if(state == 2) res = "string";
    else if(state == 3) res = "char";
    else if(state == 4 || state == 5) res = "text block";
    return res; 
}