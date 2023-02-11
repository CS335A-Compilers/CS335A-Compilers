#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(char const*);

int word_count;
int section_count;
int chapter_count;

int declarative_count;
int exclamatory_count;
int interrogative_count;

int curr_num_of_section;
int num_of_paragraph_in_section;
int num_of_paragraph_in_chapter;
int justStartedChapter;
int justStartedSection;

void init(){
    printf("--------------------------------------------------------------\n");
    word_count = 0;
    section_count = 0;
    chapter_count = 0;
    num_of_paragraph_in_section = 0;
    num_of_paragraph_in_chapter = 0;
    justStartedSection = 1;
    justStartedChapter = 1;
    declarative_count = 0;
    exclamatory_count = 0;
    interrogative_count = 0;
    return ;
}

void paragraphCount(){
    num_of_paragraph_in_chapter++;
    num_of_paragraph_in_section++;
}

void sectionEnds(){
    if(justStartedSection == 1) {
        justStartedSection = 0;
        return ;
    }
    if(num_of_paragraph_in_section == 0) {
        yyerror("A section consists of one or more paragraphs.");
    }
    else num_of_paragraph_in_section = 0;
    return ;
}

void chapterEnds(){
    if(justStartedChapter == 1) {
        justStartedChapter = 0;
        return ;
    }
    if(num_of_paragraph_in_chapter == 0) {
        yyerror("A chapter consists of one or more paragraphs.");
    }
    else num_of_paragraph_in_chapter = 0;
    justStartedSection = 1;
    return ;
}

void countSentence(char* chr){
    if(chr[0] == '.') declarative_count++;
    else if(chr[0] == '!') exclamatory_count++;
    else if(chr[0] == '?') interrogative_count++;
    else yyerror("Something went wrong");
    return ;
}

void printStatistics(){
    if(chapter_count == 0) yyerror("A dissertation consists of one or more chapters.\n");
    printf("--------------------------------------------------------------\n");
    printf("\n--------------------------Statistics--------------------------\n");
    printf("Number of Chapters: %d\n", chapter_count);
    printf("Number of Sections: %d\n", section_count);
    printf("Number of words in paragraphs: %d\n", word_count);
    printf("Number of Declarative sentences in the dissertation: %d\n", declarative_count);
    printf("Number of Interrogative sentences in the dissertation: %d\n", interrogative_count);
    printf("Number of Exclamatory sentences in the dissertation: %d\n", exclamatory_count);
    printf("--------------------------------------------------------------\n");
    return ;
}