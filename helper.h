#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define INTIAL_ARRAY_SIZE 1
#define STRING_BUFFER_SIZE 1000

int curr_size = 0;
int curr_max_size = INTIAL_ARRAY_SIZE;
char* buffer_pointer;

enum TokenKind { KEYWORDS, IDENTIFIERS, DELIMITORS, OPERATORS, LITERALS, STRINGS};

char* TokenStrings[] = { "KEYWORDS", "IDENTIFIERS", "DELIMITORS", "OPERATORS", "LITERALS", "STRINGS"};
char string_buffer[STRING_BUFFER_SIZE];

typedef struct{
    enum TokenKind TokenType;
    char* lexeme;
    int count;
    // Other attributes not needed as of now :)
} Token;

Token* Tokens;

void init_array(){
    Tokens = (Token*)malloc(INTIAL_ARRAY_SIZE * sizeof(Token));    
}

void pushTokenUtil(Token tk){
    char* lex = tk.lexeme;
    for(int i=0;i<curr_size;i++){
        if(!strcmp(Tokens[i].lexeme, lex)){
            Tokens[i].count+=1;
            return ;
        }
    }
    if(curr_size == curr_max_size){
        Tokens = (Token*)realloc(Tokens, 2*curr_max_size*sizeof(Token));
        curr_max_size*=2;
    }
    Tokens[curr_size].count = tk.count;
    Tokens[curr_size].lexeme = tk.lexeme;
    Tokens[curr_size].TokenType = tk.TokenType;
    curr_size++;
    return ;
}

void pushToken(enum TokenKind TokenType, char* lex){
    Token* tk = (Token*)malloc(sizeof(Token));  
    tk->count = 1;
    tk->lexeme = lex;
    tk->TokenType = TokenType;
    pushTokenUtil(*tk); 
    return ;
}

void showError(){
    printf("Tokenization error present... Terminating Scanner!\n");
    return ;
}