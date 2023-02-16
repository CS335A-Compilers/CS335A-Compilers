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

%token EMPTY_ARRAY DIAMOND

%%

//  ########   COMPILATION UNIT   ########  

compilation_unit
            :   ordinary_compilation_unit
            |   modular_compilation_unit

ordinary_compilation_unit
            :   package_declaration_zero_or_one import_declaration_zero_or_more top_level_class_or_interface_declaration_zero_or_more

package_declaration_zero_or_one
            :
            |   package_declaration

import_declaration_zero_or_more
            :   
            |   import_declaration import_declaration_zero_or_more

top_level_class_or_interface_declaration_zero_or_more
            :
            |   top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more

modular_compilation_unit
            :   
            |   import_declaration_zero_or_more module_declaration

package_declaration
            :   package_modifier_zero_or_more PACKAGE_KEYWORD IDENTIFIERS dot_identifier_zero_or_more ';'

dot_identifier_zero_or_more
            :
            |   '.' IDENTIFIERS dot_identifier_zero_or_more

package_modifier_zero_or_more
            :   
            |   package_modifier package_modifier_zero_or_more

package_modifier
            :   annotation

import_declaration
            :   single_type_import_declaration
            |   type_import_on_demand_declaration
            |   single_static_import_declaration
            |   static_import_on_demand_declaration

single_type_import_declaration
            :   IMPORT_KEYWORD type_name ';'

type_import_on_demand_declaration
            :   IMPORT_KEYWORD package_or_type_name '.' '*' ';'                         {/* may not work */}

single_static_import_declaration
            :   IMPORT_KEYWORD STATIC_KEYWORD type_name '.' IDENTIFIERS ';'

static_import_on_demand_declaration
            :   IMPORT_KEYWORD STATIC_KEYWORD type_name '.' '*' ';'

top_level_class_or_interface_declaration
            :   class_declaration
            |   interface_declaration
            |   ';'

module_declaration
            :   annotation_zero_or_more OPEN_zero_or_one MODULE_KEYWORD IDENTIFIERS dot_identifier_zero_or_more '{' module_directive '}'

OPEN_zero_or_one
            :
            |   OPEN_KEYWORD

module_directive
            :   REQUIRES_KEYWORD requires_modifier_zero_or_more module_name ';'
            |   EXPORTS_KEYWORD package_name ';'
            |   EXPORTS_KEYWORD package_name TO_KEYWORD module_name comma_module_name_zero_or_more ';'
            |   OPENS_KEYWORD package_name ';'
            |   OPENS_KEYWORD package_name TO_KEYWORD module_name comma_module_name_zero_or_more ';'
            |   USES_KEYWORD type_name ';'
            |   PROVIDES_KEYWORD type_name WITH_KEYWORD type_name comma_type_name_zero_or_more ';'

comma_type_name_zero_or_more
            :   
            |   ',' type_name comma_type_name_zero_or_more 

comma_module_name_zero_or_more
            :
            |   ',' module_name comma_module_name_zero_or_more

requires_modifier_zero_or_more
            :   
            |   requires_modifier requires_modifier_zero_or_more

requires_modifier
            :   TRANSIENT_KEYWORD
            |   STATIC_KEYWORD

module_name
            :   IDENTIFIERS
            |   module_name '.' IDENTIFIERS

//  ########   EXPRESSIONS   ########  

primary
            :   primary_no_new_array
            |   array_creation_expression

primary_no_new_array
            :   LITERALS
            |   class_literal
            |   THIS_KEYWORD
            |   type_name '.' THIS_KEYWORD
            |   '(' expression ')'
            |   class_instance_creation_expression
//            |   field_access
//            |   array_access
//            |   method_invocation
//            |   method_reference

expression
            :   assignment_expression
            |   IDENTIFIERS
            |   lambda_expression

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
            |   switch_expression

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

switch_expression
            :   SWITCH_KEYWORD '(' expression ')' switch_block

switch_block
            :   '{' switch_rule_zero_or_more switch_rule_zero_or_more '}'
            |   '{' switch_block_statement_group_zero_or_more switch_label_colon_zero_or_more '}'

switch_rule_zero_or_more
            :   
            |   switch_rule switch_rule_zero_or_more

 switch_block_statement_group_zero_or_more
            :   
            |   switch_block_statement_group switch_block_statement_group_zero_or_more

switch_label_colon_zero_or_more
            :
            |   switch_label ':' switch_label_colon_zero_or_more 

switch_rule
            :   switch_label PTR_OP expression ';'
            |   switch_label block
            |   switch_label throw_statement

switch_block_statement_group
            :   switch_label ':' switch_label_colon_zero_or_more block_statements

switch_label
            :   CASE_KEYWORD case_constant comma_case_constant_zero_or_more

comma_case_constant_zero_or_more
            :   
            |   ',' case_constant comma_case_constant_zero_or_more

case_constant
            :   condtional_expression

class_instance_creation_expression
            :   unqualified_class_instance_creation_expression
            |   expression_name '.' unqualified_class_instance_creation_expression
            |   primary '.' unqualified_class_instance_creation_expression

unqualified_class_instance_creation_expression
            :   NEW_KEYWORD type_arguments_zero_or_one class_or_interface_type_to_instantiate '(' argument_list_zero_or_one ')' class_body_zero_or_one

type_arguments_zero_or_one
            :   
            |   type_arguments

argument_list 
            :   expression comma_expression_zero_or_more

comma_expression_zero_or_more
            :   
            |   ',' expression comma_expression_zero_or_more
            

class_or_interface_type_to_instantiate
            :   annotation_zero_or_more IDENTIFIERS dot_annotation_identifier_zero_or_more type_arguments_or_diamond

type_arguments_or_diamond
            :
            |   type_arguments
            |   DIAMOND

dot_annotation_identifier_zero_or_more
            :
            |   '.' annotation_zero_or_more IDENTIFIERS dot_annotation_identifier_zero_or_more

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
//            |   NEW_KEYWORD class_or_interface_type dim_exprs dims_zero_or_more               {/* Someone DOING class_or_interface_type */}
//            |   NEW_KEYWORD class_or_interface_type dims array_initializer                    {/* Someone DOING class_or_interface_type */}

dims_zero_or_one
            :
            |   dims

dim_exprs
            :   dim_expr
            |   dim_expr dim_exprs

dim_expr    
            :  annotation_zero_or_more '[' expression ']'

dims 
            :  annotation_zero_or_more EMPTY_ARRAY                                                                      {/*  Rule not working :( */}
            |  annotation_zero_or_more EMPTY_ARRAY dims

primitive_type
            :   annotation_zero_or_more numeric_type
            |   annotation_zero_or_more BOOLEAN_KEYWORD

annotation_zero_or_more
            :   
            |   annotation annotation_zero_or_more

annotation
            :   normal_annotation
            |   marker_annotation
            |   single_element_annotation

normal_annotation
            :   '@' type_name '(' element_value_pair_list_zero_or_one ')'

element_value_pair_list_zero_or_one
            :   
            |   element_value_pair_list

element_value_pair_list
            :   element_value_pair comma_element_value_pair_zero_or_more

comma_element_value_pair_zero_or_more
            :   
            |   ',' element_value_pair comma_element_value_pair_zero_or_more

element_value_pair
            :   IDENTIFIERS '=' element_value

element_value
            :   condtional_expression
            |   element_value_array_initializer
            |   annotation

element_value_array_initializer
            :   '{' element_value_list_zero_or_one comma_zero_or_one '}'

element_value_list_zero_or_one
            :   
            |   element_value_list

comma_zero_or_one
            :   
            |   ','

element_value_list
            :   element_value comma_element_value_zero_or_more

comma_element_value_zero_or_more
            :   
            |   ',' element_value comma_element_value_zero_or_more

marker_annotation
            :   '@' type_name

single_element_annotation
            :   '@' type_name '(' element_value ')'

numeric_type
            :   BYTE_KEYWORD
            |   SHORT_KEYWORD
            |   INT_KEYWORD
            |   LONG_KEYWORD
            |   CHAR_KEYWORD
            |   FLOAT_KEYWORD
            |   DOUBLE_KEYWORD

array_initializer
            :   '{' variable_initializer_list_zero_or_more commas_zero_or_more '}' 

variable_initializer_list_zero_or_more
            :   
            |   variable_initializer_list variable_initializer_list_zero_or_more

commas_zero_or_more
            :  
            |   ',' commas_zero_or_more

variable_initializer_list
            :   variable_initializer 
            |   variable_initializer ',' variable_initializer_list

variable_initializer
            :   expression
            |   array_initializer

lambda_expression
            :   lambda_parameters PTR_OP lambda_body

lambda_parameters
            :   '(' lambda_parameter_list_zero_or_more ')'
            |   IDENTIFIERS

lambda_parameter_list_zero_or_one
            :   
            |   lambda_parameter_list

lambda_parameter_list
            :   lambda_parameter comma_lambda_parameter_zero_or_more
            |   IDENTIFIERS comma_identifiers_zero_or_more

comma_identifiers_zero_or_more
            :   
            |   ',' IDENTIFIERS comma_identifiers_zero_or_more

comma_lambda_parameter_zero_or_more
            :   
            |   ',' lambda_parameter comma_lambda_parameter_zero_or_more

lambda_parameter
            :   variable_modifier_zero_or_more lambda_parameter_type variable_declarator_id
            |   variable_arity_parameter

variable_arity_parameter
            :   variable_modifier_zero_or_more unann_type annotation_zero_or_more ELLIPSIS IDENTIFIERS

variable_modifier_zero_or_more
            :
            |   variable_modifier variable_modifier_zero_or_more
            
variable_modifier
            :   annotation
            |   FINAL_KEYWORD

variable_declarator_list
            :   IDENTIFIERS dims_zero_or_one

lambda_body
            :   expression
            |   block

class_literal
            :   type_name empty_array_zero_or_more '.' CLASS_KEYWORD
            |   numeric_type empty_array_zero_or_more '.' CLASS_KEYWORD
            |   BOOLEAN_KEYWORD empty_array_zero_or_more '.' CLASS_KEYWORD
            |   VOID_KEYWORD empty_array_zero_or_more '.' CLASS_KEYWORD

empty_array_zero_or_more
            :   
            |   EMPTY_ARRAY

type_name
            :   type_identifier
            |   package_or_type_name '.' type_identifier

package_or_type_name
            :   IDENTIFIERS
            |   package_or_type_name '.' IDENTIFIERS



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
        |  class_instance_creation_expression

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

//  ########   BLOCKS, STATEMENTS AND PATTERNS   ########  


%%

int main(){
    yyparse();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s. Line number %d\n\n", s, yylineno);
}