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

%left AND_OP 
%left OR_OP
%left EQ_OP NE_OP
%left RIGHT_OP LEFT_OP
%left INC_OP DEC_OP

%%

//  ########   COMPILATION UNIT   ########  

compilation_unit            
            :   ordinary_compilation_unit
            |   modular_compilation_unit

ordinary_compilation_unit
            :   package_declaration_zero_or_one import_declaration_zero_or_more top_level_class_or_interface_declaration_zero_or_more

package_declaration_zero_or_one
            :   /* empty */ 
            |   package_declaration

import_declaration_zero_or_more
            :   /* empty */ 
            |   import_declaration import_declaration_zero_or_more

top_level_class_or_interface_declaration_zero_or_more
            :   /* empty */ 
            |   top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more

modular_compilation_unit
            :   import_declaration_zero_or_more module_declaration

package_declaration
            :   PACKAGE_KEYWORD IDENTIFIERS ';'
            |   PACKAGE_KEYWORD IDENTIFIERS dot_identifier_one_or_more ';'

dot_identifier_one_or_more
            :   '.' IDENTIFIERS 
            |   '.' IDENTIFIERS dot_identifier_one_or_more

import_declaration
            :   single_type_import_declaration
            |   type_import_on_demand_declaration
            |   single_static_import_declaration
            |   static_import_on_demand_declaration

single_type_import_declaration
            :   IMPORT_KEYWORD type_name ';'

type_import_on_demand_declaration
            :   IMPORT_KEYWORD type_name '.' '*' ';'                         {/* may not work */}

single_static_import_declaration
            :   IMPORT_KEYWORD STATIC_KEYWORD type_name '.' IDENTIFIERS ';'

static_import_on_demand_declaration
            :   IMPORT_KEYWORD STATIC_KEYWORD type_name '.' '*' ';'

top_level_class_or_interface_declaration
            :   class_declaration                   
            |   interface_declaration
            |   ';'

module_declaration
            :   OPEN_zero_or_one MODULE_KEYWORD IDENTIFIERS  '{' module_directive '}'
            |   OPEN_zero_or_one MODULE_KEYWORD IDENTIFIERS dot_identifier_one_or_more '{' module_directive '}'

OPEN_zero_or_one
            :   /* empty */ 
            |   OPEN_KEYWORD

module_directive
            :   REQUIRES_KEYWORD requires_modifier_zero_or_more module_name ';'
            |   EXPORTS_KEYWORD type_name ';'
            |   EXPORTS_KEYWORD type_name TO_KEYWORD module_name comma_module_name_zero_or_more ';'
            |   OPENS_KEYWORD type_name ';'
            |   OPENS_KEYWORD type_name TO_KEYWORD module_name comma_module_name_zero_or_more ';'
            |   USES_KEYWORD type_name ';'
            |   PROVIDES_KEYWORD type_name WITH_KEYWORD type_name comma_type_name_zero_or_more ';'

comma_type_name_zero_or_more
            :   /* empty */ 
            |   ',' type_name comma_type_name_zero_or_more 

comma_module_name_zero_or_more
            :   /* empty */ 
            |   ',' module_name comma_module_name_zero_or_more

requires_modifier_zero_or_more
            :   /* empty */ 
            |   TRANSIENT_KEYWORD requires_modifier_zero_or_more
            |   STATIC_KEYWORD requires_modifier_zero_or_more

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
            |   method_invocation
            |   field_access
            |   array_access
            |   method_reference

field_access
            :   primary '.' IDENTIFIERS
            |   SUPER_KEYWORD '.' IDENTIFIERS
            |   type_name '.' SUPER_KEYWORD '.' IDENTIFIERS

array_access
            :   type_name '[' expression ']'
            |   primary_no_new_array '[' expression ']' 

method_reference
            :   type_name DOUBLE_COLON IDENTIFIERS
            |   primary DOUBLE_COLON IDENTIFIERS
            |   SUPER_KEYWORD DOUBLE_COLON IDENTIFIERS
            |   type_name '.' SUPER_KEYWORD DOUBLE_COLON IDENTIFIERS
        //     |   class_type DOUBLE_COLON NEW_KEYWORD
        //     |   array_type DOUBLE_COLON NEW_KEYWORD
            |   type_name DOUBLE_COLON type_arguments IDENTIFIERS
            |   primary DOUBLE_COLON type_arguments IDENTIFIERS
            |   SUPER_KEYWORD DOUBLE_COLON type_arguments IDENTIFIERS
            |   type_name '.' SUPER_KEYWORD DOUBLE_COLON type_arguments IDENTIFIERS
        //     |   class_type DOUBLE_COLON type_arguments NEW_KEYWORD

method_invocation
            :   IDENTIFIERS '(' argument_list_zero_or_one ')'
            |   type_name '.' IDENTIFIERS '(' argument_list_zero_or_one ')'            
            |   primary '.' IDENTIFIERS '(' argument_list_zero_or_one ')'
            |   SUPER_KEYWORD '.' IDENTIFIERS '(' argument_list_zero_or_one ')'
            |   type_name '.' SUPER_KEYWORD '.' IDENTIFIERS '(' argument_list_zero_or_one ')'
            |   type_name '.' type_arguments IDENTIFIERS '(' argument_list_zero_or_one ')'            
            |   primary '.' type_arguments IDENTIFIERS '(' argument_list_zero_or_one ')'
            |   SUPER_KEYWORD '.' type_arguments IDENTIFIERS '(' argument_list_zero_or_one ')'
            |   type_name '.' SUPER_KEYWORD '.' type_arguments IDENTIFIERS '(' argument_list_zero_or_one ')'

expression
            :   assignment_expression
            |   lambda_expression

assignment_expression
            :   condtional_expression
            |   assignment

condtional_expression
            :   conditional_or_expression
            |   conditional_or_expression '?' expression ':' condtional_expression
            |   conditional_or_expression '?' expression ':' lambda_expression

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
            |   instance_of_expression

instance_of_expression
            :   relational_expression INSTANCEOF_KEYWORD reference_type
            |   relational_expression INSTANCEOF_KEYWORD pattern

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
            |   multiplicative_expression '%' unary_expression
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
            |   type_name
            |   post_increment_expression
            |   post_decrement_expression

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
            :   /* empty */ 
            |   switch_rule switch_rule_zero_or_more

 switch_block_statement_group_zero_or_more
            :   /* empty */ 
            |   switch_block_statement_group switch_block_statement_group_zero_or_more

switch_label_colon_zero_or_more
            :   /* empty */ 
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
            :   /* empty */ 
            |   ',' case_constant comma_case_constant_zero_or_more

case_constant
            :   condtional_expression

class_instance_creation_expression
            :   unqualified_class_instance_creation_expression
            |   type_name '.' unqualified_class_instance_creation_expression
            |   primary '.' unqualified_class_instance_creation_expression

unqualified_class_instance_creation_expression
            :   NEW_KEYWORD IDENTIFIERS '(' argument_list_zero_or_one ')' class_body_zero_or_one
            |   NEW_KEYWORD type_arguments IDENTIFIERS '(' argument_list_zero_or_one ')' class_body_zero_or_one
            |   NEW_KEYWORD class_or_interface_type_to_instantiate '(' argument_list_zero_or_one ')' class_body_zero_or_one
            |   NEW_KEYWORD type_arguments class_or_interface_type_to_instantiate '(' argument_list_zero_or_one ')' class_body_zero_or_one

class_body_zero_or_one
            :   /* empty */ 
            |   class_body

argument_list 
            :   expression comma_expression_zero_or_more

comma_expression_zero_or_more
            :   /* empty */ 
            |   ',' expression comma_expression_zero_or_more
            
class_or_interface_type_to_instantiate
            :   IDENTIFIERS DIAMOND
            |   IDENTIFIERS type_arguments

assignment
            :   type_name ASSIGNMENT_OPERATORS expression 
            |   field_access ASSIGNMENT_OPERATORS expression 
            |   array_access ASSIGNMENT_OPERATORS expression 

ASSIGNMENT_OPERATORS 
            :   '='
            |   ADD_ASSIGN  
            |   SUB_ASSIGN  
            |   MUL_ASSIGN  
            |   DIV_ASSIGN
            |   AND_ASSIGN
            |   OR_ASSIGN
            |   XOR_ASSIGN
            |   MOD_ASSIGN
            |   LEFT_ASSIGN
            |   RIGHT_ASSIGN 
            |   BIT_RIGHT_SHFT_ASSIGN

array_creation_expression
            :   NEW_KEYWORD primitive_type dim_exprs dims_zero_or_one
            |   NEW_KEYWORD primitive_type dims array_initializer
            |   NEW_KEYWORD class_type dim_exprs dims_zero_or_one
            |   NEW_KEYWORD class_type dims array_initializer

dims_zero_or_one
            :   /* empty */ 
            |   dims

dim_exprs
            :   dim_expr
            |   dim_expr dim_exprs

dim_expr    
            :  '[' expression ']'

dims 
            :   EMPTY_ARRAY                                                                      {/*  Rule not working :( */}
            |   EMPTY_ARRAY dims

primitive_type
            :   numeric_type
            |   BOOLEAN_KEYWORD

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
            :   /* empty */ 
            |   variable_initializer_list variable_initializer_list_zero_or_more

commas_zero_or_more
            :  /* empty */ 
            |   ',' commas_zero_or_more

variable_initializer_list
            :   variable_initializer 
            |   variable_initializer ',' variable_initializer_list

variable_initializer
            :   expression
            |   array_initializer

lambda_expression
            :   lambda_parameters PTR_OP expression
            |   lambda_parameters PTR_OP block

lambda_parameters
            :   '(' lambda_parameter_list_zero_or_one ')'
            |   IDENTIFIERS

lambda_parameter_list_zero_or_one
            :   /* empty */ 
            |   lambda_parameter_list

lambda_parameter_list
            :   lambda_parameter comma_lambda_parameter_zero_or_more
            |   IDENTIFIERS comma_identifiers_zero_or_more

comma_identifiers_zero_or_more
            :   /* empty */ 
            |   ',' IDENTIFIERS comma_identifiers_zero_or_more

comma_lambda_parameter_zero_or_more
            :   /* empty */ 
            |   ',' lambda_parameter comma_lambda_parameter_zero_or_more

lambda_parameter
            :   lambda_parameter_type variable_declarator_id
            |   variable_modifier_one_or_more lambda_parameter_type variable_declarator_id
            |   variable_arity_parameter

lambda_parameter_type
            :   unann_type
            |   VAR_KEYWORD

variable_modifier_one_or_more
            :   FINAL_KEYWORD 
            |   FINAL_KEYWORD variable_modifier_one_or_more
            
class_literal
            :   type_name '.' CLASS_KEYWORD
            |   numeric_type '.' CLASS_KEYWORD
            |   BOOLEAN_KEYWORD '.' CLASS_KEYWORD
            |   VOID_KEYWORD '.' CLASS_KEYWORD
            |   type_name empty_array_one_or_more '.' CLASS_KEYWORD
            |   numeric_type empty_array_one_or_more '.' CLASS_KEYWORD
            |   BOOLEAN_KEYWORD empty_array_one_or_more '.' CLASS_KEYWORD
            |   VOID_KEYWORD empty_array_one_or_more '.' CLASS_KEYWORD

empty_array_one_or_more
            :   EMPTY_ARRAY 
            |   EMPTY_ARRAY empty_array_one_or_more

type_name
            :   IDENTIFIERS
            |   type_name '.' IDENTIFIERS

// ########   INTERFACES   ########  

interface_declaration
            :   normal_interface_declaration

normal_interface_declaration
            :   interface_modifier_zero_or_more INTERFACE_KEYWORD IDENTIFIERS interface_extends_zero_or_one interface_permits_zero_or_one interface_body
            |   interface_modifier_zero_or_more INTERFACE_KEYWORD IDENTIFIERS type_parameters interface_extends_zero_or_one interface_permits_zero_or_one interface_body
            |   interface_modifier_zero_or_more INTERFACE_KEYWORD IDENTIFIERS IDENTIFIERS EXTENDS_KEYWORD IDENTIFIERS interface_extends_zero_or_one interface_permits_zero_or_one interface_body

interface_modifier_zero_or_more
            :  /* empty */ 
            |   PUBLIC_KEYWORD interface_modifier_zero_or_more
            |   PROTECTED_KEYWORD interface_modifier_zero_or_more
            |   PRIVATE_KEYWORD interface_modifier_zero_or_more
            |   ABSTRACT_KEYWORD interface_modifier_zero_or_more
            |   STATIC_KEYWORD interface_modifier_zero_or_more
            |   SEALED_KEYWORD interface_modifier_zero_or_more
            |   NONSEALED_KEYWORD interface_modifier_zero_or_more
            |   STRICTFP_KEYWORD interface_modifier_zero_or_more

type_parameter
            :   IDENTIFIERS
            |   IDENTIFIERS type_bound

type_bound
            :   EXTENDS_KEYWORD IDENTIFIERS additional_bound_zero_or_more
            |   EXTENDS_KEYWORD class_type additional_bound_zero_or_more

additional_bound_zero_or_more
            :   /* empty */ 
            |   additional_bound additional_bound_zero_or_more

additional_bound
            :   '&' class_type

class_type
            :   IDENTIFIERS type_arguments
            |   type_name '.' IDENTIFIERS
            |   class_type '.' IDENTIFIERS
            |   type_name '.' IDENTIFIERS type_arguments
            |   class_type '.' IDENTIFIERS type_arguments

type_arguments
            :   '<' type_argument_list '>'

type_argument_list
            :   type_argument comma_type_arguement_zero_or_more

comma_type_arguement_zero_or_more
            :   /* empty */ 
            |   ',' type_argument comma_type_arguement_zero_or_more
type_argument
            :   reference_type
            |   wild_card

wild_card
            :   '?'
            |   '?' EXTENDS_KEYWORD IDENTIFIERS
            |   '?' EXTENDS_KEYWORD reference_type
            |   '?' SUPER_KEYWORD IDENTIFIERS
            |   '?' SUPER_KEYWORD reference_type

reference_type
            :   class_type
            |   array_type
array_type
            :   primitive_type dims
            |   class_type dims
            |   IDENTIFIERS dims

interface_extends_zero_or_one
            :   /* empty */ 
            |   EXTENDS_KEYWORD interface_type_list

interface_permits_zero_or_one
            :   /* empty */ 
            |   interface_permits

interface_permits
            :   PERMITS_KEYWORD type_name comma_type_name_zero_or_more

interface_body
            :   '{' interface_member_decleration_zero_or_more '}'

interface_member_decleration_zero_or_more
            :   /* empty */ 
            |   interface_member_decleration interface_member_decleration_zero_or_more

interface_member_decleration
            :   constant_declaration
            |   interface_method_declaration
            |   class_declaration 
            |   interface_declaration

constant_declaration
            :   constant_modifier_zero_or_more unann_type variable_declarator_list ';'

constant_modifier_zero_or_more
            :   /* empty */
            |   PUBLIC_KEYWORD constant_modifier_zero_or_more 
            |   STATIC_KEYWORD constant_modifier_zero_or_more 
            |   FINAL_KEYWORD constant_modifier_zero_or_more 

interface_method_declaration
            :   interface_method_modifier_zero_or_more method_header block 
            |   interface_method_modifier_zero_or_more method_header ';' 

interface_method_modifier_zero_or_more
            :   /* empty */ 
            |   interface_method_modifier_zero_or_more PUBLIC_KEYWORD
            |   interface_method_modifier_zero_or_more PRIVATE_KEYWORD
            |   interface_method_modifier_zero_or_more ABSTRACT_KEYWORD
            |   interface_method_modifier_zero_or_more DEFAULT_KEYWORD
            |   interface_method_modifier_zero_or_more STATIC_KEYWORD
            |   interface_method_modifier_zero_or_more STRICTFP_KEYWORD

//  ########   BLOCKS, STATEMENTS AND PATTERNS   ########  

block
        :   '{' block_statements_zero_or_one '}'

block_statements_zero_or_one
        :   /* empty */ 
        |   block_statements

block_statements
        :   block_statement block_statements_zero_or_more

block_statements_zero_or_more
        :   /* empty */ 
        |   block_statement block_statements_zero_or_more

block_statement
        :   statement
        |   local_variable_declaration_statement
        |   local_class_or_interface_declaration

local_class_or_interface_declaration
        :   class_declaration
        |   normal_interface_declaration

local_variable_declaration_statement
        :   local_variable_declaration ';'

local_variable_declaration
        :   local_variable_type variable_declarator_list
        |   variable_modifier_one_or_more local_variable_type variable_declarator_list

local_variable_type
        :   unann_type
        |   VAR_KEYWORD

statement
        :   statement_without_trailing_substatement
        |   labeled_statement
        |   if_then_statement
        |   if_then_else_statement
        |   while_statement
        |   for_statement

statement_no_short_if
        :   statement_without_trailing_substatement
        |   labeled_statement_no_short_if
        |   if_then_else_statement_no_short_if
        |   while_statement_no_short_if
        |   for_statement_no_short_if

statement_without_trailing_substatement
        :   block
        |   empty_statement
        |   expression_statement
        |   assert_statement
        |   switch_statement
        |   do_statememt
        |   break_statement
        |   continue_statement
        |   return_statement
        |   synchronized_statement
        |   throw_statement
        |   try_statement
        |   yield_statement

switch_statement
        :   switch_expression

do_statememt
        :   DO_KEYWORD statement WHILE_KEYWORD '(' expression ')' ';'

empty_statement
        :   ';'   

labeled_statement
        :   IDENTIFIERS ':' statement

labeled_statement_no_short_if
        :   IDENTIFIERS ':' statement_no_short_if

expression_statement
        :  statement_expression ';'

statement_expression
        :  assignment
        |  pre_increment_expression
        |  pre_decrement_expression
        |  post_increment_expression
        |  post_decrement_expression
        |  method_invocation
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

for_statement
        :  basic_for_statement
        |  enhanced_for_statement

for_statement_no_short_if
        :  basic_for_statement_no_short_if
        |  enhanced_for_statement_no_short_if

basic_for_statement
        :  FOR_KEYWORD '(' for_init_zero_or_one ';' expression_zero_or_one ';' for_update_zero_or_one ')' statement

basic_for_statement_no_short_if
        :  FOR_KEYWORD '(' for_init_zero_or_one ';' expression_zero_or_one ';' for_update_zero_or_one ')' statement_no_short_if

for_init_zero_or_one
        :  /* empty */ 
        |  for_init

expression_zero_or_one
        : /* empty */ 
        |  expression

for_update_zero_or_one
        :  /* empty */ 
        |  for_update

for_init
        :  statement_expression_list
        |  local_variable_declaration

for_update
        :  statement_expression_list

statement_expression_list
        :  statement_expression comma_statement_expression_zero_or_more

comma_statement_expression_zero_or_more
        :  /* empty */ 
        |  ',' statement_expression comma_statement_expression_zero_or_more

enhanced_for_statement
        :  FOR_KEYWORD '(' local_variable_declaration ':' expression ')' statement

enhanced_for_statement_no_short_if
        :  FOR_KEYWORD '(' local_variable_declaration ':' expression ')' statement_no_short_if

break_statement
        :  BREAK_KEYWORD IDENTIFIERS ';'
        |  BREAK_KEYWORD ';'

yield_statement
        :  YIELD_KEYWORD expression ';'

continue_statement
        :  CONTINUE_KEYWORD identifier_zero_or_one ';'

identifier_zero_or_one
        :  /* empty */ 
        | IDENTIFIERS

return_statement
        :  RETURN_KEYWORD expression_zero_or_one ';'

throw_statement
        :  THROW_KEYWORD expression ';'

synchronized_statement
        :  SYNCHRONIZED_KEYWORD '(' expression ')' block

try_statement
        :  TRY_KEYWORD block catches
        |  TRY_KEYWORD block catches_zero_or_one finally
        |  try_with_resources_statement

catches
        :  catch_clause catch_clause_zero_or_more

catch_clause_zero_or_more
        :   /* empty */ 
        |   catch_clause catch_clause_zero_or_more

catch_clause
        : CATCH_KEYWORD '(' catch_formal_parameter ')' block

catch_formal_parameter
        :   catch_type variable_declarator_id
        |   variable_modifier_one_or_more catch_type variable_declarator_id

catch_type
        : unann_class_type slash_class_type_zero_or_more

slash_class_type_zero_or_more
        :   /* empty */ 
        |   '|' class_type slash_class_type_zero_or_more

finally
        : FINALLY_KEYWORD block

try_with_resources_statement
        :  TRY_KEYWORD resources_specification block catches_zero_or_one finally_zero_or_one

catches_zero_or_one
        :  /* empty */ 
        |  catches

finally_zero_or_one
        :   /* empty */ 
        |   finally

resources_specification
        :  '(' resource_list semicolon_zero_or_one ')'

semicolon_zero_or_one
        :   /* empty */  
        |   ';'

resource_list
        :  resource semicolon_resource_zero_or_more

semicolon_resource_zero_or_more
        :   /* empty */ 
        |   ';' resource semicolon_resource_zero_or_more

resource
        :  local_variable_declaration
//      |  variable_access

pattern 
        :  type_pattern

type_pattern 
        : local_variable_declaration

//  ########   CLASSES   ########  

class_declaration
        :  normal_class_declaration
        // |  enum_declaration
        // |  record_declaration

normal_class_declaration
        :  class_modifier_zero_or_more CLASS_KEYWORD IDENTIFIERS type_parameters_zero_or_one                
        |  class_extends_zero_or_one class_implements_zero_or_one class_permits_zero_or_one class_body

class_modifier_zero_or_more
        :  /* empty */ 
        |  PUBLIC_KEYWORD class_modifier_zero_or_more
        |  PROTECTED_KEYWORD class_modifier_zero_or_more
        |  PRIVATE_KEYWORD class_modifier_zero_or_more
        |  STATIC_KEYWORD class_modifier_zero_or_more
        |  ABSTRACT_KEYWORD class_modifier_zero_or_more
        |  FINAL_KEYWORD class_modifier_zero_or_more
        |  SEALED_KEYWORD class_modifier_zero_or_more
        |  NONSEALED_KEYWORD class_modifier_zero_or_more
        |  STRICTFP_KEYWORD class_modifier_zero_or_more

type_parameters_zero_or_one
        :   /* empty */ 
        |  type_parameters

class_extends_zero_or_one
        :   /* empty */ 
        |  class_extends

class_implements_zero_or_one
        :   /* empty */ 
        |  class_implements

class_permits_zero_or_one
        : /* empty */ 
        |  class_permits

type_parameters
        :  '<' type_parameter_list '>'

type_parameter_list
        :  type_parameter comma_type_parameter_zero_or_more

comma_type_parameter_zero_or_more
        :  /* empty */ 
        |  ',' type_parameter comma_type_parameter_zero_or_more

class_extends
        :  EXTENDS_KEYWORD class_type

class_implements
        :  IMPLEMENTS_KEYWORD interface_type_list

interface_type_list
        :  class_type comma_interface_type_zero_or_more

comma_interface_type_zero_or_more
        :  /* empty */ 
        |  ',' class_type comma_interface_type_zero_or_more

class_permits
        :  PERMITS_KEYWORD type_name comma_type_name_zero_or_more

class_body
        :  '{' class_body_declaration_zero_or_more '}'

class_body_declaration_zero_or_more
        :   /* empty */ 
        |  class_body_declaration class_body_declaration_zero_or_more

class_body_declaration
        :  class_member_declaration
        |  block
        |  static_initializer
        |  constructor_declaration

class_member_declaration
        :  field_declaration
        |  method_declaration               
        |  class_declaration
        |  interface_declaration
        |  ';'

field_declaration
        :  field_modifier_zero_or_more unann_type variable_declarator_list ';'
        |  ppfs_keywords unann_type variable_declarator_list ';'

field_modifier_zero_or_more
        :  /* empty */ 
        |  field_modifier_zero_or_more TRANSIENT_KEYWORD 
        |  field_modifier_zero_or_more VOLATILE_KEYWORD 

variable_declarator_list
        :  variable_declarator comma_variable_declarator_zero_or_more

comma_variable_declarator_zero_or_more
        :  /* empty */ 
        |  ',' variable_declarator comma_variable_declarator_zero_or_more

variable_declarator
        :  variable_declarator_id equals_variable_initializer_zero_or_one

equals_variable_initializer_zero_or_one
        :  
        |  '=' expression
        |  '=' array_initializer

variable_declarator_id
        :  IDENTIFIERS dims_zero_or_one

unann_type
        :  primitive_type
        |  unann_reference_type

unann_reference_type
        :  unann_class_type
        |  unann_array_type

unann_class_type
        :  type_name
        |  type_name type_arguments
        |  unann_class_type '.' IDENTIFIERS

unann_array_type
        :  primitive_type dims
        |  unann_class_type dims
        |  IDENTIFIERS dims

method_declaration
        :  method_modifier_zero_or_more method_header block
        |  method_modifier_zero_or_more method_header ';'
        |  ppfs_keywords method_header block
        |  ppfs_keywords method_header ';'

method_modifier_zero_or_more
        :   /* empty */ 
        |   ABSTRACT_KEYWORD method_modifier_zero_or_more
        |   SYNCHRONIZED_KEYWORD method_modifier_zero_or_more
        |   NATIVE_KEYWORD method_modifier_zero_or_more
        |   STRICTFP_KEYWORD method_modifier_zero_or_more

ppfs_keywords
        :   /* emoty */
        |   PUBLIC_KEYWORD ppfs_keywords
        |   PRIVATE_KEYWORD ppfs_keywords
        |   PROTECTED_KEYWORD ppfs_keywords
        |   FINAL_KEYWORD ppfs_keywords
        |   STATIC_KEYWORD ppfs_keywords

method_header
        :  result method_declarator throws_zero_or_one
        |  type_parameters result method_declarator throws_zero_or_one

throws_zero_or_one
        :   /* empty */ 
        |   throws

result
        :  unann_type
        |  VOID_KEYWORD

method_declarator
        :  IDENTIFIERS '('  formal_parameter_list_zero_or_one ')' dims_zero_or_one
        :  IDENTIFIERS '(' reciever_parameter ',' formal_parameter_list_zero_or_one ')' dims_zero_or_one

formal_parameter_list_zero_or_one
        :   /* empty */ 
        |  formal_parameter_list

reciever_parameter
        :  unann_type identifier_dot_zero_or_one THIS_KEYWORD

identifier_dot_zero_or_one
        :  /* empty */ 
        |  IDENTIFIERS '.'

formal_parameter_list
        :  formal_parameter
        |  formal_parameter ',' formal_parameter_list

formal_parameter
        :  unann_type variable_declarator_id
        |  variable_modifier_one_or_more unann_type variable_declarator_id
        |  variable_arity_parameter
    
variable_arity_parameter
        :  unann_type ELLIPSIS IDENTIFIERS
        |  variable_modifier_one_or_more unann_type ELLIPSIS IDENTIFIERS

throws
        :  THROWS_KEYWORD exception_type_list

exception_type_list 
        :  class_type comma_exception_type_zero_or_more
        |  IDENTIFIERS comma_exception_type_zero_or_more

comma_exception_type_zero_or_more
        :   /* empty */ 
        |  ',' class_type comma_exception_type_zero_or_more    
        |  ',' IDENTIFIERS comma_exception_type_zero_or_more    

static_initializer
        :  STATIC_KEYWORD block  

constructor_declaration
        :  constructor_declarator throws_zero_or_one
        |  constructor_modifier_zero_or_more constructor_declarator throws_zero_or_one
        |  constructor_body

constructor_modifier_zero_or_more
        :   /* empty */ 
        | constructor_modifier_zero_or_more PUBLIC_KEYWORD 
        | constructor_modifier_zero_or_more PROTECTED_KEYWORD 
        | constructor_modifier_zero_or_more PRIVATE_KEYWORD 

constructor_declarator
        :  type_parameters_zero_or_one IDENTIFIERS '(' formal_parameter_list_zero_or_one ')'
        |  type_parameters_zero_or_one IDENTIFIERS '(' reciever_parameter ',' formal_parameter_list_zero_or_one ')'

constructor_body
        :  '{' explicit_constructor_invocation '}' 
        |  '{' block_statements '}' 
        |  '{' explicit_constructor_invocation block_statements '}' 
        |  '{'  '}'                                                                           {/* NEED TO WORK ON */} 

explicit_constructor_invocation
        :  THIS_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  SUPER_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  type_name '.' SUPER_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  primary '.' SUPER_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  type_arguments THIS_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  type_arguments SUPER_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  type_name '.' type_arguments SUPER_KEYWORD '(' argument_list_zero_or_one ')' ';'
        |  primary '.' type_arguments SUPER_KEYWORD '(' argument_list_zero_or_one ')' ';'

argument_list_zero_or_one
        :   /* empty */ 
        |  argument_list
   
%%

int main(){
    yyparse();
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s. Line number %d\n\n", s, yylineno);
}