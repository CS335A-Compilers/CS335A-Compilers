%x comment
%x string

%{
    #include "../helper.h"
%}

DIGIT               [0-9]
LETTER              [a-zA-Z]
OPERATOR            "+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|">"|"<="|">="|"^"|"or"|"and"|"not"|"div"|"mod"|"in"
INT_NUM             {DIGIT}+
FLOAT_NUM           {DIGIT}+[.]{DIGIT}*
ERROR_NUM           [.]{DIGIT}+
DOT_OPERATOR        {NUMBER}[.][.]{NUMBER}
ESCAPE_SEQUENCE     \\b|\\t|\\f|\\r|[\\][\"]|\\'|[\\][\\]|\\n

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

"{"                             BEGIN(comment);
<comment>[^}\n]+                /**/
<comment>[\n]                   {line_nums++;}
<comment>"}"                    {BEGIN(INITIAL);}

\"                              {BEGIN(string); initBuffer();}
<string>\n                      {showError("", MULTI_LINE_ERROR); line_nums++; return(0);}
<string>{ESCAPE_SEQUENCE}       {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}
<string>[\\][^ntrbf\\]          {char* temp = strdup(yytext); showError(temp, BADEXCAPESEQ); return(0) ;}
<string>[^"\\]                  {char* temp = strdup(yytext); pushBuffer(temp);}
<string>\"                      {BEGIN(INITIAL); endBuffer();}

{DOT_OPERATOR}                  {char* temp = strdup(yytext); pushDotFuntion(temp);}
{ERROR_NUM}                     {char* temp = strdup(yytext); showError(temp, ILLEGALCHAR); return(0);}
{NEWLINE_SPACE}                 {line_nums++;}
{OPERATOR}                      {char* temp = strdup(yytext); pushToken(OPERATORS, temp);}
{NUMBER}|{EXPONENT_NUM}         {char* temp = strdup(yytext); pushToken(LITERALS, temp);}
{KEYWORD}                       {char* temp = strdup(yytext); pushToken(KEYWORDS, temp);}
{BLANK_SPACE}*                  {}
{IDENTIFIER}                    {char* temp = strdup(yytext); pushToken(IDENTIFIERS, temp);}
{DELIMITOR}                     {char* temp = strdup(yytext); pushToken(SEPARATORS, temp);}

<string,comment><<EOF>>         {showError("", EOF_ERROR); return(0);}
.                               {char* temp = strdup(yytext); showError(temp, ILLEGALCHAR); return(0);}

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