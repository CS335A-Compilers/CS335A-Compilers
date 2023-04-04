#include "bits/stdc++.h"
#include "inc/helper.h"

using namespace std;

string string_buffer;

void init(){
    string_buffer = "";
}

void showError(string temp, enum ErrorKind errorCode){
    // printf("Error at line num: %d\nError: %s\n", yylineno, LexicalErrors[errorCode]);
    switch (errorCode){
        case BADEXCAPESEQ:
            cout<<"Bad escape sequence: "<<temp<<endl;
            break;
        case ILLEGALCHAR:
            cout<<"Illegal Character: "<<temp<<endl;
            break;
        case LEXICAL_ERROR:
            cout<<"Bad Lexical Sequence starts from: "<<temp<<endl;
            break;
        case EOF_ERROR:
            cout<<"Unbalanced %s present. "<<temp<<endl;
            break;
        default:
            cout<<"Error:  "<<LexicalErrors[errorCode]<<endl;
            break;
    }
    return ;
}

void pushBuffer(char* temp){
    string_buffer += *temp;
    return ;
}

void initBuffer(char* temp){
    string_buffer = "";
    return ;
}

void endBuffer(char* temp){
    // pushBuffer(temp);
    return ;
}

/*Cant think of any other way to implement this :( */ 
char* convertExcapeChar(char x){
    char* res;
    if(x=='n') *res = '\n';
    else if(x=='f') *res = '\f';
    else if(x=='r') *res = '\r';
    else if(x=='t') *res = '\t';
    else if(x=='b') *res = '\b';
    else if(x=='\\') *res = '\\';
    else if(x=='\'') *res = '\'';
    else if(x=='\"') *res = '\"';
    else {
        string err = "";
        err += x;
        showError(err, BADEXCAPESEQ);
    }
    return res;
}

string convertCurrState(int state){
    string res;
    printf("%d\n", state);
    if(state == 1) res = "comment";
    else if(state == 2) res = "string";
    else if(state == 3) res = "char";
    else if(state == 4 || state == 5) res = "text block";
    return res; 
}

void printHelpCommand(){
    printf("=====================================================================\n");
    printf(" \t \t \t  AST GENERATOR \n");
    printf("=====================================================================\n");
    printf("\nASTGenerator is a combined scanner and parser for the JAVA 17 language, \nwhich generates an abstract syntax tree (AST) for any given input java file.\n\n");
    printf("It takes a java file as an input, extracts the tokens from it \nand generates a dot file containing the abstract syntax tree for the input file.\n\n");
    printf("----------------------------\n");
    printf(" \t  SCANNER \n");
    printf("----------------------------\n");
    printf("The JAVA 17 Lexer (Scanner) analyzes the content of the input file and \nextracts the tokens and lexemes out of it.\n\n");
    printf("The lexical structure given in \n\t\t'https://docs.oracle.com/javase/specs/jls/se17/html/jls-3.html' \nis followed to create the lexer ...\n\n");
    printf("Taking an example -\n");
    printf("\tclass Test {\n\t    int i = 5 + 5;\n\t}\n\n");
    printf("This generates the following tokens and lexemes -\n");
    printf("--------------------------------\n");
    printf("  Lexeme  |   Token   |  Count  \n");
    printf("--------------------------------\n");
    printf("   class  |  keyword  |    1    \n");
    printf("   Test   | identifier|    1    \n");
    printf("     {    | separator |    1    \n");
    printf("    int   |  keyword  |    1    \n");
    printf("     i    | identifier|    1    \n");
    printf("     =    |  operator |    1    \n");
    printf("     5    |  literal  |    2    \n");
    printf("     +    |  operator |    1    \n");
    printf("     ;    | separator |    1    \n");
    printf("     }    | separator |    1    \n\n\n");
    printf("----------------------------\n");
    printf(" \t  PARSER \n");
    printf("----------------------------\n");
    printf("The JAVA 17 parser uses the automated parser generator - Bison.\nIt uses the grammar given in -\n\t\thttps://docs.oracle.com/javase/specs/jls/se17/html/jls-19.html\n\n");
    printf("The following language features are supported -\n");
    printf("   - Primitive Data Types\n");
    printf("   - Multidimensional arrays\n");
    printf("   - Basic Operators\n\t- Arithmetic Operators\n\t- Pre-increment, Pre-decrement, Post-increment and Post-decrement\n\t- Relational Operators\n\t- Bitwise Operators\n\t- Logical Operators\n\t- Assignment Operators\n\t- Ternary Operators\n");
    printf("   - Control Flow\n\t- If-else\n\t- For\n\t- While\n\t- Do-while\n\t- Switch\n");
    printf("   - Methods and method calls\n");
    printf("   - Classes and Objects\n");
    printf("   - Import statements\n");
    printf("   - Strings\n");
    printf("   - Interfaces\n");
    printf("   - Type Casting\n");
    printf("   - Enums and Records\n");
    printf("   - Constructors\n");
    printf("   - Blocks, Statements, and Patterns\n\n");
    printf("For the same example, the following nodes and edges will be generated ...\n");
    printf("           top_level_class_or_interface_declaration\n");
    printf("                              |\n");
    printf("                              |\n");
    printf("                  normal_class_declaration\n");
    printf("                              /|\\\n");
    printf("                             / | \\\n");
    printf("                            /  |  \\\n");
    printf("                        class test class_body\n");
    printf("                                        /|\\\n");
    printf("                                       / | \\\n");
    printf("                                      /  |  \\\n");
    printf("                                     /   |   \\\n");
    printf("                                    /    |    \\\n");
    printf("                                   /     |     \\\n");
    printf("                                  /      |      \\\n");
    printf("                                {   declaration   }\n");
    printf("                                         |\n");
    printf("                                         |\n");
    printf("                                 field_declaration\n");
    printf("                                         /\\\n");
    printf("                                        /  \\\n");
    printf("                                       /    \\\n");
    printf("                                     int  variable_declarator\n");
    printf("                                                    /\\\n");
    printf("                                                   /  \\\n");
    printf("                                                  /    \\\n");
    printf("                                                id    equals_variable_initializer\n");
    printf("                                                |              /\\\n");
    printf("                                                |             /  \\\n");
    printf("                                                i            = additive_expr\n");
    printf("                                                                   /|\\\n");
    printf("                                                                  / | \\\n");
    printf("                                                                 5  +  5\n");
    printf("\nUsage: ./ASTGenerator [--input=<input_file_name> --output=<output_file_name>][--verbose][--help]\n");
    printf("\nOptions:\n");
    printf("    --help : Describe the AST Generator\n");
    printf("    --input : Gets the input file\n");
    printf("    --output : The name of the output file\n");
    printf("    --verbose : Print logs of the code\n");
    return ;
}