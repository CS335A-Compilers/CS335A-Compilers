%x comment
%x str
%x chars
%x text_block_start
%x text_block_chars

%{
    #include "ast.h"
    #include "helper.h"
    #include "parser.tab.h"
%}

%option yylineno

JAVA_LETTER_OR_DIGIT        {JAVA_LETTER}|{DIGIT}
JAVA_LETTER                 [a-zA-Z]|{UNDERSCORE}
LINE_TERMINATOR             [\n\r]
BLANK_SPACE                 [ \t\f]


IDENTIFIER                  {JAVA_LETTER}{JAVA_LETTER_OR_DIGIT}*
NUM_LITERALS                {INT_LITERAL}|{FLOAT_LITERAL}|{BOOL_LITERAL}|{NULL_LITERAL}
INTEGERAL_TYPE              "byte"|"short"|"int"|"long"|"char"
FLOATING_TYPE               "float"|"double"

INT_LITERAL                 {DECIMAL_INT_LITERAL}|{HEX_INT_LITERAL}|{OCT_INT_LITERAL}|{BIN_INT_LITERAL}
FLOAT_LITERAL               {DECIMAL_FLOAT_LITERAL}|{HEX_FLOAT_LITERAL} 
BOOL_LITERAL                "true"|"false"
NULL_LITERAL                "null"

NON_ZERO_DIGIT              [1-9]
DIGIT                       "0"|{NON_ZERO_DIGIT}
DIGITS                      {DIGIT}|{DIGIT}{DIGIT_AND_UNDERSCORE}?{DIGIT}
DIGIT_AND_UNDERSCORE        {DIGIT_OR_UNDERSCORE}+
DIGIT_OR_UNDERSCORE         {DIGIT}|_
UNDERSCORE                  _
UNDERSCORES                 {UNDERSCORE}+
DECIMAL_INT_LITERAL         {DECIMAL_NUM}{INT_TYPE_SUFFIX}?
DECIMAL_NUM                 "0"|{NON_ZERO_DIGIT}{DIGITS}?|{NON_ZERO_DIGIT}{UNDERSCORES}{DIGITS}
INT_TYPE_SUFFIX             "L"|"l"

HEX_INT_LITERAL             {HEX_NUM}{INT_TYPE_SUFFIX}?
HEX_INDICATOR               "x"|"X"
HEX_NUM                     0{HEX_INDICATOR}{HEX_DIGITS}
HEX_DIGITS                  {HEX_DIGIT}|{HEX_DIGIT}{HEX_DIGIT_AND_UNDERSCORE}?{HEX_DIGIT}
HEX_DIGIT                   [0-9a-fA-F]
HEX_DIGIT_AND_UNDERSCORE    {HEX_DIGIT_OR_UNDERSCORE}+
HEX_DIGIT_OR_UNDERSCORE     {HEX_DIGIT}|{UNDERSCORE}

OCT_INT_LITERAL             {OCT_NUM}{INT_TYPE_SUFFIX}?
OCT_NUM                     0{OCTAL_DIGITS}|0{UNDERSCORES}{OCTAL_DIGITS}
OCTAL_DIGITS                {OCTAL_DIGIT}|{OCTAL_DIGIT}{OCTAL_DIGIT_AND_UNDERSCORES}?{OCTAL_DIGIT}
OCTAL_DIGIT                 [0-7]
OCTAL_DIGIT_AND_UNDERSCORES {OCTAL_DIGIT_OR_UNDERSCORE}+
OCTAL_DIGIT_OR_UNDERSCORE   {OCTAL_DIGIT}|{UNDERSCORE}

BIN_INT_LITERAL             {BIN_NUM}{INT_TYPE_SUFFIX}?
BIN_INDICATOR               "b"|"B"
BIN_NUM                     0{BIN_INDICATOR}{BIN_DIGITS}
BIN_DIGITS                  {BIN_DIGIT}|{BIN_DIGIT}{BIN_DIGIT_AND_UNDERSCORES}?{BIN_DIGIT}
BIN_DIGIT                   [0-1]
BIN_DIGIT_AND_UNDERSCORES   {BIN_DIGIT_OR_UNDERSCORE}+
BIN_DIGIT_OR_UNDERSCORE     {BIN_DIGIT}|{UNDERSCORE}

DECIMAL_FLOAT_LITERAL       {DIGITS}[.]{DIGITS}?{EXPONENT_PART}?{FLOAT_TYPE_SUFFIX}?|[.]{DIGITS}{EXPONENT_PART}?{FLOAT_TYPE_SUFFIX}?|{DIGITS}{EXPONENT_PART}{FLOAT_TYPE_SUFFIX}?|{DIGITS}{EXPONENT_PART}?{FLOAT_TYPE_SUFFIX}
EXPONENT_PART               {EXPONENT_INDICATOR}{SIGN_INTEGER}
EXPONENT_INDICATOR          "E"|"e"
SIGN_INTEGER                {SIGN}?{DIGITS}
SIGN                        "+"|"-"
FLOAT_TYPE_SUFFIX           F|f|d|D

HEX_FLOAT_LITERAL           {HEX_SIGNIFICAND}{BIN_EXPONENT}{FLOAT_TYPE_SUFFIX}?
HEX_SIGNIFICAND             {HEX_NUM}[.]?|0{HEX_INDICATOR}{HEX_DIGITS}?[.]{HEX_DIGITS}
BIN_EXPONENT                {BIN_EXP_INDICATOR}{SIGN_INTEGER}
BIN_EXP_INDICATOR           P|p

TEXT_BLOCK                  ["]["]["]{BLANK_SPACE}*{LINE_TERMINATOR}{TEXT_BLOCK_CHAR}*["]["]["]
TEXT_BLOCK_CHAR             [^\\]|{ESCAPE_SEQUENCE}|{LINE_TERMINATOR}

ESCAPE_SEQUENCE             \\b|\\t|\\f|\\r|[\\][\"]|\\'|[\\][\\]|\\n|{OCTAL_EXCAPE}
OCTAL_EXCAPE                \\{OCTAL_DIGIT}|\\{OCTAL_DIGIT}{OCTAL_DIGIT}|\\[0-3]{OCTAL_DIGIT}{OCTAL_DIGIT}


%%

"abstract"              {yylval.node.lexeme = strdup(yytext); return(ABSTRACT_KEYWORD);}
"continue"              {yylval.node.lexeme = strdup(yytext); return(CONTINUE_KEYWORD);}
"for"                   {yylval.node.lexeme = strdup(yytext); return(FOR_KEYWORD);}
"new"                   {yylval.node.lexeme = strdup(yytext); return(NEW_KEYWORD);}
"switch"                {yylval.node.lexeme = strdup(yytext); return(SWITCH_KEYWORD);}
"assert"                {yylval.node.lexeme = strdup(yytext); return(ASSERT_KEYWORD);}
"default"               {yylval.node.lexeme = strdup(yytext); return(DEFAULT_KEYWORD);}
"if"                    {yylval.node.lexeme = strdup(yytext); return(IF_KEYWORD);}
"package"               {yylval.node.lexeme = strdup(yytext); return(PACKAGE_KEYWORD);}
"synchronized"          {yylval.node.lexeme = strdup(yytext); return(SYNCHRONIZED_KEYWORD);}
"boolean"               {yylval.node.lexeme = strdup(yytext); return(BOOLEAN_KEYWORD);}
"do"                    {yylval.node.lexeme = strdup(yytext); return(DO_KEYWORD);}
"goto"                  {yylval.node.lexeme = strdup(yytext); return(GOTO_KEYWORD);}
"private"               {yylval.node.lexeme = strdup(yytext); return(PRIVATE_KEYWORD);}
"this"                  {yylval.node.lexeme = strdup(yytext); return(THIS_KEYWORD);}
"break"                 {yylval.node.lexeme = strdup(yytext); return(BREAK_KEYWORD);}
"double"                {yylval.node.lexeme = strdup(yytext); return(DOUBLE_KEYWORD);}
"implements"            {yylval.node.lexeme = strdup(yytext); return(IMPLEMENTS_KEYWORD);}
"protected"             {yylval.node.lexeme = strdup(yytext); return(PROTECTED_KEYWORD);}
"throw"                 {yylval.node.lexeme = strdup(yytext); return(THROW_KEYWORD);}
"byte"                  {yylval.node.lexeme = strdup(yytext); return(BYTE_KEYWORD);}
"else"                  {yylval.node.lexeme = strdup(yytext); return(ELSE_KEYWORD);}
"import"                {yylval.node.lexeme = strdup(yytext); return(IMPORT_KEYWORD);}
"public"                {yylval.node.lexeme = strdup(yytext); return(PUBLIC_KEYWORD);}
"throws"                {yylval.node.lexeme = strdup(yytext); return(THROWS_KEYWORD);}
"case"                  {yylval.node.lexeme = strdup(yytext); return(CASE_KEYWORD);}
"enum"                  {yylval.node.lexeme = strdup(yytext); return(ENUM_KEYWORD);}
"instanceof"            {yylval.node.lexeme = strdup(yytext); return(INSTANCEOF_KEYWORD);}
"return"                {yylval.node.lexeme = strdup(yytext); return(RETURN_KEYWORD);}
"transient"             {yylval.node.lexeme = strdup(yytext); return(TRANSIENT_KEYWORD);}
"catch"                 {yylval.node.lexeme = strdup(yytext); return(CATCH_KEYWORD);}
"extends"               {yylval.node.lexeme = strdup(yytext); return(EXTENDS_KEYWORD);}
"int"                   {yylval.node.lexeme = strdup(yytext); return(INT_KEYWORD);}
"short"                 {yylval.node.lexeme = strdup(yytext); return(SHORT_KEYWORD);}
"try"                   {yylval.node.lexeme = strdup(yytext); return(TRY_KEYWORD);}
"char"                  {yylval.node.lexeme = strdup(yytext); return(CHAR_KEYWORD);}
"final"                 {yylval.node.lexeme = strdup(yytext); return(FINAL_KEYWORD);}
"interface"             {yylval.node.lexeme = strdup(yytext); return(INTERFACE_KEYWORD);}
"static"                {yylval.node.lexeme = strdup(yytext); return(STATIC_KEYWORD);}
"void"                  {yylval.node.lexeme = strdup(yytext); return(VOID_KEYWORD);}
"class"                 {yylval.node.lexeme = strdup(yytext); return(CLASS_KEYWORD);}
"finally"               {yylval.node.lexeme = strdup(yytext); return(FINALLY_KEYWORD);}
"long"                  {yylval.node.lexeme = strdup(yytext); return(LONG_KEYWORD);}
"strictfp"              {yylval.node.lexeme = strdup(yytext); return(STRICTFP_KEYWORD);}
"volatile"              {yylval.node.lexeme = strdup(yytext); return(VOLATILE_KEYWORD);}
"const"                 {yylval.node.lexeme = strdup(yytext); return(CONST_KEYWORD);}
"float"                 {yylval.node.lexeme = strdup(yytext); return(FLOAT_KEYWORD);}
"native"                {yylval.node.lexeme = strdup(yytext); return(NATIVE_KEYWORD);}
"super"                 {yylval.node.lexeme = strdup(yytext); return(SUPER_KEYWORD);}
"while"                 {yylval.node.lexeme = strdup(yytext); return(WHILE_KEYWORD);}
"_"                     {yylval.node.lexeme = strdup(yytext); return(__KEYWORD);}
"exports"               {yylval.node.lexeme = strdup(yytext); return(EXPORTS_KEYWORD);}
"opens"                 {yylval.node.lexeme = strdup(yytext); return(OPENS_KEYWORD);}
"requires"              {yylval.node.lexeme = strdup(yytext); return(REQUIRES_KEYWORD);}
"uses"                  {yylval.node.lexeme = strdup(yytext); return(USES_KEYWORD);}
"module"                {yylval.node.lexeme = strdup(yytext); return(MODULE_KEYWORD);}
"permits"               {yylval.node.lexeme = strdup(yytext); return(PERMITS_KEYWORD);}
"sealed"                {yylval.node.lexeme = strdup(yytext); return(SEALED_KEYWORD);}
"var"                   {yylval.node.lexeme = strdup(yytext); return(VAR_KEYWORD);}
"non- sealed"           {yylval.node.lexeme = strdup(yytext); return(NONSEALED_KEYWORD);}
"provides"              {yylval.node.lexeme = strdup(yytext); return(PROVIDES_KEYWORD);}
"to"                    {yylval.node.lexeme = strdup(yytext); return(TO_KEYWORD);}
"with"                  {yylval.node.lexeme = strdup(yytext); return(WITH_KEYWORD);}
"open"                  {yylval.node.lexeme = strdup(yytext); return(OPEN_KEYWORD);}
"record"                {yylval.node.lexeme = strdup(yytext); return(RECORD_KEYWORD);}
"transitive"            {yylval.node.lexeme = strdup(yytext); return(TRANSITIVE_KEYWORD);}
"yield"                 {yylval.node.lexeme = strdup(yytext); return(YIELD_KEYWORD);}
"<>"                    {yylval.node.lexeme = strdup(yytext); return(DIAMOND);}
"->"                    {yylval.node.lexeme = strdup(yytext); return(PTR_OP);}
"=="                    {yylval.node.lexeme = strdup(yytext); return(EQ_OP);}
">="                    {yylval.node.lexeme = strdup(yytext); return(GE_OP);}
"<="                    {yylval.node.lexeme = strdup(yytext); return(LE_OP);}
"!="                    {yylval.node.lexeme = strdup(yytext); return(NE_OP);}
"&&"                    {yylval.node.lexeme = strdup(yytext); return(AND_OP);}
"||"                    {yylval.node.lexeme = strdup(yytext); return(OR_OP);}
"++"                    {yylval.node.lexeme = strdup(yytext); return(INC_OP);}
"--"                    {yylval.node.lexeme = strdup(yytext); return(DEC_OP);}
"<<"                    {yylval.node.lexeme = strdup(yytext); return(LEFT_OP);}
">>"                    {yylval.node.lexeme = strdup(yytext); return(RIGHT_OP);}
">>>"                   {yylval.node.lexeme = strdup(yytext); return(BIT_RIGHT_SHFT_OP);}
"+="                    {yylval.node.lexeme = strdup(yytext); return(ADD_ASSIGN);}
"-="                    {yylval.node.lexeme = strdup(yytext); return(SUB_ASSIGN);}
"*="                    {yylval.node.lexeme = strdup(yytext); return(MUL_ASSIGN);}
"/="                    {yylval.node.lexeme = strdup(yytext); return(DIV_ASSIGN);}
"&="                    {yylval.node.lexeme = strdup(yytext); return(AND_ASSIGN);}
"|="                    {yylval.node.lexeme = strdup(yytext); return(OR_ASSIGN);}
"^="                    {yylval.node.lexeme = strdup(yytext); return(XOR_ASSIGN);}
"%="                    {yylval.node.lexeme = strdup(yytext); return(MOD_ASSIGN);}
"<<="                   {yylval.node.lexeme = strdup(yytext); return(LEFT_ASSIGN);}
">>="                   {yylval.node.lexeme = strdup(yytext); return(RIGHT_ASSIGN);}
">>>="                  {yylval.node.lexeme = strdup(yytext); return(BIT_RIGHT_SHFT_ASSIGN);}
"="                     {yylval.node.lexeme = strdup(yytext); return('=');}
">"                     {yylval.node.lexeme = strdup(yytext); return('>');}
"<"                     {yylval.node.lexeme = strdup(yytext); return('<');}
"!"                     {yylval.node.lexeme = strdup(yytext); return('!');}
"~"                     {yylval.node.lexeme = strdup(yytext); return('~');}
"?"                     {yylval.node.lexeme = strdup(yytext); return('?');}
":"                     {yylval.node.lexeme = strdup(yytext); return(':');}
"+"                     {yylval.node.lexeme = strdup(yytext); return('+');}
"-"                     {yylval.node.lexeme = strdup(yytext); return('-');}
"*"                     {yylval.node.lexeme = strdup(yytext); return('*');}
"/"                     {yylval.node.lexeme = strdup(yytext); return('/');}
"&"                     {yylval.node.lexeme = strdup(yytext); return('&');}
"|"                     {yylval.node.lexeme = strdup(yytext); return('|');}
"^"                     {yylval.node.lexeme = strdup(yytext); return('^');}
"%"                     {yylval.node.lexeme = strdup(yytext); return('%');}
","                     {yylval.node.lexeme = strdup(yytext); return(',');}
"."                     {yylval.node.lexeme = strdup(yytext); return('.');}
";"                     {yylval.node.lexeme = strdup(yytext); return(';');}
"("                     {yylval.node.lexeme = strdup(yytext); return('(');}
")"                     {yylval.node.lexeme = strdup(yytext); return(')');}
"["                     {yylval.node.lexeme = strdup(yytext); return('[');}
"]"                     {yylval.node.lexeme = strdup(yytext); return(']');}
"{"                     {yylval.node.lexeme = strdup(yytext); return('{');}
"}"                     {yylval.node.lexeme = strdup(yytext); return('}');}
"@"                     {yylval.node.lexeme = strdup(yytext); return('@');}
"..."                   {yylval.node.lexeme = strdup(yytext); return(ELLIPSIS);}
"::"                    {yylval.node.lexeme = strdup(yytext); return(DOUBLE_COLON);}

"/*"                        {BEGIN(comment);}
<comment>[^*\n]+            {}
<comment>"*"+[^*/\n]*       {}
<comment>\n                 {}
<comment>"*"+"/"            {BEGIN(INITIAL);}

"//"[^\n]*                  {}

\'                          {BEGIN(chars);}
<chars>{LINE_TERMINATOR}    {showError("", MULTI_LINE_ERROR); return(0);}
<chars>[^'\\]'              {char* temp = strdup(yytext); temp[1]=temp[0]; temp[0]='\''; temp[2]='\''; BEGIN(INITIAL); yylval.node.lexeme = strdup(temp); return LITERALS;}
<chars>{ESCAPE_SEQUENCE}'   {char* temp = strdup(yytext); temp[0]='\''; temp[1]=*convertExcapeChar(temp[1]); temp[2]='\'';  BEGIN(INITIAL); yylval.node.lexeme = strdup(temp); return LITERALS;}

\"                          {BEGIN(str); char* temp = strdup(yytext); initBuffer(temp);}
<str>{LINE_TERMINATOR}      {showError("", MULTI_LINE_ERROR); return(0);}
<str>[^"\\]                 {char* temp = strdup(yytext); pushBuffer(temp);}
<str>{ESCAPE_SEQUENCE}      {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}
<str>\"                     {BEGIN(INITIAL); char* temp = strdup(yytext); endBuffer(temp); yylval.node.lexeme = strdup(string_buffer); return LITERALS;}

["]["]["]                                   {BEGIN(text_block_start); char* temp = strdup(yytext); initBuffer(temp);}
<text_block_start>["]["]["]{BLANK_SPACE}*         {}
<text_block_start>{LINE_TERMINATOR}               {char* temp = strdup(yytext); pushBuffer(temp); BEGIN(text_block_chars);}
<text_block_chars>{ESCAPE_SEQUENCE}         {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}                   
<text_block_chars>[^\\]                     {char* temp = strdup(yytext); pushBuffer(temp);}
<text_block_chars>[\\]?{LINE_TERMINATOR}    {char* temp = strdup(yytext); temp[0] = temp[1]; temp[1]='\0'; pushBuffer(temp);}
<text_block_chars>[\\][^\n\r]               {char* temp = strdup(yytext); showError(temp, BADEXCAPESEQ); return(0);}
<text_block_chars>["]["]["]                 {BEGIN(INITIAL); char* temp = strdup(yytext); endBuffer(temp); yylval.node.lexeme = strdup(string_buffer); return LITERALS;}

{NUM_LITERALS}              {yylval.node.lexeme = strdup(yytext); return LITERALS;}
{IDENTIFIER}                {yylval.node.lexeme = strdup(yytext); return IDENTIFIERS;}

{BLANK_SPACE}+              {}
{LINE_TERMINATOR}           {}

<str,chars,comment,text_block_start,text_block_chars><<EOF>>  {char* temp = convertCurrState(YYSTATE); showError(temp, EOF_ERROR);}
<str,chars,text_block_start,text_block_chars,INITIAL>.        {char* temp = strdup(yytext); showError(temp, LEXICAL_ERROR);}

%%

int yywrap(){
    return(1);
}

/*int main(){
    while(1) yylex();
    return 0;
}*/