%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "q4.tab.h"
%}

DIGIT		        [0-9]
LETTER              [A-Za-z]
NON_ZERO_DIGIT      [1-9]
INTEGERS	        {DIGIT}|{NON_ZERO_DIGIT}{DIGIT}+
FLOATS              {DIGIT}+[.]{DIGIT}+
TITLE_LITERAL       "Title"
CHAPTER_LITERAL     "Chapter"
SECTION_LITERAL     "Section"
CHAPTERS            {CHAPTER_LITERAL}{WHITESPACES}*{INTEGERS}{WHITESPACES}*{KEYWORDS_SEPERATORS}{WHITESPACES}*[^\n]*
SECTIONS            {SECTION_LITERAL}{WHITESPACES}*{FLOATS}{WHITESPACES}*{KEYWORDS_SEPERATORS}{WHITESPACES}*[^\n]*
TITLES              {TITLE_LITERAL}{WHITESPACES}*{KEYWORDS_SEPERATORS}{WHITESPACES}*[^\n]*
KEYWORDS            {TITLE}|{CHAPTER}|{SECTION}
SENTENCE_SEPERATORS "."|"!"|"?"
KEYWORDS_SEPERATORS ":"
WORD_SEPERATORS     ","|";"
WORDS               {LETTER}+
WHITESPACES         [ \t\f]
NEWLINES            [\n\r]

%%

{INTEGERS}              {yylval.string = strdup(yytext); return INTEGER;}
{FLOATS}                {yylval.string = strdup(yytext); return FLOAT;}
{SENTENCE_SEPERATORS}	{yylval.string = strdup(yytext); return SENTENCE_END;}
{CHAPTERS}              {printf("%s\n", yytext); yylval.string = strdup(yytext); return CHAPTER;}
{SECTIONS}              {printf("\t%s\n", yytext); yylval.string = strdup(yytext); return SECTION;}
{TITLES}                {printf("%s\nTable of Contents:\n", yytext); yylval.string = strdup(yytext); return TITLE;}
{KEYWORDS_SEPERATORS}   {yylval.string = strdup(yytext); return KEYWORDS_SEPERATOR;}
{WORDS}                 {yylval.string = strdup(yytext); return WORD;}
{WORD_SEPERATORS}       {yylval.string = strdup(yytext); return WORD_SEPERATOR;}
{WHITESPACES}+          {yylval.string = strdup(yytext); return SPACE;}
{NEWLINES}              {yylval.string = strdup(yytext); return NEWLINE;}


.                       {}

%%

int yywrap(){
    return(1);
}
