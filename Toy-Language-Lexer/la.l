%x comment
%x string

%{
    #include "la.h"
%}

DIGIT               [0-9]
LETTER              [a-zA-Z]
OPERATOR            "+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|">"|"<="|">="|"^"|"or"|"and"|"not"|"div"|"mod"|"in"
INT_NUM             {DIGIT}+
FLOAT_NUM           {DIGIT}+[.]{DIGIT}+
NUMBER              {INT_NUM}|{FLOAT_NUM}
EXPONENT_INDICATOR  E|e
EXPONENT_SIGN       "+"|"-"
EXPONENT_NUM        {NUMBER}{EXPONENT_INDICATOR}{EXPONENT_SIGN}?{INT_NUM}
LETTER_OR_DIGIT     [a-zA-Z0-9]
IDENTIFIER          {LETTER}+{LETTER_OR_DIGIT}*
BLANK_SPACE         [ \t\r]
NEWLINE_SPACE       [\n\f\v]
DELIMITOR           ","|":"|";"|"("|")"|"["|"]"|".."
KEYWORD             "array"|"begin"|"case"|"const"|"do"|"downto"|"else"|"end"|"file"|"for"|"function"|"goto"|"if"|"label"|"nil"|"of"|"packed"|"procedure"|"program"|"record"|"repeat"|"set"|"then"|"to"|"type"|"until"|"var"|"while"|"with"

%%

"{"                 BEGIN(comment);
<comment>[^}\n]+    /**/
<comment>[\n]       {line_nums++;}
<comment>"}"        {BEGIN(INITIAL);}

\"                  {buffer_pointer = string_buffer; BEGIN(string);}
<string>\n          {showError("", STRINGERROR); line_nums++; return(0);}
<string>\\n         {*buffer_pointer++ = '\n';}
<string>\\t         {*buffer_pointer++ = '\t';}
<string>\\r         {*buffer_pointer++ = '\r';}
<string>\\b         {*buffer_pointer++ = '\b';}
<string>\\f         {*buffer_pointer++ = '\f';}
<string>[\\][\"]    {*buffer_pointer++ = '\"';}
<string>[\\][\']    {*buffer_pointer++ = '\'';}
<string>[\\][\\]    {*buffer_pointer++ = '\\';}
<string>[\\][^ntrbf\\] {char* temp = strdup(yytext); showError(temp, BADEXCAPESEQ); return(0) ;}
<string>[^"\\\n]+   {char* temp = strdup(yytext); while(*temp) {*buffer_pointer++ = *temp++;} }
<string>\"          {BEGIN(INITIAL); *buffer_pointer='\0'; char* temp = strdup(string_buffer); pushToken(STRINGS, temp);}

{NEWLINE_SPACE}     {line_nums++;}
{OPERATOR}          {char* temp = strdup(yytext); pushToken(OPERATORS, temp);}
{NUMBER}|{EXPONENT_NUM} {char* temp = strdup(yytext); pushToken(LITERALS, temp);}
{KEYWORD}           {char* temp = strdup(yytext); pushToken(KEYWORDS, temp);}
{BLANK_SPACE}*      {}
{IDENTIFIER}        {char* temp = strdup(yytext); pushToken(IDENTIFIERS, temp);}
{DELIMITOR}         {char* temp = strdup(yytext); pushToken(DELIMITORS, temp);}
.                   {char* temp = strdup(yytext); showError(temp, ILLEGALCHAR); return(0);}

%%

int main() {
    init();
    yylex();
    if(!ScannerTerminated){
        writeToCSV();
    }
    return 0;
}

int yywrap(){return(1);}