%{
    #include "helper.h"
    int yylex(void);
    void yyerror(char const*);
    extern int yylineno;

%}

%locations

%union{
    int integer;
    float floating;
    char* string;
}

%start  Start

%token  <string>    WORD INTEGER FLOAT SENTENCE_END NEWLINE WORD_SEPERATOR KEYWORDS_SEPERATOR KEYWORD SPACE CHAPTER TITLE SECTION ENDOFFILELINE

%type   <string>    Sentence Sentence_body Maybe_space Maybe_newline Paragraph Paragraph_body Keyword Paragraph_initial Paragraph_optional Paragraph_optional1

%%

Start:
    |   Start NEWLINE
    |   Start Keyword
    |   Start Paragraph
    |   Start error                                         {}

Sentence:           Sentence_body SENTENCE_END              {countSentence($2);}
Sentence_body:                                              {}
                |   Sentence_elements Sentence_body         {}
Sentence_elements:  INTEGER | FLOAT | SPACE | WORD_SEPERATOR {/*Assumed that there may be space between word seperators and words*/}
                |   WORD                                    {word_count++;}

Maybe_space:                                                {}
                |   SPACE

Maybe_newline:                                              {}
                |   NEWLINE Maybe_newline                   {}

Keyword:            TITLE               {}
                |   CHAPTER             {chapter_count++; chapterEnds();}
                |   SECTION             {section_count++; sectionEnds();}

Paragraph:          Paragraph_initial NEWLINE NEWLINE Maybe_newline     {paragraphCount();}
                |   Paragraph_initial Maybe_newline ENDOFFILELINE Maybe_newline           {paragraphCount();}

Paragraph_initial:  Paragraph_body Maybe_space

Paragraph_body:     Sentence Paragraph_optional                                        {}

Paragraph_optional:                                                 {}
                |   Maybe_space Paragraph_optional1                            {}

Paragraph_optional1:    Sentence
                    |   Paragraph_body

%%

int main(){
    init();
    yyparse();
    printStatistics();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s Line number %d\n\n", s, yylineno);
}
