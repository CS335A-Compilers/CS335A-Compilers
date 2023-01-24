#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define INTIAL_ARRAY_SIZE 10
#define INITIAL_BUFFER_SIZE 100

int curr_size;
int curr_max_size;
int line_nums;
int buff_size_max;
int buff_size_curr;
int ScannerTerminated ;

enum TokenKind {KEYWORDS, IDENTIFIERS, SEPARATORS, OPERATORS, LITERALS};
enum ErrorKind {MULTI_LINE_ERROR, LEXICAL_ERROR, EOF_ERROR, ILLEGALCHAR, BADEXCAPESEQ};

char* TokenStrings[] = { "KEYWORD", "IDENTIFIER", "SEPARATOR", "OPERATOR", "LITERAL"};
char* LexicalErrors[] = {"Multilines not allowed.", "Lexical Error present.", "EOF File reached but there is unbalanced seperator", "Illegal character present.", "Bad excape sequence character present."};

char* string_buffer;

typedef struct{
    enum TokenKind TokenType;
    char* lexeme;
    int count;
    // Other attributes not needed as of now :) but will need in future!
} Token;

Token* Tokens;

void init(){
    Tokens = (Token*)malloc(INTIAL_ARRAY_SIZE * sizeof(Token));    
    string_buffer = (char*)malloc(INITIAL_BUFFER_SIZE*sizeof(char));
    curr_size = 0;
    buff_size_curr = 0;
    curr_max_size = INTIAL_ARRAY_SIZE;
    buff_size_max = INITIAL_BUFFER_SIZE;
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
        case LEXICAL_ERROR:
            printf("Bad Lexical Sequence starts from: %s\n", temp);
            break;
        case EOF_ERROR:
            printf("Unbalanced %s present.\n", temp);
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
        fprintf(fpt, "%s, %s, %d\n", Tokens[i].lexeme, TokenStrings[Tokens[i].TokenType], Tokens[i].count);
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
    pushToken(SEPARATORS, "..");
    pushToken(LITERALS, num2);
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
    while(*temp) pushBuffer(temp++);
    return ;
}

void endBuffer(char* temp1){
    while(*temp1) pushBuffer(temp1++);
    string_buffer[buff_size_curr]='\0';
    char* temp = strdup(string_buffer); 
    pushToken(LITERALS, temp);
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