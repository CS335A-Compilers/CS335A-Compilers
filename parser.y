%{
    #include "header.h"
    int yylex(void);
    void yyerror(char const*);
    extern int yylineno;
%}

%locations

%union{
    int integer;
    float floating;
    char* string;
    char character;
}

%token KEYWORDS  IDENTIFIERS  SEPARATORS  OPERATORS  LITERALS  PRIMITIVE_TYPE_KEYWORDS  SWITCH_KEYWORDS  CASE_KEYWORDS  DEFAULT_KEYWORDS  ASSIGNMENT_OPERATORS OPEN_BRCKT CLOSE_BRCKT


%%

primary
            :   primary_no_new_array
            |   error
//            |   array_creation_expression

primary_no_new_array
            :   LITERALS
            |   OPEN_BRCKT expression CLOSE_BRCKT

expression
            :   assignment_expression
            |   IDENTIFIERS
//            |   lambda_expression

assignment_expression
            :   condtional_expression
            |   assignment

condtional_expression
            :   conditional_or_expression
            |   conditional_or_expression '?' expression ':' condtional_expression
//            |   conditional_or_expression '?' expression ':' lambda_expression

conditional_or_expression
            :   conditional_and_expression
            |   conditional_or_expression '|' '|' conditional_and_expression

conditional_and_expression
            :   inclusive_or_expression
            |   conditional_and_expression '&' '&' inclusive_or_expression

inclusive_or_expression
            :   exclusive_or_expression
            |   inclusive_or_expression '|' exclusive_or_expression

exclusive_or_expression
            :   and_expression
            |   exclusive_or_expression '^' and_expression

and_expression
            :   equality_expression
            |   and_expression '&' equality_expression

equality_expression
            :   relational_expression
            |   equality_expression '=' '=' relational_expression
            |   equality_expression '!' '=' relational_expression

relational_expression
            :   shift_expression
            |   relational_expression '<' shift_expression
            |   relational_expression '>' shift_expression
            |   relational_expression '<' '=' shift_expression
            |   relational_expression '>' '=' shift_expression
//            |   instance_of_expression

shift_expression
            :   additive_expression
            |   shift_expression '<' '<' additive_expression
            |   shift_expression '>' '>' additive_expression
            |   shift_expression '>' '>' '>' additive_expression

additive_expression
            :   multiplicative_expression
            |   additive_expression '+' multiplicative_expression
            |   additive_expression '-' multiplicative_expression

multiplicative_expression
            :   unary_expression
            |   multiplicative_expression '*' unary_expression
            |   multiplicative_expression '&' unary_expression
            |   multiplicative_expression '/' unary_expression

unary_expression
            :   pre_increment_expression
            |   pre_decrement_expression
            |   '+' unary_expression
            |   '-' unary_expression
            |   unary_expression_not_plus_minus

pre_increment_expression
            :   '+' '+' unary_expression

pre_decrement_expression
            :   '-' '-' unary_expression

unary_expression_not_plus_minus
            :   postfix_expression
            |   '~' unary_expression
            |   '!' unary_expression
            |   cast_expression
//            |   switch_expression

postfix_expression
            :   primary
            |   expression_name
            |   post_increment_expression
            |   post_decrement_expression

expression_name
            :   IDENTIFIERS
            |   ambigous_name '.' IDENTIFIERS

ambigous_name
            :   IDENTIFIERS
            |   ambigous_name '.' IDENTIFIERS

post_increment_expression
            :   postfix_expression '+' '+'

post_decrement_expression
            :   postfix_expression '-' '-'

cast_expression
            :   '(' PRIMITIVE_TYPE_KEYWORDS ')' unary_expression

assignment
            :   left_hand_side ASSIGNMENT_OPERATORS expression

left_hand_side
            :   expression_name
//            |   array_access
//            |   field_access


%%

int main(){
    yyparse();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s. Line number %d\n\n", s, yylineno);
}