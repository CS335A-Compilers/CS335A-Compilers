%x comment

%{
    int count = 0;
    #include "helper.h"
%}

DIGIT               [0-9]
LETTER              [a-zA-Z]
NUMBER              [-]*{DIGIT}+[.]*{DIGIT}*
LETTER_OR_DIGIT     [a-zA-Z0-9]
IDENTIFIER          {LETTER}+{LETTER_OR_DIGIT}*
BLANK_SPACE         [ \t\f\r\n]
OPERATOR            "+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|">"|"<="|">="|"^"|"or"|"and"|"not"|"div"|"mod"|"in"
DELIMITOR           ","|":"|";"|"("|")"|"["|"]"|".."
KEYWORD             "array"|"begin"|"case"|"const"|"do"|"downto"|"else"|"end"|"file"|"for"|"function"|"goto"|"if"|"label"|"nil"|"of"|"packed"|"procedure"|"program"|"record"|"repeat"|"set"|"then"|"to"|"type"|"until"|"var"|"while"|"with"

%%
"{"                 BEGIN(comment);
<comment>[^}]+      /**/
<comment>"}"        {BEGIN(INITIAL);}
{NUMBER}            {char* temp = strdup(yytext); pushToken(LITERALS, temp);}
{OPERATOR}          {char* temp = strdup(yytext); pushToken(OPERATORS, temp);}
{KEYWORD}           {char* temp = strdup(yytext); pushToken(KEYWORDS, temp);}
{IDENTIFIER}        {char* temp = strdup(yytext); pushToken(IDENTIFIERS, temp);}
{DELIMITOR}         {char* temp = strdup(yytext); pushToken(DELIMITORS, temp);}

%%

int main() {
    init_array();
    yylex();
    printf("Lexeme\t\tToken\t\tCount\n");
    printf("Number of distinct tokens: %d\n", curr_size);
    for(int i=0;i<curr_size;i++){
        printf("%s\t\t%s\t\t%d\n", Tokens[i].lexeme, TokenStrings[Tokens[i].TokenType], Tokens[i].count);
    }
    return 0;
}

int yywrap(){return(1);}