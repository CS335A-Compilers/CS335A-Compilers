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


%token ABSTRACT_KEYWORD CONTINUE_KEYWORD FOR_KEYWORD NEW_KEYWORD SWITCH_KEYWORD ASSERT_KEYWORD DEFAULT_KEYWORD IF_KEYWORD PACKAGE_KEYWORD SYNCHRONIZED_KEYWORD BOOLEAN_KEYWORD DO_KEYWORD GOTO_KEYWORD PRIVATE_KEYWORD THIS_KEYWORD BREAK_KEYWORD DOUBLE_KEYWORD IMPLEMENTS_KEYWORD PROTECTED_KEYWORD THROW_KEYWORD BYTE_KEYWORD ELSE_KEYWORD IMPORT_KEYWORD PUBLIC_KEYWORD THROWS_KEYWORD CASE_KEYWORD ENUM_KEYWORD INSTANCEOF_KEYWORD RETURN_KEYWORD TRANSIENT_KEYWORD CATCH_KEYWORD EXTENDS_KEYWORD INT_KEYWORD SHORT_KEYWORD TRY_KEYWORD CHAR_KEYWORD FINAL_KEYWORD INTERFACE_KEYWORD STATIC_KEYWORD VOID_KEYWORD CLASS_KEYWORD FINALLY_KEYWORD LONG_KEYWORD STRICTFP_KEYWORD VOLATILE_KEYWORD CONST_KEYWORD FLOAT_KEYWORD NATIVE_KEYWORD SUPER_KEYWORD WHILE_KEYWORD __KEYWORD  
%token IDENTIFIERS  LITERALS  PTR_OP EQ_OP GE_OP  LE_OP  NE_OP  AND_OP  OR_OP  INC_OP  DEC_OP  LEFT_OP  RIGHT_OP  BIT_RIGHT_SHFT_OP ADD_ASSIGN  SUB_ASSIGN  MUL_ASSIGN  DIV_ASSIGN  AND_ASSIGN  OR_ASSIGN  XOR_ASSIGN  MOD_ASSIGN  LEFT_ASSIGN  RIGHT_ASSIGN  BIT_RIGHT_SHFT_ASSIGN  ELLIPSIS  DOUBLE_COLON

%token EMPTY_ARRAY

%%

primary
            :   primary_no_new_array
            |   array_creation_expression

primary_no_new_array
            :   LITERALS
            |   '(' expression ')'

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
            |   conditional_or_expression OR_OP conditional_and_expression

conditional_and_expression
            :   inclusive_or_expression
            |   conditional_and_expression AND_OP inclusive_or_expression

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
            |   equality_expression EQ_OP relational_expression
            |   equality_expression NE_OP relational_expression

relational_expression
            :   shift_expression
            |   relational_expression '<' shift_expression
            |   relational_expression '>' shift_expression
            |   relational_expression LE_OP shift_expression
            |   relational_expression GE_OP shift_expression
//            |   instance_of_expression

shift_expression
            :   additive_expression
            |   shift_expression LEFT_OP additive_expression
            |   shift_expression RIGHT_OP additive_expression
            |   shift_expression BIT_RIGHT_SHFT_OP additive_expression

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
            :   INC_OP unary_expression

pre_decrement_expression
            :   DEC_OP unary_expression

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
            :   postfix_expression INC_OP

post_decrement_expression
            :   postfix_expression DEC_OP

cast_expression
            :   '(' primitive_type ')' unary_expression

assignment
            :   left_hand_side ASSIGNMENT_OPERATORS expression

ASSIGNMENT_OPERATORS 
            :  '='
            |  ADD_ASSIGN  
            |  SUB_ASSIGN  
            |  MUL_ASSIGN  
            |  DIV_ASSIGN
            |  AND_ASSIGN
            |  OR_ASSIGN
            |  XOR_ASSIGN
            |  MOD_ASSIGN
            |  LEFT_ASSIGN
            |  RIGHT_ASSIGN 
            | BIT_RIGHT_SHFT_ASSIGN

left_hand_side
            :   expression_name
//            |   array_access
//            |   field_access

array_creation_expression
            :   NEW_KEYWORD primitive_type dim_exprs dims_zero_or_one
            |   NEW_KEYWORD primitive_type dims array_initializer
//            |   NEW_KEYWORD class_or_interface_type dim_exprs dims_zero_or_more               {/* VARTIKA DOING class_or_interface_type */}
//            |   NEW_KEYWORD class_or_interface_type dims array_initializer                    {/* VARTIKA DOING class_or_interface_type */}

dims_zero_or_one
            :
            |   dims

dim_exprs
            :   dim_expr
            |   dim_expr dim_exprs

dim_expr    
            :  '[' expression ']'

dims 
            :  EMPTY_ARRAY                                                                      {/*  Rule not working :( */}
            |  EMPTY_ARRAY dims

primitive_type
            :   BYTE_KEYWORD
            |   SHORT_KEYWORD
            |   INT_KEYWORD
            |   LONG_KEYWORD
            |   CHAR_KEYWORD
            |   FLOAT_KEYWORD
            |   DOUBLE_KEYWORD
            |   BOOLEAN_KEYWORD

array_initializer
            :   '{' variable_initializer_list_zero_or_more zero_or_more_commas '}' 

variable_initializer_list_zero_or_more
            :   
            |   variable_initializer_list

zero_or_more_commas
            :  
            |   ','

variable_initializer_list
            :   variable_initializer 
            |   variable_initializer ',' variable_initializer_list

variable_initializer
            :   expression
            |   array_initializer


%%

int main(){
    yyparse();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s. Line number %d\n\n", s, yylineno);
}