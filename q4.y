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

%type   <string>    Sentence Sentence_body Maybe_space Paragraph Paragraph_body Keyword

%%

Start:
    |   Start NEWLINE
    |   Start Keyword
    |   Start Paragraph

Sentence:           Sentence_body SENTENCE_END              {}
Sentence_body:                                              {}
                |   Sentence_elements Sentence_body         {}
                |   WORD WORD_SEPERATOR Sentence_body       {}
Sentence_elements:  INTEGER | FLOAT | SPACE                 {}
                |   WORD                                    {word_count++;}

Maybe_space:                                                {}
                |   SPACE

Keyword:            TITLE               {}
                |   CHAPTER             {chapter_count++;}
                |   SECTION             {section_count++;}

Paragraph:          Paragraph_body Maybe_space NEWLINE      {}
Paragraph_body:     Sentence                                {}
                |   Sentence Maybe_space Sentence                 {}
                |   Paragraph_body Maybe_space Paragraph_body     {}

%%

int main(){
    printf("\n");
    yyparse();
    printf("\nNumber of Chapters: %d\n", chapter_count);
    printf("Number of Sections: %d\n", section_count);
    printf("Number of words in paragraphs: %d\n", word_count);
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s at line number %d\n", s, yylineno);
}
