%x comment
%x string

%{
    int count = 0;
    #include "helper.h"
%}

DIGIT               [0-9]
LETTER              [a-zA-Z]
OPERATOR            "+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|">"|"<="|">="|"^"|"or"|"and"|"not"|"div"|"mod"|"in"
NUMBER              [-]*{DIGIT}+[.]*{DIGIT}*
LETTER_OR_DIGIT     [a-zA-Z0-9]
IDENTIFIER          {LETTER}+{LETTER_OR_DIGIT}*
BLANK_SPACE         [ \t\f\r\n]
DELIMITOR           ","|":"|";"|"("|")"|"["|"]"|".."
KEYWORD             "array"|"begin"|"case"|"const"|"do"|"downto"|"else"|"end"|"file"|"for"|"function"|"goto"|"if"|"label"|"nil"|"of"|"packed"|"procedure"|"program"|"record"|"repeat"|"set"|"then"|"to"|"type"|"until"|"var"|"while"|"with"

%%

"{"                 BEGIN(comment);
<comment>[^}]+      /**/
<comment>"}"        {BEGIN(INITIAL);}

\"                  {buffer_pointer = string_buffer; BEGIN(string);}
<string>\n          {showError(); return(0);}
<string>\\n         {*buffer_pointer++ = '\n';}
<string>\\t         {*buffer_pointer++ = '\t';}
<string>\\r         {*buffer_pointer++ = '\r';}
<string>\\b         {*buffer_pointer++ = '\b';}
<string>\\f         {*buffer_pointer++ = '\f';}
<string>[\\][\\]    {*buffer_pointer++ = 92;}
<string>[\\][^ntrbf\\] {showError(); return(0) ;}
<string>[^"\\\n]+    {char* temp = strdup(yytext); while(*temp) {*buffer_pointer++ = *temp++;} }
<string>\"          {BEGIN(INITIAL); pushToken(STRINGS, string_buffer);}

{OPERATOR}          {char* temp = strdup(yytext); pushToken(OPERATORS, temp);}
{NUMBER}            {char* temp = strdup(yytext); pushToken(LITERALS, temp);}
{KEYWORD}           {char* temp = strdup(yytext); pushToken(KEYWORDS, temp);}
{BLANK_SPACE}       {}
{IDENTIFIER}        {char* temp = strdup(yytext); pushToken(IDENTIFIERS, temp);}
{DELIMITOR}         {char* temp = strdup(yytext); pushToken(DELIMITORS, temp);}

.                   {showError();}
%%

int main() {
    init_array();
    yylex();
    printf("Number of distinct tokens: %d\n", curr_size);
    printf("Lexeme\t\tToken\t\tCount\n");
    for(int i=0;i<curr_size;i++){
        printf("%s\t\t%s\t\t%d\n", Tokens[i].lexeme, TokenStrings[Tokens[i].TokenType], Tokens[i].count);
    }
    return 0;
}

int yywrap(){return(1);}