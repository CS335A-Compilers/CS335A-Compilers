%{
    #include <math.h>
    #include <stdio.h>
    int yylex(void);
    void yyerror(char const*);
%}

%union{
    int integer;
    float floating;
    char* string;
}

%start  Start

%token  <integer>   NUMBER
%token  <string>    WORD SENTENCE_END NEWLINE WORD_SEPERATOR KEYWORD SPACE

%type   <string>    Sentence Sentence_body 

%%

Start:      
    |   Start Sentence                                      {}

Sentence:           Sentence_body SENTENCE_END       {printf("Detected: %s\n", $$);}
Sentence_body:    
                |   WORD Sentence_body
                |   Spaces Sentence_body
                |   WORD WORD_SEPERATOR Spaces Sentence_body
Spaces:         
                |   " " Spaces


%%

int main(){
    yyparse();
    return 0;
}

void yyerror (char const *s) {
  printf("Error: %s\n", s);
}
