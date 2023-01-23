#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define INTIAL_ARRAY_SIZE 10
#define STRING_BUFFER_SIZE 1000

int curr_size;
int curr_max_size;
int line_nums;
char* buffer_pointer;
int ScannerTerminated ;

enum TokenKind { KEYWORDS, IDENTIFIERS, DELIMITORS, OPERATORS, LITERALS, STRINGS};
enum ErrorKind {STRINGERROR, ILLEGALCHAR, BADEXCAPESEQ};

char* TokenStrings[] = { "KEYWORD", "IDENTIFIER", "DELIMITOR", "OPERATOR", "LITERAL", "STRING"};
char* LexicalErrors[] = {"String cannot contain multiple lines.", "Illegal character present.", "Bad excape sequence character present."};

char string_buffer[STRING_BUFFER_SIZE];

typedef struct{
    enum TokenKind TokenType;
    char* lexeme;
    int count;
    // Other attributes not needed as of now :) but will need in future!
} Token;

Token* Tokens;

void init(){
    Tokens = (Token*)malloc(INTIAL_ARRAY_SIZE * sizeof(Token));    
    curr_size = 0;
    curr_max_size = INTIAL_ARRAY_SIZE;
    line_nums = 1;
    ScannerTerminated = 0;
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
    memcpy(&Tokens[curr_size], &tk, sizeof(Token));
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

void showError(char* temp, enum ErrorKind errorCode){
    ScannerTerminated = 1;
    printf("Error at line num: %d\nError: %s\n", line_nums, LexicalErrors[errorCode]);
    switch (errorCode){
        case BADEXCAPESEQ:
            printf("Bad escape sequence: %s\n", temp);
            break;
        case ILLEGALCHAR:
            printf("Illegal Character: %s\n", temp);
            break;
        default:
            break;
    }
    return ;
}

void writeToCSV(){
    printf("Number of distinct tokens: %d\n", curr_size);

    FILE* fpt;
    fpt = fopen("output.csv", "w+");
    fprintf(fpt, "Lexeme, Token, Count\n");
    for(int i=0;i<curr_size;i++){
        fprintf(fpt, "\"%s\", %s, %d\n", Tokens[i].lexeme, TokenStrings[Tokens[i].TokenType], Tokens[i].count);
    }
    fclose(fpt);
    return ;
}

void pushDotFuntion(char* temp){
    int n = strlen(temp);
    int pos = -1;
    for(int i=0;i<n-1;i++){
        if(temp[i]==temp[i+1] && temp[i]=='.') {
            pos = i;
            break;   
        }
    }
    if(pos==-1) {
        ScannerTerminated = 1;
        showError("", ILLEGALCHAR);
        return ;
    }
    char* num1 = strdup(temp);
    char* num2 = strdup(temp);
    num1[pos] = '\0';
    num2 = num2+pos+2;
    pushToken(LITERALS, num1);
    pushToken(DELIMITORS, "..");
    pushToken(LITERALS, num2);
    return ;
}