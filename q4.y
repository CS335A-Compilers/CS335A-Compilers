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

%token  <string>    WORD INTEGER FLOAT SENTENCE_END NEWLINE WORD_SEPERATOR KEYWORDS_SEPERATOR KEYWORD SPACE CHAPTER TITLE SECTION

%type   <string>    Sentence Sentence_body Maybe_space Paragraph Paragraph_body Keyword MaybeNewline

%%

Start:
    |   Start NEWLINE
    |   Start Keyword
    |   Start Paragraph

Sentence:           Sentence_body SENTENCE_END              {countSentence($2);}
Sentence_body:                                              {}
                |   Sentence_elements Sentence_body         {}
Sentence_elements:  INTEGER | FLOAT | SPACE | WORD_SEPERATOR {/*Assumed that there may be space between word seperators and words*/}
                |   WORD                                    {word_count++;}

Maybe_space:                                                {}
                |   SPACE
MaybeNewline:                                               {}
                |   NEWLINE

Keyword:            TITLE               {}
                |   CHAPTER             {chapter_count++; chapterEnds();}
                |   SECTION             {section_count++; sectionEnds();}

Paragraph:          Paragraph_body Maybe_space MaybeNewline      {paragraphCount();}
Paragraph_body:     Sentence                                {}
                |   Sentence Maybe_space Sentence                 {}
                |   Paragraph_body Maybe_space Paragraph_body     {}

%%

int main(){
    init();
    yyparse();
    printStatistics();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s at line number %d\n\n", s, yylineno);
}
