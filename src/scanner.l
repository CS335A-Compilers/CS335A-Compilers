%x comment_state
%x str_state
%x chars
%x text_block_start
%x text_block_chars

%{
    #include "inc/helper.h"
    #include "inc/symtab.h"
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

"abstract"              {char* temp = strdup(yytext); yylval.lex_val = temp; return(abstract_keyword_terminal);}
"continue"              {char* temp = strdup(yytext); yylval.lex_val = temp; return(continue_keyword_terminal);}
"for"                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(for_keyword_terminal);}
"new"                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(new_keyword_terminal);}
"assert"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(assert_keyword_terminal);}
"default"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(default_keyword_terminal);}
"if"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(if_keyword_terminal);}
"synchronized"          {char* temp = strdup(yytext); yylval.lex_val = temp; return(synchronized_keyword_terminal);}
"boolean"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(boolean_keyword_terminal);}
"do"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(do_keyword_terminal);}
"goto"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(goto_keyword_terminal);}
"private"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(private_keyword_terminal);}
"this"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(this_keyword_terminal);}
"break"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(break_keyword_terminal);}
"double"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(double_keyword_terminal);}
"implements"            {char* temp = strdup(yytext); yylval.lex_val = temp; return(implements_keyword_terminal);}
"protected"             {char* temp = strdup(yytext); yylval.lex_val = temp; return(protected_keyword_terminal);}
"throw"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(throw_keyword_terminal);}
"byte"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(byte_keyword_terminal);}
"else"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(else_keyword_terminal);}
"public"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(public_keyword_terminal);}
"instanceof"            {char* temp = strdup(yytext); yylval.lex_val = temp; return(instanceof_keyword_terminal);}
"return"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(return_keyword_terminal);}
"transient"             {char* temp = strdup(yytext); yylval.lex_val = temp; return(transient_keyword_terminal);}
"extends"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(extends_keyword_terminal);}
"int"                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(int_keyword_terminal);}
"short"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(short_keyword_terminal);}
"char"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(char_keyword_terminal);}
"final"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(final_keyword_terminal);}
"static"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(static_keyword_terminal);}
"void"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(void_keyword_terminal);}
"class"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(class_keyword_terminal);}
"long"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(long_keyword_terminal);}
"strictfp"              {char* temp = strdup(yytext); yylval.lex_val = temp; return(strictfp_keyword_terminal);}
"volatile"              {char* temp = strdup(yytext); yylval.lex_val = temp; return(volatile_keyword_terminal);}
"const"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(const_keyword_terminal);}
"float"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(float_keyword_terminal);}
"native"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(native_keyword_terminal);}
"super"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(super_keyword_terminal);}
"while"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(while_keyword_terminal);}
"_"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return(__keyword_terminal);}
"=="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(EQ_OP_TERMINAL);}
">="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(GE_OP_TERMINAL);}
"<="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(LE_OP_TERMINAL);}
"!="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(NE_OP_TERMINAL);}
"&&"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(AND_OP_TERMINAL);}
"||"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(OR_OP_TERMINAL);}
"++"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(INC_OP_TERMINAL);}
"--"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(DEC_OP_TERMINAL);}
"<<"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(LEFT_OP_TERMINAL);}
">>"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(RIGHT_OP_TERMINAL);}
">>>"                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(BIT_RIGHT_SHFT_OP_TERMINAL);}
"+="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(ADD_ASSIGN_TERMINAL);}
"-="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(SUB_ASSIGN_TERMINAL);}
"*="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(MUL_ASSIGN_TERMINAL);}
"/="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(DIV_ASSIGN_TERMINAL);}
"&="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(AND_ASSIGN_TERMINAL);}
"|="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(OR_ASSIGN_TERMINAL);}
"^="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(XOR_ASSIGN_TERMINAL);}
"%="                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(MOD_ASSIGN_TERMINAL);}
"<<="                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(LEFT_ASSIGN_TERMINAL);}
">>="                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(RIGHT_ASSIGN_TERMINAL);}
">>>="                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(BIT_RIGHT_SHFT_ASSIGN_TERMINAL);}
"="                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('=');}
">"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('>');}
"<"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('<');}
"!"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('!');}
"~"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('~');}
"?"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('?');}
":"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return(':');}
"+"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('+');}
"-"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('-');}
"*"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('*');}
"/"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('/');}
"&"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('&');}
"|"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('|');}
"^"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('^');}
"%"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('%');}
","                     {char* temp = strdup(yytext); yylval.lex_val = temp; return(',');}
"."                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('.');}
";"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return(';');}
"("                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('(');}
")"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return(')');}
"["                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('[');}
"]"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return(']');}
"{"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('{');}
"}"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('}');}
"@"                     {char* temp = strdup(yytext); yylval.lex_val = temp; return('@');}
"::"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(DOUBLE_COLON_TERMINAL);}

"/*"                              {BEGIN(comment_state);}
<comment_state>[^*\n]+            {}
<comment_state>"*"+[^*/\n]*       {}
<comment_state>\n                 {}
<comment_state>"*"+"/"            {BEGIN(INITIAL);}

"//"[^\n]*                  {}

\'                          {BEGIN(chars);}
<chars>{LINE_TERMINATOR}    {showError("", MULTI_LINE_ERROR); return(0);}
<chars>[^'\\]'              {char* temp = strdup(yytext); temp[1]=temp[0]; temp[0]='\''; temp[2]='\''; BEGIN(INITIAL); (yylval.node)->lexeme = strdup(temp); return LITERALS_TERMINAL;}
<chars>{ESCAPE_SEQUENCE}'   {char* temp = strdup(yytext); temp[0]='\''; temp[1]=*convertExcapeChar(temp[1]); temp[2]='\'';  BEGIN(INITIAL); (yylval.node)->lexeme = strdup(temp); return LITERALS_TERMINAL;}

\"                                {BEGIN(str_state); char* temp = strdup(yytext); initBuffer(temp);}
<str_state>{LINE_TERMINATOR}      {showError("", MULTI_LINE_ERROR); return(0);}
<str_state>[^"\\]                 {char* temp = strdup(yytext); pushBuffer(temp);}
<str_state>{ESCAPE_SEQUENCE}      {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}
<str_state>\"                     {BEGIN(INITIAL); char* temp = strdup(yytext); endBuffer(temp); char* lex = strcpy(new char[string_buffer.length() + 1], string_buffer.c_str()); yylval.lex_val = lex; return LITERALS_TERMINAL;}

["]["]["]                                   {BEGIN(text_block_start); char* temp = strdup(yytext); initBuffer(temp);}
<text_block_start>["]["]["]{BLANK_SPACE}*   {}
<text_block_start>{LINE_TERMINATOR}         {char* temp = strdup(yytext); pushBuffer(temp); BEGIN(text_block_chars);}
<text_block_chars>{ESCAPE_SEQUENCE}         {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}                   
<text_block_chars>[^\\]                     {char* temp = strdup(yytext); pushBuffer(temp);}
<text_block_chars>[\\]?{LINE_TERMINATOR}    {char* temp = strdup(yytext); temp[0] = temp[1]; temp[1]='\0'; pushBuffer(temp);}
<text_block_chars>[\\][^\n\r]               {string temp = strdup(yytext); showError(temp, BADEXCAPESEQ); return(0);}
<text_block_chars>["]["]["]                 {BEGIN(INITIAL); char* temp = strdup(yytext); endBuffer(temp); char* lex = strcpy(new char[string_buffer.length() + 1], string_buffer.c_str()); yylval.lex_val = lex; return LITERALS_TERMINAL;}

{NUM_LITERALS}              {char* temp = strdup(yytext); yylval.lex_val = temp; return LITERALS_TERMINAL;}
{IDENTIFIER}                {char* temp = strdup(yytext); yylval.lex_val = temp; return IDENTIFIERS_TERMINAL;}

{BLANK_SPACE}+              {}
{LINE_TERMINATOR}           {}

<str_state,chars,comment_state,text_block_start,text_block_chars><<EOF>>  {string temp = convertCurrState(YYSTATE); showError(temp, EOF_ERROR);}
<str_state,chars,text_block_start,text_block_chars,INITIAL>.              {string temp = strdup(yytext); showError(temp, LEXICAL_ERROR);}

%%

/*
 ######### Keywords ignored for time being ######### 

"switch"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(switch_keyword_terminal);}
"case"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(case_keyword_terminal);}
"enum"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(enum_keyword_terminal);}
"interface"             {char* temp = strdup(yytext); yylval.lex_val = temp; return(interface_keyword_terminal);}
"opens"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(opens_keyword_terminal);}
"requires"              {char* temp = strdup(yytext); yylval.lex_val = temp; return(requires_keyword_terminal);}
"uses"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(uses_keyword_terminal);}
"module"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(module_keyword_terminal);}
"package"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(package_keyword_terminal);}
"permits"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(permits_keyword_terminal);}
"sealed"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(sealed_keyword_terminal);}
"non-sealed"            {char* temp = strdup(yytext); yylval.lex_val = temp; return(nonsealed_keyword_terminal);}
"to"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(to_keyword_terminal);}
"with"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(with_keyword_terminal);}
"open"                  {char* temp = strdup(yytext); yylval.lex_val = temp; return(open_keyword_terminal);}
"record"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(record_keyword_terminal);}
"exports"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(exports_keyword_terminal);}
"transitive"            {char* temp = strdup(yytext); yylval.lex_val = temp; return(transitive_keyword_terminal);}
"->"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(PTR_OP_TERMINAL);}
"provides"              {char* temp = strdup(yytext); yylval.lex_val = temp; return(provides_keyword_terminal);}
"throws"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(throws_keyword_terminal);}
"var"                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(var_keyword_terminal);}
"yield"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(yield_keyword_terminal);}
"import"                {char* temp = strdup(yytext); yylval.lex_val = temp; return(import_keyword_terminal);}
"catch"                 {char* temp = strdup(yytext); yylval.lex_val = temp; return(catch_keyword_terminal);}
"finally"               {char* temp = strdup(yytext); yylval.lex_val = temp; return(finally_keyword_terminal);}
"try"                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(try_keyword_terminal);}
"<>"                    {char* temp = strdup(yytext); yylval.lex_val = temp; return(DIAMOND_TERMINAL);}
"..."                   {char* temp = strdup(yytext); yylval.lex_val = temp; return(ELLIPSIS_TERMINAL);}


*/
int yywrap(){
    return(1);
}

/*int main(){
    while(1) yylex();
    return 0;
}*/