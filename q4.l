%{
    #include "helper.h"

%}

DIGIT		        [0-9]
LETTER              [A-Za-z]
NON_ZERO_DIGIT      [1-9]
INTEGERS	        {DIGIT}|{NON_ZERO_DIGIT}{DIGIT}+
FLOATS              {DIGIT}+[.]{DIGIT}+
TITLE               "Title"
CHAPTER             "Chapter"
SECTION             "Section"
KEYWORDS            {TITLE}|{CHAPTER}|{SECTION}
SENTENCE_SEPERATORS "."|"!"|"?"           
WORD_SEPERATORS     ","|";"
WORDS               {LETTER}+
WHITESPACES         [ \t\f]


%%

{INTEGERS}|{FLOATS}     {return NUMBER;}
{SENTENCE_SEPERATORS}	{yylval.string = strdup(yytext); return SENTENCE_END;}
{KEYWORDS}              {return KEYWORD;}
{WORDS}                 {yylval.string = strdup(yytext); return WORD;}
{WORD_SEPERATORS}       {yylval.string = strdup(yytext); return WORD_SEPERATOR;}

.                       {}

%%

int yywrap(){
    return(1);
}
