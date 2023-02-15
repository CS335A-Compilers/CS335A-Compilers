%x comment
%x str
%x chars
%x text_block
%x text_block_chars


%{
    #include "parser.tab.h"
    #include "helper.h"
    #include "header.h"
%}

%option yylineno

JAVA_LETTER_OR_DIGIT        {JAVA_LETTER}|{DIGIT}
JAVA_LETTER                 [a-zA-Z]|{UNDERSCORE}
LINE_TERMINATOR             [\n\r]
BLANK_SPACE                 [ \t\f]

PRIMITIVE_TYPE_KEYWORD      "byte"|"short"|"int"|"long"|"char"|"float"|"double"|"boolean"
IDENTIFIER                  {JAVA_LETTER}{JAVA_LETTER_OR_DIGIT}*

NUM_LITERALS                {INT_LITERAL}|{FLOAT_LITERAL}|{BOOL_LITERAL}|{NULL_LITERAL}

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

"abstract"                      { return(ABSTRACT_KEYWORD); }
"continue"                      { return(CONTINUE_KEYWORD); }
"for"                   { return(FOR_KEYWORD); }
"new"                   { return(NEW_KEYWORD); }
"switch"                        { return(SWITCH_KEYWORD); }
"assert"                        { return(ASSERT_KEYWORD); }
"default"                       { return(DEFAULT_KEYWORD); }
"if"                    { return(IF_KEYWORD); }
"package"                       { return(PACKAGE_KEYWORD); }
"synchronized"                  { return(SYNCHRONIZED_KEYWORD); }
"boolean"                       { return(BOOLEAN_KEYWORD); }
"do"                    { return(DO_KEYWORD); }
"goto"                  { return(GOTO_KEYWORD); }
"private"                       { return(PRIVATE_KEYWORD); }
"this"                  { return(THIS_KEYWORD); }
"break"                 { return(BREAK_KEYWORD); }
"double"                        { return(DOUBLE_KEYWORD); }
"implements"                    { return(IMPLEMENTS_KEYWORD); }
"protected"                     { return(PROTECTED_KEYWORD); }
"throw"                 { return(THROW_KEYWORD); }
"byte"                  { return(BYTE_KEYWORD); }
"else"                  { return(ELSE_KEYWORD); }
"import"                        { return(IMPORT_KEYWORD); }
"public"                        { return(PUBLIC_KEYWORD); }
"throws"                        { return(THROWS_KEYWORD); }
"case"                  { return(CASE_KEYWORD); }
"enum"                  { return(ENUM_KEYWORD); }
"instanceof"                    { return(INSTANCEOF_KEYWORD); }
"return"                        { return(RETURN_KEYWORD); }
"transient"                     { return(TRANSIENT_KEYWORD); }
"catch"                 { return(CATCH_KEYWORD); }
"extends"                       { return(EXTENDS_KEYWORD); }
"int"                   { return(INT_KEYWORD); }
"short"                 { return(SHORT_KEYWORD); }
"try"                   { return(TRY_KEYWORD); }
"char"                  { return(CHAR_KEYWORD); }
"final"                 { return(FINAL_KEYWORD); }
"interface"                     { return(INTERFACE_KEYWORD); }
"static"                        { return(STATIC_KEYWORD); }
"void"                  { return(VOID_KEYWORD); }
"class"                 { return(CLASS_KEYWORD); }
"finally"                       { return(FINALLY_KEYWORD); }
"long"                  { return(LONG_KEYWORD); }
"strictfp"                      { return(STRICTFP_KEYWORD); }
"volatile"                      { return(VOLATILE_KEYWORD); }
"const"                 { return(CONST_KEYWORD); }
"float"                 { return(FLOAT_KEYWORD); }
"native"                        { return(NATIVE_KEYWORD); }
"super"                 { return(SUPER_KEYWORD); }
"while"                 { return(WHILE_KEYWORD); }
"_"                     { return(__KEYWORD); }

"="                     { return('='); }
">"                     { return('>'); }
"<"                     { return('<'); }
"!"                     { return('!'); }
"~"                     { return('~'); }
"?"                     { return('?'); }
":"                     { return(':'); }
"->"                    { return(PTR_OP); }
"=="                    { return(EQ_OP); }
">="                    { return(GE_OP); }
"<="                    { return(LE_OP); }
"!="                    { return(NE_OP); }
"&&"                    { return(AND_OP); }
"||"                    { return(OR_OP); }
"++"                    { return(INC_OP); }
"--"                    { return(DEC_OP); }
"+"                     { return('+'); }
"-"                     { return('-'); }
"*"                     { return('*'); }
"/"                     { return('/'); }
"&"                     { return('&'); }
"|"                     { return('|'); }
"^"                     { return('^'); }
"%"                     { return('%'); }
"<<"                    { return(LEFT_OP); }
">>"                    { return(RIGHT_OP); }
">>>"                   { return(BIT_RIGHT_SHFT_OP); }
"+="                    { return(ADD_ASSIGN); }
"-="                    { return(SUB_ASSIGN); }
"*="                    { return(MUL_ASSIGN); }
"/="                    { return(DIV_ASSIGN); }
"&="                    { return(AND_ASSIGN); }
"|="                    { return(OR_ASSIGN); }
"^="                    { return(XOR_ASSIGN); }
"%="                    { return(MOD_ASSIGN); }
"<<="                   { return(LEFT_ASSIGN); }
">>="                   { return(RIGHT_ASSIGN); }
">>>="                  { return(BIT_RIGHT_SHFT_ASSIGN); }
","                     { return(','); }
"."                     { return('.'); }
";"                     { return(';'); }
"("                     { return('('); }
")"                     { return(')'); }
"["                     { return('['); }
"]"                     { return(']'); }
"..."                   { return(ELLIPSIS); }
"{"                     { return('{'); }
"}"                     { return('}'); }
"@"                     { return('@'); }
"::"                    { return(DOUBLE_COLON); }

"/*"                        {BEGIN(comment);}
<comment>[^*\n]+            {}
<comment>"*"+[^*/\n]*       {}
<comment>\n                 {}
<comment>"*"+"/"            {BEGIN(INITIAL);}

"//"[^\n]*                  {}

\'                          {BEGIN(chars);}
<chars>{LINE_TERMINATOR}    {showError("", MULTI_LINE_ERROR); return(0);}
<chars>[^'\\]'              {char* temp = strdup(yytext); temp[1]=temp[0]; temp[0]='\''; temp[2]='\''; BEGIN(INITIAL);}
<chars>{ESCAPE_SEQUENCE}'   {char* temp = strdup(yytext); temp[0]='\''; temp[1]=*convertExcapeChar(temp[1]); temp[2]='\'';  BEGIN(INITIAL); return LITERALS;}

\"                          {BEGIN(str); char* temp = strdup(yytext); initBuffer(temp);}
<str>{LINE_TERMINATOR}      {showError("", MULTI_LINE_ERROR); return(0);}
<str>[^"\\]                 {char* temp = strdup(yytext); pushBuffer(temp);}
<str>{ESCAPE_SEQUENCE}      {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}
<str>\"                     {BEGIN(INITIAL); char* temp = strdup(yytext); endBuffer(temp); return LITERALS;}

["]["]["]                                   {BEGIN(text_block); char* temp = strdup(yytext); initBuffer(temp);}
<text_block>["]["]["]{BLANK_SPACE}*         {}
<text_block>{LINE_TERMINATOR}               {char* temp = strdup(yytext); pushBuffer(temp); BEGIN(text_block_chars);}
<text_block_chars>{ESCAPE_SEQUENCE}         {char* temp = strdup(yytext); pushBuffer(convertExcapeChar(temp[1]));}                   
<text_block_chars>[^\\]                     {char* temp = strdup(yytext); pushBuffer(temp);}
<text_block_chars>[\\]?{LINE_TERMINATOR}    {char* temp = strdup(yytext); temp[0] = temp[1]; temp[1]='\0'; pushBuffer(temp);}
<text_block_chars>[\\][^\n\r]               {char* temp = strdup(yytext); showError(temp, BADEXCAPESEQ); return(0);}
<text_block_chars>["]["]["]                 {BEGIN(INITIAL); char* temp = strdup(yytext); endBuffer(temp); return LITERALS;}

{NUM_LITERALS}              {ECHO; return LITERALS;}
{PRIMITIVE_TYPE_KEYWORD}    {ECHO; return PRIMITIVE_TYPE_KEYWORDS;}
{IDENTIFIER}                {printf("ident"); ECHO; return IDENTIFIERS;}

{BLANK_SPACE}+              {}
{LINE_TERMINATOR}           {}

<str,chars,comment,text_block,text_block_chars><<EOF>>  {char* temp = convertCurrState(YYSTATE); showError(temp, EOF_ERROR);}
<str,chars,text_block,text_block_chars,INITIAL>.        {char* temp = strdup(yytext); showError(temp, LEXICAL_ERROR);}

%%

int yywrap(){
    return(1);
}

/*int main(){
    while(1) yylex();
    return 0;
}*/