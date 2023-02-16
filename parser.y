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
%token EXPORTS_KEYWORD OPENS_KEYWORD REQUIRES_KEYWORD USES_KEYWORD MODULE_KEYWORD PERMITS_KEYWORD SEALED_KEYWORD VAR_KEYWORD NONSEALED_KEYWORD PROVIDES_KEYWORD TO_KEYWORD WITH_KEYWORD OPEN_KEYWORD RECORD_KEYWORD TRANSITIVE_KEYWORD YIELD_KEYWORD
%token IDENTIFIERS  LITERALS  PTR_OP EQ_OP GE_OP  LE_OP  NE_OP  AND_OP  OR_OP  INC_OP  DEC_OP  LEFT_OP  RIGHT_OP  BIT_RIGHT_SHFT_OP ADD_ASSIGN  SUB_ASSIGN  MUL_ASSIGN  DIV_ASSIGN  AND_ASSIGN  OR_ASSIGN  XOR_ASSIGN  MOD_ASSIGN  LEFT_ASSIGN  RIGHT_ASSIGN  BIT_RIGHT_SHFT_ASSIGN  ELLIPSIS  DOUBLE_COLON

%token EMPTY_ARRAY

%%
//  ########   EXPRESSIONS   ########  

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
            |   variable_initializer_list variable_initializer_list_zero_or_more

zero_or_more_commas
            :  
            |   ',' zero_or_more_commas

variable_initializer_list
            :   variable_initializer 
            |   variable_initializer ',' variable_initializer_list

variable_initializer
            :   expression
            |   array_initializer

//vartika-Productions from §9 (Interfaces)

InterfaceDeclaration
            :   normal_interface_declaration
            |   annotation_interface_declaration 

normal_interface_declaration
            :   interface_modifier_zero_or_more INTERFACE_KEYWORD type_identifier type_parameters_zero_or_one interface_extends_zero_or_one interface_permits_zero_or_one interface_body
type_identifier
            : IDENTIFIERS //but not permits, record, sealed, var, or yield ...need to edit

interface_modifier_zero_or_more
            :  
            |   interface_modifier interface_modifier_zero_or_more

type_parameters_zero_or_one
            :
            | type_parameters //shreyasi

type_parameter
            :type_parameter_modifier_zero_or_more type_identifier type_bound_zero_or_one

type_parameter_modifier_zero_or_more
            :
            | type_parameter_modifier type_parameter_modifier_zero_or_more

type_parameter_modifier
            : annotation //defined by Shreyasi

type_bound_zero_or_one
            :
            | type_bound 
type_bound
        : EXTENDS_KEYWORD type_variable
        | EXTENDS_KEYWORD class_or_interface_type additional_bound_zero_or_more

type_variable
        : annotation_zero_or_more type_identifier

annotation_zero_or_more
        : 
        | annotation annotation_zero_or_more

additional_bound_zero_or_more
        :
        | additional_bound additional_bound_zero_or_more

additional_bound
        : '&' interface_type

interface_type
        : class_type

class_type
        : annotation_zero_or_more type_identifier type_arguments_zero_or_one
        | package_name '.' annotation_zero_or_more type_identifier type_arguments_zero_or_one
        | class_or_interface_type '.' annotation_zero_or_more type_identifier type_arguments_zero_or_one

package_name
        : IDENTIFIERS
        | package_name '.' IDENTIFIERS

type_arguments_zero_or_one
                        :
                        | type_arguments

type_arguments
            :'<' type_argument_list '>'

type_argument_list
            : type_argument comma_type_arguement_zero_or_more

comma_type_arguement_zero_or_more
                                 : 
                                 | ',' type_argument comma_type_arguement_zero_or_more
type_argument
          : reference_type
          | wild_card

wild_card
      : annotation_zero_or_more '?' wild_card_bounds_zero_or_one

wild_card_bounds_zero_or_one
                        :
                        | wild_card_bounds
    
wild_card_bounds
            : EXTENDS_KEYWORD reference_type
            | SUPER_KEYWORD reference_type

reference_type
            : class_or_interface_type
            |type_variable
            | array_type
array_type
        : primitive_type dims
        | class_or_interface_type dims
        | type_variable dims
interface_extends_zero_or_one
            :
            | interface_extends

interface_permits_zero_or_one
            :
            | interface_permits

interface_modifier
            :'(' OR_OP ')'
            | annotation PUBLIC_KEYWORD PROTECTED_KEYWORD PRIVATE_KEYWORD
            | ABSTRACT_KEYWORD STATIC_KEYWORD SEALED_KEYWORD NONSEALED_KEYWORD STRICTFP_KEYWORD

interface_extends
            :
            | EXTENDS_KEYWORD interface_type_list //shreyasi

interface_permits
            : PERMITS_KEYWORD type_name comma_type_name_zero_or_more //type_name : deepak

comma_type_name_zero_or_more
            :
            | ',' type_name comma_type_name_zero_or_more

interface_body
        : '{' interface_member_decleration_zero_or_more '}'

interface_member_decleration_zero_or_more
                                    :
                                    | interface_member_decleration interface_member_decleration_zero_or_more

interface_member_decleration
                        : constant_declaration
                        | interface_method_declaration
                        | class_declaration //shreyasi
                        | interface_declaration

constant_declaration
                : constant_modifier_zero_or_more unann_type variable_declarator_list //unann shreyasi

constant_modifier_zero_or_more
                            :
                            | constant_modifier constant_modifier_zero_or_more

constant_modifier
               :'(' OR_OP ')'
               | annotation PUBLIC_KEYWORD 
               |STATIC_KEYWORD FINAL_KEYWORD

interface_method_declaration
                        : interface_method_modifier_zero_or_more method_header method_body 

interface_method_modifier_zero_or_more
                                    :
                                    | interface_method_modifier interface_method_modifier_zero_or_more            

interface_method_modifier
                      : '(' OR_OP ')'
                      | annotation PUBLIC_KEYWORD PRIVATE_KEYWORD
                      | ABSTRACT_KEYWORD DEFAULT_KEYWORD STATIC_KEYWORD STRICTFP_KEYWORD

annotation_interface_declaration
                            : interface_modifier_zero_or_more '@' INTERFACE_KEYWORD type_identifier annotation_interface_body  

annotation_interface_body
                    :'{' annotation_interface_member_declaration '}'

annotation_interface_member_declaration
                                    : annotation_interface_element_declaration
                                    | constant_declaration
                                    | class_declaration
                                    | interface_declaration

annotation_interface_element_declaration
                                    : annotation_interface_element_modifier_zero_or_more Unann_type IDENTIFIERS '(' ')' dims_zero_or_one default_value_zero_or_one

annotation_interface_element_modifier_zero_or_more
                                            :
                                            | annotation_interface_element_modifier annotation_interface_element_modifier_zero_or_more
default_value_zero_or_one
                        :
                        | default_value  

annotation_interface_element_modifier
                                :'(' OR_OP ')'
                                | annotation PUBLIC_KEYWORD
                                | ABSTRACT_KEYWORD

default_value
          : DEFAULT_KEYWORD element_value   
                                         
//vartika-Productions from §9 (Interfaces)



//  ########   BLOCKS, STATEMENTS AND PATTERNS   ########  

block
        :   { [block_statements] }

block_statements
        :   block_statement {block_statement}

block_statement
        :   statement
        // |   local_variable_declaration_statement
//        |   local_class_or_interface_declaration

// local_class_or_interface_declaration
//         :   class_declaration
//         |   normal_interface_declaration

// local_variable_declaration_statement
//         :   local_variable_declaration ';'

// local_variable_declaration
//         :   {variable_modifier} local_variable_type variable_declarator_list

// local_variable_type
//         :   unann_type
//         |   VAR_KEYWORD

statement
        :   statement_without_trailing_substatement
        |   labeled_statement
        |   if_then_statement
        |   if_then_else_statement
        |   while_statement
        // |   for_statement

statement_no_short_if
        :   statement_without_trailing_substatement
        |   labeled_statement_no_short_if
        |   if_then_else_statement_no_short_if
        |   while_statement_no_short_if
        // |   for_statement_no_short_if

statement_without_trailing_substatement
        :   block
        |   empty_statement
        |   expression_statement
        |   assert_statement
        // |   switch_statement
        // |   do_statememt
        |   break_statement
        |   continue_statement
        |   return_statement
        |   synchronized_statement
        |   throw_statement
        // |   try_statement
        |   yield_statement

empty_statement
        : ';'   

labeled_statement
        : IDENTIFIERS ':' statement

labeled_statement_no_short_if
        : IDENTIFIERS ':' statement_no_short_if

expression_statement
        :  statement_expression ';'

statement_expression
        :  assignment
        |  pre_increment_expression
        |  pre_decrement_expression
        |  post_increment_expression
        |  post_decrement_expression
        // |  method_invocation
        // |  class_instance_creation_expression

if_then_statement
        :  IF_KEYWORD '(' expression ')' statement

if_then_else_statement
        :  IF_KEYWORD  '(' expression ')' statement_no_short_if ELSE_KEYWORD statement

if_then_else_statement_no_short_if
        :  IF_KEYWORD  '(' expression ')' statement_no_short_if ELSE_KEYWORD statement_no_short_if

assert_statement
        :  ASSERT_KEYWORD expression ';'
        |  ASSERT_KEYWORD expression ':' expression ';'

while_statement
        :  WHILE_KEYWORD '(' expression ')' statement  


while_statement_no_short_if
        :  WHILE_KEYWORD '(' expression ')' statement_no_short_if

// for_statement
//         :  basic_for_statement
//         |  enhanced_for_statement

// for_statement_no_short_if
//         :  basic_for_statement_no_short_if
//         |  enhanced_for_statement_no_short_if

// basic_for_statement
//         :  FOR_KEYWORD '(' [for_init] ';' [expression] ';' [for_update] ')' statement

// basic_for_statement_no_short_if
//         :  FOR_KEYWORD '(' [for_init] ';' [expression] ';' [for_update] ')' statement_no_short_if

// for_init
//         :  statement_expression_list
//         |  local_variable_declaration

// for_update
//         :  statement_expression_list

// statement_expression_list
//         :  statement_expression {, statement_expression}

// enhanced_for_statement
//         :  FOR_KEYWORD '(' local_variable_declaration ':' expression ')' statement

// enhanced_for_statement_no_short_if
//         :  FOR_KEYWORD '(' local_variable_declaration ':' expression ')' statement_no_short_if

break_statement
        :  BREAK_KEYWORD [IDENTIFIERS] ';'

yield_statement
        :  YIELD_KEYWORD expression ';'

continue_statement
        :  CONTINUE_KEYWORD [IDENTIFIERS] ';'

return_statement
        :  RETURN_KEYWORD [expression] ';'

throw_statement
        :  THROW_KEYWORD expression ';'

synchronized_statement
        :  SYNCHRONIZED_KEYWORD '(' expression ')' block

// try_statement
//         :  TRY_KEYWORD block catches
//         |  TRY_KEYWORD block [catches] finally
//         |  try_with_resources_statement

// catches
//         :  catch_clause {catch_clause}

// catch_clause
//         : CATCH_KEYWORD '(' catch_formal_parameter ')' block

// catch_formal_parameter
//         : {variable_modifier} catch_type variable_declarator_id

// catch_type
//         : unann_class_type {| class_type}

// finally
//         : FINALLY_KEYWORD block

// try_with_resources_statement
//         :  TRY_KEYWORD resources_specification block [catches] [finally]

// resources_specification
//         :  '(' resource_list [;] ')'

// resource_list
//         :  resource {; resource}

// resource
//         :  local_variable_declaration
//         |  variable_access

// pattern 
//         :  type_pattern

// type_pattern 
//         : local_variable_declaration

%%

int main(){
    yyparse();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s. Line number %d\n\n", s, yylineno);
}