%{
    int numChars = 0, numWords = 0, numLines = 0;
%}

%%
\n {numLines++; numChars++;}
"Sannnnnnn" {numWords++; numChars += yyleng; printf("Detected San");}
. {numChars++;}
[^ \n]+ {numWords++; numChars += yyleng;} 
%%

int main() {
    yylex();
    printf("%d\t%d\t%d\n", numChars, numWords, numLines);
}

int yywrap(){return(1);}