%{
    #include <stdio.h>
    #include <string.h>
    #include "ast_helper.h"
    #define YYDEBUG 1

    int yylex(void);
    void yyerror(char const*);
    extern int yylineno;
    extern FILE* yyin;
    char output_file[10000];
%}

%locations

%union{
    Node* node;
    char* lex_val;
}
// type == nonterminal, token = terminal

%token<lex_val> goto_keyword_terminal const_keyword_terminal __keyword_terminal abstract_keyword_terminal continue_keyword_terminal for_keyword_terminal new_keyword_terminal switch_keyword_terminal assert_keyword_terminal default_keyword_terminal if_keyword_terminal package_keyword_terminal synchronized_keyword_terminal boolean_keyword_terminal do_keyword_terminal private_keyword_terminal this_keyword_terminal break_keyword_terminal double_keyword_terminal implements_keyword_terminal protected_keyword_terminal throw_keyword_terminal byte_keyword_terminal else_keyword_terminal import_keyword_terminal public_keyword_terminal throws_keyword_terminal case_keyword_terminal enum_keyword_terminal instanceof_keyword_terminal return_keyword_terminal transient_keyword_terminal catch_keyword_terminal extends_keyword_terminal int_keyword_terminal short_keyword_terminal try_keyword_terminal char_keyword_terminal final_keyword_terminal interface_keyword_terminal static_keyword_terminal void_keyword_terminal class_keyword_terminal finally_keyword_terminal long_keyword_terminal strictfp_keyword_terminal volatile_keyword_terminal float_keyword_terminal native_keyword_terminal super_keyword_terminal while_keyword_terminal exports_keyword_terminal opens_keyword_terminal requires_keyword_terminal uses_keyword_terminal module_keyword_terminal permits_keyword_terminal sealed_keyword_terminal var_keyword_terminal nonsealed_keyword_terminal provides_keyword_terminal to_keyword_terminal with_keyword_terminal open_keyword_terminal record_keyword_terminal transitive_keyword_terminal yield_keyword_terminal
%token<lex_val> '=' '>' '<' '!' '~' '?' ':' '+' '-' '*' '/' '&' '|' '^' '%' ',' '.' ';' '(' ')' '[' ']' '{' '}' '@'
%token<lex_val> PTR_OP_TERMINAL EQ_OP_TERMINAL GE_OP_TERMINAL LE_OP_TERMINAL NE_OP_TERMINAL AND_OP_TERMINAL OR_OP_TERMINAL INC_OP_TERMINAL DEC_OP_TERMINAL LEFT_OP_TERMINAL RIGHT_OP_TERMINAL BIT_RIGHT_SHFT_OP_TERMINAL ADD_ASSIGN_TERMINAL SUB_ASSIGN_TERMINAL MUL_ASSIGN_TERMINAL DIV_ASSIGN_TERMINAL AND_ASSIGN_TERMINAL OR_ASSIGN_TERMINAL XOR_ASSIGN_TERMINAL MOD_ASSIGN_TERMINAL LEFT_ASSIGN_TERMINAL RIGHT_ASSIGN_TERMINAL BIT_RIGHT_SHFT_ASSIGN_TERMINAL ELLIPSIS_TERMINAL DOUBLE_COLON_TERMINAL DIAMOND_TERMINAL
%token<lex_val> IDENTIFIERS_TERMINAL LITERALS_TERMINAL

%left AND_OP_TERMINAL
%left OR_OP_TERMINAL
%left EQ_OP_TERMINAL NE_OP_TERMINAL
%left RIGHT_OP_TERMINAL LEFT_OP_TERMINAL
%left INC_OP_TERMINAL DEC_OP_TERMINAL

%type<node> ABSTRACT_KEYWORD CONTINUE_KEYWORD FOR_KEYWORD NEW_KEYWORD SWITCH_KEYWORD ASSERT_KEYWORD DEFAULT_KEYWORD IF_KEYWORD PACKAGE_KEYWORD SYNCHRONIZED_KEYWORD BOOLEAN_KEYWORD DO_KEYWORD PRIVATE_KEYWORD THIS_KEYWORD BREAK_KEYWORD DOUBLE_KEYWORD IMPLEMENTS_KEYWORD PROTECTED_KEYWORD THROW_KEYWORD BYTE_KEYWORD ELSE_KEYWORD IMPORT_KEYWORD PUBLIC_KEYWORD THROWS_KEYWORD CASE_KEYWORD ENUM_KEYWORD INSTANCEOF_KEYWORD RETURN_KEYWORD TRANSIENT_KEYWORD CATCH_KEYWORD EXTENDS_KEYWORD INT_KEYWORD SHORT_KEYWORD TRY_KEYWORD CHAR_KEYWORD FINAL_KEYWORD INTERFACE_KEYWORD STATIC_KEYWORD VOID_KEYWORD CLASS_KEYWORD FINALLY_KEYWORD LONG_KEYWORD STRICTFP_KEYWORD VOLATILE_KEYWORD FLOAT_KEYWORD NATIVE_KEYWORD SUPER_KEYWORD WHILE_KEYWORD EXPORTS_KEYWORD OPENS_KEYWORD REQUIRES_KEYWORD USES_KEYWORD MODULE_KEYWORD PERMITS_KEYWORD SEALED_KEYWORD VAR_KEYWORD NONSEALED_KEYWORD PROVIDES_KEYWORD TO_KEYWORD WITH_KEYWORD OPEN_KEYWORD RECORD_KEYWORD TRANSITIVE_KEYWORD YIELD_KEYWORD
%type<node> ASSIGNMENT_OP GT_OP LT_OP EX_OP TL_OP QN_OP COLON_OP PLUS_OP MINUS_OP STAR_OP DIV_OP ND_OP BAR_OP RAISE_OP PCNT_OP COMMA_OP DOT_OP SEMICOLON_OP OP_BRCKT CLOSE_BRCKT OP_SQR_BRCKT CLOSE_SQR_BRCKT OP_CURLY_BRCKT CLOSE_CURLY_BRCKT
%type<node> PTR_OP EQ_OP GE_OP  LE_OP  NE_OP  AND_OP  OR_OP  INC_OP  DEC_OP  LEFT_OP  RIGHT_OP  BIT_RIGHT_SHFT_OP ADD_ASSIGN  SUB_ASSIGN  MUL_ASSIGN  DIV_ASSIGN  AND_ASSIGN  OR_ASSIGN  XOR_ASSIGN  MOD_ASSIGN  LEFT_ASSIGN  RIGHT_ASSIGN  BIT_RIGHT_SHFT_ASSIGN  ELLIPSIS  DOUBLE_COLON DIAMOND
%type<node> IDENTIFIERS LITERALS

%type<node> record_header record_body_declaration record_body_declaration_zero_or_more record_body record_component_list record_component record_declaration enum_constant_list_zero_or_more enum_body enum_constant enum_declaration open_zero_or_one additional_bound additional_bound_zero_or_more additive_expression and_expression argument_list argument_list_zero_or_one array_access array_creation_expression array_initializer array_type assert_statement assignment assignment_expression assignment_operators basic_for_statement basic_for_statement_no_short_if block block_statement block_statements block_statements_zero_or_more block_statements_zero_or_one break_statement case_constant cast_expression catch_clause catch_clause_zero_or_more catch_formal_parameter catch_type catches catches_zero_or_one class_body class_body_declaration class_body_declaration_zero_or_more class_body_zero_or_one class_declaration class_extends class_extends_zero_or_one class_implements class_implements_zero_or_one class_instance_creation_expression class_literal class_member_declaration class_or_interface_type_to_instantiate class_permits class_permits_zero_or_one class_type comma_case_constant_zero_or_more comma_exception_type_zero_or_more comma_expression_zero_or_more comma_identifiers_zero_or_more comma_interface_type_zero_or_more comma_lambda_parameter_zero_or_more comma_statement_expression_zero_or_more comma_type_arguement_zero_or_more comma_type_name_zero_or_more comma_type_parameter_zero_or_more comma_variable_declarator_zero_or_more commas_zero_or_more compilation_unit conditional_and_expression conditional_or_expression condtional_expression constant_declaration constructor_body constructor_declaration constructor_declarator continue_statement dim_expr dim_exprs dims dims_zero_or_one do_statememt empty_array_one_or_more empty_statement enhanced_for_statement enhanced_for_statement_no_short_if equality_expression equals_variable_initializer_zero_or_one exception_type_list exclusive_or_expression explicit_constructor_invocation expression expression_statement expression_zero_or_one field_access field_declaration finally finally_zero_or_one for_init for_init_zero_or_one for_statement for_statement_no_short_if for_update for_update_zero_or_one formal_parameter formal_parameter_list formal_parameter_list_zero_or_one identifier_dot_zero_or_one identifier_zero_or_one if_then_else_statement if_then_else_statement_no_short_if if_then_statement import_declaration import_declaration_zero_or_more inclusive_or_expression instance_of_expression interface_body interface_declaration interface_extends_zero_or_one interface_member_decleration interface_member_decleration_zero_or_more interface_method_declaration interface_permits interface_permits_zero_or_one interface_type_list labeled_statement labeled_statement_no_short_if lambda_expression lambda_parameter lambda_parameter_list lambda_parameter_list_zero_or_one lambda_parameter_type lambda_parameters local_class_or_interface_declaration local_variable_declaration local_variable_declaration_statement method_declaration method_declarator method_header method_invocation method_reference modifiers modifiers_zero_or_more modular_compilation_unit module_declaration module_directive module_directive_one_or_more multiplicative_expression normal_class_declaration normal_interface_declaration numeric_type ordinary_compilation_unit package_declaration pattern post_decrement_expression post_increment_expression postfix_expression pre_decrement_expression pre_increment_expression primary primary_no_new_array primitive_type reciever_parameter reference_type relational_expression resource resource_list resources_specification return_statement semicolon_resource_zero_or_more semicolon_zero_or_one shift_expression single_static_import_declaration single_type_import_declaration slash_class_type_zero_or_more start_state statement statement_expression statement_expression_list statement_no_short_if statement_without_trailing_substatement static_import_on_demand_declaration static_initializer switch_block switch_block_statement_group switch_block_statement_group_zero_or_more switch_expression switch_label switch_label_colon_zero_or_more switch_rule switch_rule_zero_or_more switch_statement synchronized_statement throw_statement throws throws_zero_or_one top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more try_statement try_with_resources_statement type_argument type_argument_list type_arguments type_bound type_import_on_demand_declaration type_name type_parameter_list type_parameters type_parameters_zero_or_one type_pattern unann_array_type unann_class_type unann_reference_type unann_type unary_expression unary_expression_not_plus_minus unqualified_class_instance_creation_expression variable_arity_parameter variable_declarator variable_declarator_id variable_declarator_list variable_initializer variable_initializer_list variable_initializer_list_zero_or_more variable_modifier_one_or_more while_statement while_statement_no_short_if wild_card yield_statement

%% 

//  ########   COMPILATION UNIT   ########  

start_state 
            :   compilation_unit                                                                                                                {$$ = $1; createAST($$, output_file);}

compilation_unit
            :   ordinary_compilation_unit                                                                                                       {Node* node = createNode("compilation unit"); node->addChildren({$1}); $$ = node;}
            |   modular_compilation_unit                                                                                                        {Node* node = createNode("compilation unit"); node->addChildren({$1}); $$ = node;}

ordinary_compilation_unit
            :   top_level_class_or_interface_declaration_zero_or_more                                                                           {Node* node = createNode("ordinary compilation unit"); node->addChildren({$1}); $$ = node;}
            |   package_declaration top_level_class_or_interface_declaration_zero_or_more                                                       {Node* node = createNode("ordinary compilation unit"); node->addChildren({$1, $2}); $$ = node;}
            |   import_declaration import_declaration_zero_or_more top_level_class_or_interface_declaration_zero_or_more                        {Node* node = createNode("ordinary compilation unit"); node->addChildren({$1, $2, $3}); $$ = node;}
            |   package_declaration import_declaration import_declaration_zero_or_more top_level_class_or_interface_declaration_zero_or_more    {Node* node = createNode("ordinary compilation unit"); node->addChildren({$1, $2, $3, $4}); $$ = node;}

import_declaration_zero_or_more
            :   /* empty */                                                                                                                     {Node* node = createNode("import declaration zero or more"); $$ = node;}
            |   import_declaration import_declaration_zero_or_more                                                                              {Node* node = createNode("import declaration zero or more"); node->addChildren({$1, $2}); $$ = node;}

top_level_class_or_interface_declaration_zero_or_more
            :   /* empty */                                                                                                                     {Node* node = createNode("top level class or interface declaration zero or more"); $$ = node;} 
            |   top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more                                  {Node* node = createNode("top level class or interface declaration zero or more"); node->addChildren({$1, $2}); $$ = node;}

modular_compilation_unit
            :   import_declaration_zero_or_more module_declaration                                                                              {Node* node = createNode("modular compilation unit"); node->addChildren({$1, $2}); $$ = node;}

package_declaration
            :   PACKAGE_KEYWORD type_name SEMICOLON_OP                                                                                          {Node* node = createNode("package declaration"); node->addChildren({$1,$2,$3}); $$ = node;}

import_declaration
            :   single_type_import_declaration                                                                                                  {Node* node = createNode("import declaration"); node->addChildren({$1}); $$ = node;}
            |   type_import_on_demand_declaration                                                                                               {Node* node = createNode("import declaration"); node->addChildren({$1}); $$ = node;}
            |   single_static_import_declaration                                                                                                {Node* node = createNode("import declaration"); node->addChildren({$1}); $$ = node;}
            |   static_import_on_demand_declaration                                                                                             {Node* node = createNode("import declaration"); node->addChildren({$1}); $$ = node;}

single_type_import_declaration
            :   IMPORT_KEYWORD type_name SEMICOLON_OP                                                                                           {Node* node = createNode("single type import declaration"); node->addChildren({$1,$2,$3}); $$ = node;}

type_import_on_demand_declaration
            :   IMPORT_KEYWORD type_name DOT_OP STAR_OP SEMICOLON_OP                                                                            {Node* node = createNode("type import on demand declaration"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

single_static_import_declaration
            :   IMPORT_KEYWORD STATIC_KEYWORD type_name DOT_OP IDENTIFIERS SEMICOLON_OP                                                         {Node* node = createNode("single static import declaration"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}

static_import_on_demand_declaration
            :   IMPORT_KEYWORD STATIC_KEYWORD type_name DOT_OP STAR_OP SEMICOLON_OP                                                             {Node* node = createNode("static import on demand declaration"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}

top_level_class_or_interface_declaration
            :   class_declaration                                                                                                               {Node* node = createNode("top level class or interface declaration"); node->addChildren({$1}); $$ = node;}
            |   interface_declaration                                                                                                           {Node* node = createNode("top level class or interface declaration"); node->addChildren({$1}); $$ = node;}
            |   SEMICOLON_OP                                                                                                                    {Node* node = createNode("top level class or interface declaration"); node->addChildren({$1}); $$ = node;}

module_declaration
            :   open_zero_or_one MODULE_KEYWORD type_name OP_CURLY_BRCKT CLOSE_CURLY_BRCKT                                                      {Node* node = createNode("module declaration"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
            |   open_zero_or_one MODULE_KEYWORD type_name OP_CURLY_BRCKT module_directive_one_or_more CLOSE_CURLY_BRCKT                         {Node* node = createNode("module declaration"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}

open_zero_or_one
            :   /* empty */                                                                                                                     {Node* node = createNode("OPEN zero or one"); node->addChildren({}); $$ = node;}
            |   OPEN_KEYWORD                                                                                                                    {Node* node = createNode("OPEN zero or one"); node->addChildren({$1}); $$ = node;}

module_directive_one_or_more
            :   module_directive                                                                                                                {Node* node = createNode("module directive one or more"); node->addChildren({$1}); $$ = node;}
            |   module_directive module_directive_one_or_more                                                                                   {Node* node = createNode("module directive one or more"); node->addChildren({$1,$2}); $$ = node;}

module_directive
            :   REQUIRES_KEYWORD modifiers_zero_or_more type_name SEMICOLON_OP                                                                  {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   EXPORTS_KEYWORD type_name SEMICOLON_OP                                                                                          {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   EXPORTS_KEYWORD type_name TO_KEYWORD type_name comma_type_name_zero_or_more SEMICOLON_OP                                        {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
            |   OPENS_KEYWORD type_name SEMICOLON_OP                                                                                            {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   OPENS_KEYWORD type_name TO_KEYWORD type_name comma_type_name_zero_or_more SEMICOLON_OP                                          {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
            |   USES_KEYWORD type_name SEMICOLON_OP                                                                                             {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   PROVIDES_KEYWORD type_name WITH_KEYWORD type_name comma_type_name_zero_or_more SEMICOLON_OP                                     {Node* node = createNode("module directive"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}

comma_type_name_zero_or_more
            :   /* empty */                                                                                                                     {Node* node = createNode("comma type name zero or more"); node->addChildren({}); $$ = node;}
            |   COMMA_OP type_name comma_type_name_zero_or_more                                                                                 {Node* node = createNode("comma type name zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

//  ########   EXPRESSIONS   ########  

primary
            :   primary_no_new_array                                                                                                            {Node* node = createNode("primary"); node->addChildren({$1}); $$ = node;}
            |   array_creation_expression                                                                                                       {Node* node = createNode("primary"); node->addChildren({$1}); $$ = node;}

primary_no_new_array
            :   LITERALS                                                                                                                        {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   class_literal                                                                                                                   {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   THIS_KEYWORD                                                                                                                    {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   type_name DOT_OP THIS_KEYWORD                                                                                                   {Node* node = createNode("primary no new array"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   OP_BRCKT expression CLOSE_BRCKT                                                                                                 {Node* node = createNode("primary no new array"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   class_instance_creation_expression                                                                                              {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   method_invocation                                                                                                               {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   field_access                                                                                                                    {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   array_access                                                                                                                    {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   method_reference                                                                                                                {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}

field_access
            :   primary DOT_OP IDENTIFIERS                                                                                                      {Node* node = createNode("field access"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   SUPER_KEYWORD DOT_OP IDENTIFIERS                                                                                                {Node* node = createNode("field access"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   type_name DOT_OP SUPER_KEYWORD DOT_OP IDENTIFIERS                                                                               {Node* node = createNode("field access"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

array_access
            :   type_name OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                         {Node* node = createNode("array access"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   IDENTIFIERS OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                             {Node* node = createNode("array access"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   primary_no_new_array OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                    {Node* node = createNode("array access"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

method_reference
            :   type_name DOUBLE_COLON IDENTIFIERS                                                                                              {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   IDENTIFIERS DOUBLE_COLON IDENTIFIERS                                                                                            {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   primary DOUBLE_COLON IDENTIFIERS                                                                                                {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   SUPER_KEYWORD DOUBLE_COLON IDENTIFIERS                                                                                          {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   type_name DOT_OP SUPER_KEYWORD DOUBLE_COLON IDENTIFIERS                                                                         {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        //     |   class_type DOUBLE_COLON NEW_KEYWORD
        //     |   array_type DOUBLE_COLON NEW_KEYWORD
            |   type_name DOUBLE_COLON type_arguments IDENTIFIERS                                                                               {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   primary DOUBLE_COLON type_arguments IDENTIFIERS                                                                                 {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   SUPER_KEYWORD DOUBLE_COLON type_arguments IDENTIFIERS                                                                           {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   type_name DOT_OP SUPER_KEYWORD DOUBLE_COLON type_arguments IDENTIFIERS                                                          {Node* node = createNode("method reference"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
        //     |   class_type DOUBLE_COLON type_arguments NEW_KEYWORD

method_invocation
            :   IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                                      {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   type_name DOT_OP IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                               {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}         
            |   primary DOT_OP IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                       {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
            |   SUPER_KEYWORD DOT_OP IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                 {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
            |   type_name DOT_OP SUPER_KEYWORD DOT_OP IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                          {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8}); $$ = node;}
            |   type_name DOT_OP type_arguments IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}           
            |   primary DOT_OP type_arguments IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                        {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}           
            |   SUPER_KEYWORD DOT_OP type_arguments IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                  {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}           
            |   type_name DOT_OP SUPER_KEYWORD DOT_OP type_arguments IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT           {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8,$9}); $$ = node;}           

expression
            :   assignment_expression                                                                                                           {Node* node = createNode("expression"); node->addChildren({$1}); $$ = node;}           
            |   lambda_expression                                                                                                               {Node* node = createNode("expression"); node->addChildren({$1}); $$ = node;}           

assignment_expression
            :   condtional_expression                                                                                                           {Node* node = createNode(" assignment expression"); node->addChildren({$1}); $$ = node;}           
            |   assignment                                                                                                                      {Node* node = createNode("assignment expression"); node->addChildren({$1}); $$ = node;}           

condtional_expression
            :   conditional_or_expression                                                                                                       {Node* node = createNode("condtional expression"); node->addChildren({$1}); $$ = node;}           
            |   conditional_or_expression QN_OP expression COLON_OP condtional_expression                                                       {Node* node = createNode("condtional expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
            |   conditional_or_expression QN_OP expression COLON_OP lambda_expression                                                           {Node* node = createNode("condtional expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           

conditional_or_expression
            :   conditional_and_expression                                                                                                      {Node* node = createNode("condtional or expression"); node->addChildren({$1}); $$ = node;}           
            |   conditional_or_expression OR_OP conditional_and_expression                                                                      {Node* node = createNode("condtional or expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

conditional_and_expression
            :   inclusive_or_expression                                                                                                         {Node* node = createNode("condtional and expression"); node->addChildren({$1}); $$ = node;}           
            |   conditional_and_expression AND_OP inclusive_or_expression                                                                       {Node* node = createNode("condtional and expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

inclusive_or_expression
            :   exclusive_or_expression                                                                                                         {Node* node = createNode("inclusive or expression"); node->addChildren({$1}); $$ = node;}           
            |   inclusive_or_expression BAR_OP exclusive_or_expression                                                                          {Node* node = createNode("inclusive or expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

exclusive_or_expression
            :   and_expression                                                                                                                  {Node* node = createNode("exclusive or expression"); node->addChildren({$1}); $$ = node;}           
            |   exclusive_or_expression RAISE_OP and_expression                                                                                 {Node* node = createNode("exclusive or expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

and_expression
            :   equality_expression                                                                                                             {Node* node = createNode("and expression"); node->addChildren({$1}); $$ = node;}           
            |   and_expression ND_OP equality_expression                                                                                        {Node* node = createNode("and expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

equality_expression
            :   relational_expression                                                                                                           {Node* node = createNode("equality expression"); node->addChildren({$1}); $$ = node;}           
            |   equality_expression EQ_OP relational_expression                                                                                 {Node* node = createNode("equality expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   equality_expression NE_OP relational_expression                                                                                 {Node* node = createNode("equality expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

relational_expression
            :   shift_expression                                                                                                                {Node* node = createNode("relational expression"); node->addChildren({$1}); $$ = node;}           
            |   relational_expression LT_OP shift_expression                                                                                    {Node* node = createNode("relational expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression GT_OP shift_expression                                                                                    {Node* node = createNode("relational expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression LE_OP shift_expression                                                                                    {Node* node = createNode("relational expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression GE_OP shift_expression                                                                                    {Node* node = createNode("relational expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   instance_of_expression                                                                                                          {Node* node = createNode("relational expression"); node->addChildren({$1}); $$ = node;}           

unann_array_type
        :  primitive_type dims                                                                                                                  {Node* node = createNode("unann array type"); node->addChildren({$1,$2}); $$ = node;}           
        |  unann_class_type dims                                                                                                                {Node* node = createNode("unann array type"); node->addChildren({$1,$2}); $$ = node;}           
        |  IDENTIFIERS dims                                                                                                                     {Node* node = createNode("unann array type"); node->addChildren({$1,$2}); $$ = node;}           

instance_of_expression
            :   relational_expression INSTANCEOF_KEYWORD reference_type                                                                         {Node* node = createNode("instance of expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression INSTANCEOF_KEYWORD pattern                                                                                {Node* node = createNode("instance of expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression INSTANCEOF_KEYWORD primitive_type dims                                                                    {Node* node = createNode("instance of expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

shift_expression
            :   additive_expression                                                                                                             {Node* node = createNode("shift expression"); node->addChildren({$1}); $$ = node;}
            |   shift_expression LEFT_OP additive_expression                                                                                    {Node* node = createNode("shift expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   shift_expression RIGHT_OP additive_expression                                                                                   {Node* node = createNode("shift expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   shift_expression BIT_RIGHT_SHFT_OP additive_expression                                                                          {Node* node = createNode("shift expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

additive_expression
            :   multiplicative_expression                                                                                                       {Node* node = createNode("additive expression"); node->addChildren({$1}); $$ = node;}           
            |   additive_expression PLUS_OP multiplicative_expression                                                                           {Node* node = createNode("additive expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   additive_expression MINUS_OP multiplicative_expression                                                                          {Node* node = createNode("additive expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

multiplicative_expression
            :   unary_expression                                                                                                                {Node* node = createNode("multiplicative expression"); node->addChildren({$1}); $$ = node;}           
            |   multiplicative_expression STAR_OP unary_expression                                                                              {Node* node = createNode("multiplicative expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   multiplicative_expression PCNT_OP unary_expression                                                                              {Node* node = createNode("multiplicative expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   multiplicative_expression DIV_OP unary_expression                                                                               {Node* node = createNode("multiplicative expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

unary_expression
            :   pre_increment_expression                                                                                                        {Node* node = createNode("unary expression"); node->addChildren({$1}); $$ = node;}           
            |   pre_decrement_expression                                                                                                        {Node* node = createNode("unary expression"); node->addChildren({$1}); $$ = node;}           
            |   PLUS_OP unary_expression                                                                                                        {Node* node = createNode("unary expression"); node->addChildren({$1,$2}); $$ = node;}           
            |   MINUS_OP unary_expression                                                                                                       {Node* node = createNode("unary expression"); node->addChildren({$1,$2}); $$ = node;}           
            |   unary_expression_not_plus_minus                                                                                                 {Node* node = createNode("unary expression"); node->addChildren({$1}); $$ = node;}           

pre_increment_expression
            :   INC_OP unary_expression                                                                                                         {Node* node = createNode("pre increment expression"); node->addChildren({$1,$2}); $$ = node;}           

pre_decrement_expression
            :   DEC_OP unary_expression                                                                                                         {Node* node = createNode("pre decrement expression"); node->addChildren({$1,$2}); $$ = node;}           

unary_expression_not_plus_minus
            :   postfix_expression                                                                                                              {Node* node = createNode("unary expression not plus minus"); node->addChildren({$1}); $$ = node;}           
            |   TL_OP unary_expression                                                                                                          {Node* node = createNode("unary expression not plus minus"); node->addChildren({$1,$2}); $$ = node;}           
            |   EX_OP unary_expression                                                                                                          {Node* node = createNode("unary expression not plus minus"); node->addChildren({$1,$2}); $$ = node;}           
            |   cast_expression                                                                                                                 {Node* node = createNode("unary expression not plus minus"); node->addChildren({$1}); $$ = node;}           
            |   switch_expression                                                                                                               {Node* node = createNode("unary expression not plus minus"); node->addChildren({$1}); $$ = node;}           

postfix_expression
            :   primary                                                                                                                         {Node* node = createNode("postfix expression"); node->addChildren({$1}); $$ = node;}           
            |   type_name                                                                                                                 {Node* node = createNode("postfix expression"); node->addChildren({$1}); $$ = node;}           
            |   post_increment_expression                                                                                                       {Node* node = createNode("postfix expression"); node->addChildren({$1}); $$ = node;}           
            |   post_decrement_expression                                                                                                       {Node* node = createNode("postfix expression"); node->addChildren({$1}); $$ = node;}           

post_increment_expression
            :   postfix_expression INC_OP                                                                                                       {Node* node = createNode("post increment expression"); node->addChildren({$1,$2}); $$ = node;}           

post_decrement_expression
            :   postfix_expression DEC_OP                                                                                                       {Node* node = createNode("post decrement expression"); node->addChildren({$1,$2}); $$ = node;}           

cast_expression
            :   OP_BRCKT primitive_type CLOSE_BRCKT unary_expression                                                                                    {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
            |   OP_BRCKT IDENTIFIERS CLOSE_BRCKT unary_expression                                                                                       {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
            |   OP_BRCKT type_name CLOSE_BRCKT unary_expression                                                                                         {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
            |   OP_BRCKT IDENTIFIERS additional_bound CLOSE_BRCKT unary_expression                                                                      {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
            |   OP_BRCKT type_name additional_bound CLOSE_BRCKT unary_expression                                                                        {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           

switch_expression
            :   SWITCH_KEYWORD OP_BRCKT expression CLOSE_BRCKT switch_block                                                                             {Node* node = createNode("cswitch expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           

switch_block
            :   OP_CURLY_BRCKT switch_rule switch_rule_zero_or_more CLOSE_CURLY_BRCKT                                                                   {Node* node = createNode("switch block"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
            |   OP_CURLY_BRCKT switch_block_statement_group_zero_or_more switch_label_colon_zero_or_more CLOSE_CURLY_BRCKT                              {Node* node = createNode("switch block"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

switch_rule_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("switch rule zero or more"); node->addChildren({}); $$ = node;}           
            |   switch_rule switch_rule_zero_or_more                                                                                                    {Node* node = createNode("switch rule zero or more"); node->addChildren({$1,$2}); $$ = node;}           

switch_block_statement_group_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("switch block statement group zero or more"); node->addChildren({}); $$ = node;}           
            |   switch_block_statement_group switch_block_statement_group_zero_or_more                                                                  {Node* node = createNode("switch block statement group zero or more"); node->addChildren({$1,$2}); $$ = node;}           

switch_label_colon_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("switch label colon zero or more"); node->addChildren({}); $$ = node;}           
            |   switch_label COLON_OP switch_label_colon_zero_or_more                                                                                   {Node* node = createNode("switch label colon zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}           

switch_rule
            :   switch_label PTR_OP expression SEMICOLON_OP                                                                                             {Node* node = createNode("switch rule"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
            |   switch_label PTR_OP block                                                                                                               {Node* node = createNode("switch rule"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   switch_label PTR_OP throw_statement                                                                                                     {Node* node = createNode("switch rule"); node->addChildren({$1,$2,$3}); $$ = node;}           

switch_block_statement_group
            :   switch_label COLON_OP switch_label_colon_zero_or_more block_statements                                                                  {Node* node = createNode("switch block statement group"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

switch_label
            :   CASE_KEYWORD case_constant comma_case_constant_zero_or_more                                                                             {Node* node = createNode("switch label"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   DEFAULT_KEYWORD                                                                                                                         {Node* node = createNode("switch label"); node->addChildren({$1}); $$ = node;}           

comma_case_constant_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("comma case constant zero or more"); node->addChildren({}); $$ = node;}           
            |   COMMA_OP case_constant comma_case_constant_zero_or_more                                                                                 {Node* node = createNode("comma case constant zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}           

case_constant
            :   condtional_expression                                                                                                                   {Node* node = createNode("case constant"); node->addChildren({$1}); $$ = node;}           

class_instance_creation_expression
            :   unqualified_class_instance_creation_expression                                                                                          {Node* node = createNode("class instance creation expression"); node->addChildren({$1}); $$ = node;}           
            |   type_name DOT_OP unqualified_class_instance_creation_expression                                                                         {Node* node = createNode("class instance creation expression"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   primary DOT_OP unqualified_class_instance_creation_expression                                                                           {Node* node = createNode("class instance creation expression"); node->addChildren({$1,$2,$3}); $$ = node;}           

unqualified_class_instance_creation_expression
            :   NEW_KEYWORD IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one                                           {Node* node = createNode("unqualified class instance creation expression"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}           
            |   NEW_KEYWORD type_arguments IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one                            {Node* node = createNode("unqualified class instance creation expression"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}           
            |   NEW_KEYWORD class_or_interface_type_to_instantiate OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one                {Node* node = createNode("unqualified class instance creation expression"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}           
            |   NEW_KEYWORD type_arguments class_or_interface_type_to_instantiate OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one {Node* node = createNode("unqualified class instance creation expression"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}           

class_body_zero_or_one
            :   /* empty */                                                                                                                             {Node* node = createNode("class body zero or one"); node->addChildren({}); $$ = node;}           
            |   class_body                                                                                                                              {Node* node = createNode("class body zero or one"); node->addChildren({$1}); $$ = node;}           

argument_list
            :   expression comma_expression_zero_or_more                                                                                                {Node* node = createNode("argument list"); node->addChildren({$1, $2}); $$ = node;}           

comma_expression_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("comma expression zero or more"); node->addChildren({}); $$ = node;}           
            |   COMMA_OP expression comma_expression_zero_or_more                                                                                       {Node* node = createNode("comma expression zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}           

class_or_interface_type_to_instantiate
            :   IDENTIFIERS DIAMOND                                                                                                                     {Node* node = createNode("class or interface type to instantiate"); node->addChildren({$1,$2}); $$ = node;}           
            |   IDENTIFIERS type_arguments                                                                                                              {Node* node = createNode("class or interface type to instantiate"); node->addChildren({$1,$2}); $$ = node;}           

assignment
            :   type_name assignment_operators expression                                                                                         {Node* node = createNode("assignment"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   field_access assignment_operators expression                                                                                            {Node* node = createNode("assignment"); node->addChildren({$1,$2,$3}); $$ = node;}           
            |   array_access assignment_operators expression                                                                                            {Node* node = createNode("assignment"); node->addChildren({$1,$2,$3}); $$ = node;}           

assignment_operators 
            :   ASSIGNMENT_OP                                                                                                                           {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   ADD_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   SUB_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   MUL_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   DIV_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   AND_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   OR_ASSIGN                                                                                                                               {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   XOR_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   MOD_ASSIGN                                                                                                                              {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   LEFT_ASSIGN                                                                                                                             {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   RIGHT_ASSIGN                                                                                                                            {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           
            |   BIT_RIGHT_SHFT_ASSIGN                                                                                                                   {Node* node = createNode("assignment operators"); node->addChildren({$1}); $$ = node;}           

array_creation_expression
            :   NEW_KEYWORD primitive_type dim_expr dim_exprs dims_zero_or_one                                                                          {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
            |   NEW_KEYWORD primitive_type dims array_initializer                                                                                       {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
            |   NEW_KEYWORD class_type dim_expr dim_exprs dims_zero_or_one                                                                              {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
            |   NEW_KEYWORD class_type dims array_initializer                                                                                           {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

dims_zero_or_one
            :   /* empty */                                                                                                                             {Node* node = createNode("dims zero or one"); node->addChildren({}); $$ = node;}           
            |   dims                                                                                                                                    {Node* node = createNode("dims zero or one"); node->addChildren({$1}); $$ = node;}           

dim_exprs
            :   /* empty */                                                                                                                             {Node* node = createNode("dim exprs"); node->addChildren({}); $$ = node;}           
            |   dim_exprs dim_expr                                                                                                                      {Node* node = createNode("dim exprs"); node->addChildren({$1,$2}); $$ = node;}           

dim_expr    
            :  OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                                                  {Node* node = createNode("dim expr"); node->addChildren({$1,$2,$3}); $$ = node;}

dims 
            :   OP_SQR_BRCKT CLOSE_SQR_BRCKT                                                                                                            {Node* node = createNode("dims"); node->addChildren({$1,$2}); $$ = node;}
            |   OP_SQR_BRCKT CLOSE_SQR_BRCKT dims                                                                                                       {Node* node = createNode("dims"); node->addChildren({$1,$2,$3}); $$ = node;} 

primitive_type
            :   numeric_type                                                                                                                            {Node* node = createNode("primitive type"); node->addChildren({$1}); $$ = node;}
            |   BOOLEAN_KEYWORD                                                                                                                         {Node* node = createNode("primitive type"); node->addChildren({$1}); $$ = node;}

numeric_type
            :   BYTE_KEYWORD                                                                                                                            {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}
            |   SHORT_KEYWORD                                                                                                                           {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}
            |   INT_KEYWORD                                                                                                                             {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}
            |   LONG_KEYWORD                                                                                                                            {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}
            |   CHAR_KEYWORD                                                                                                                            {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}
            |   FLOAT_KEYWORD                                                                                                                           {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}
            |   DOUBLE_KEYWORD                                                                                                                          {Node* node = createNode("numeric type"); node->addChildren({$1}); $$ = node;}

array_initializer
            :   OP_CURLY_BRCKT variable_initializer_list_zero_or_more commas_zero_or_more CLOSE_CURLY_BRCKT                                             {Node* node = createNode("array initializer"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

variable_initializer_list_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("variable initializer list zero or more"); node->addChildren({}); $$ = node;}
            |   variable_initializer_list variable_initializer_list_zero_or_more                                                                        {Node* node = createNode("variable initializer list zero or more"); node->addChildren({$1,$2}); $$ = node;}

commas_zero_or_more
            :  /* empty */                                                                                                                              {Node* node = createNode("commas zero or more"); node->addChildren({}); $$ = node;}
            |   COMMA_OP commas_zero_or_more                                                                                                            {Node* node = createNode("commas zero or more"); node->addChildren({$1,$2}); $$ = node;}

variable_initializer_list
            :   variable_initializer                                                                                                                    {Node* node = createNode("variable initializer list"); node->addChildren({$1}); $$ = node;}
            |   variable_initializer COMMA_OP variable_initializer_list                                                                                 {Node* node = createNode("variable initializer list"); node->addChildren({$1,$2,$3}); $$ = node;}

variable_initializer
            :   expression                                                                                                                              {Node* node = createNode("variable initializer"); node->addChildren({$1}); $$ = node;}
            |   array_initializer                                                                                                                       {Node* node = createNode("variable initializer"); node->addChildren({$1}); $$ = node;}

lambda_expression
            :   lambda_parameters PTR_OP expression                                                                                                     {Node* node = createNode("lambda expression"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   lambda_parameters PTR_OP block                                                                                                          {Node* node = createNode("lambda expression"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   IDENTIFIERS PTR_OP block                                                                                                                {Node* node = createNode("lambda expression"); node->addChildren({$1,$2,$3}); $$ = node;}

lambda_parameters
            :   OP_BRCKT lambda_parameter_list_zero_or_one CLOSE_BRCKT                                                                                  {Node* node = createNode("lambda parameters"); node->addChildren({$1,$2,$3}); $$ = node;}

lambda_parameter_list_zero_or_one
            :   /* empty */                                                                                                                             {Node* node = createNode("lambda parameter list zero or one"); node->addChildren({}); $$ = node;}
            |   lambda_parameter_list                                                                                                                   {Node* node = createNode("lambda parameter list zero or one"); node->addChildren({$1}); $$ = node;}

lambda_parameter_list
            :   lambda_parameter comma_lambda_parameter_zero_or_more                                                                                    {Node* node = createNode("lambda parameter list"); node->addChildren({$1,$2}); $$ = node;}
            |   IDENTIFIERS comma_identifiers_zero_or_more                                                                                              {Node* node = createNode("lambda parameter list"); node->addChildren({$1,$2}); $$ = node;}

comma_identifiers_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("comma identifiers zero or more"); node->addChildren({}); $$ = node;}
            |   COMMA_OP IDENTIFIERS comma_identifiers_zero_or_more                                                                                     {Node* node = createNode("comma identifiers zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

comma_lambda_parameter_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("comma lambda parameter zero or more"); node->addChildren({}); $$ = node;}
            |   COMMA_OP lambda_parameter comma_lambda_parameter_zero_or_more                                                                           {Node* node = createNode("comma lambda parameter zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

lambda_parameter
            :   lambda_parameter_type variable_declarator_id                                                                                            {Node* node = createNode("lambda parameter"); node->addChildren({$1,$2}); $$ = node;}
            |   variable_modifier_one_or_more lambda_parameter_type variable_declarator_id                                                              {Node* node = createNode("lambda parameter"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   variable_arity_parameter                                                                                                                {Node* node = createNode("lambda parameter"); node->addChildren({$1}); $$ = node;}

lambda_parameter_type
            :   unann_type                                                                                                                              {Node* node = createNode("lambda parameter type"); node->addChildren({$1}); $$ = node;}
            |   VAR_KEYWORD                                                                                                                             {Node* node = createNode("lambda parameter type"); node->addChildren({$1}); $$ = node;}

variable_modifier_one_or_more 
            :   FINAL_KEYWORD                                                                                                                           {Node* node = createNode("variable modifier one or more"); node->addChildren({$1}); $$ = node;}
            |   variable_modifier_one_or_more FINAL_KEYWORD                                                                                             {Node* node = createNode("variable modifier one or more"); node->addChildren({$1,$2}); $$ = node;}

class_literal
            :   type_name DOT_OP CLASS_KEYWORD                                                                                                          {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   numeric_type DOT_OP CLASS_KEYWORD                                                                                                       {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   BOOLEAN_KEYWORD DOT_OP CLASS_KEYWORD                                                                                                    {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   VOID_KEYWORD DOT_OP CLASS_KEYWORD                                                                                                       {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   type_name empty_array_one_or_more DOT_OP CLASS_KEYWORD                                                                                  {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   numeric_type empty_array_one_or_more DOT_OP CLASS_KEYWORD                                                                               {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   BOOLEAN_KEYWORD empty_array_one_or_more DOT_OP CLASS_KEYWORD                                                                            {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   VOID_KEYWORD empty_array_one_or_more DOT_OP CLASS_KEYWORD                                                                               {Node* node = createNode("class literal"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

empty_array_one_or_more
            :   OP_SQR_BRCKT CLOSE_SQR_BRCKT                                                                                                            {Node* node = createNode("empty array one or more"); node->addChildren({$1,$2}); $$ = node;}
            |   OP_SQR_BRCKT CLOSE_SQR_BRCKT empty_array_one_or_more                                                                                    {Node* node = createNode("empty array one or more"); node->addChildren({$1,$2,$3}); $$ = node;}

type_name
            :   IDENTIFIERS                                                                                                                             {Node* node = createNode("type name"); node->addChildren({$1}); $$ = node;}
            |   type_name DOT_OP IDENTIFIERS                                                                                                            {Node* node = createNode("type name"); node->addChildren({$1,$2,$3}); $$ = node;}

// ########   MODIFIERS   ########  

modifiers
            :   PUBLIC_KEYWORD                                                                                                                          {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   PROTECTED_KEYWORD                                                                                                                       {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   PRIVATE_KEYWORD                                                                                                                         {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   ABSTRACT_KEYWORD                                                                                                                        {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   STATIC_KEYWORD                                                                                                                          {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   SEALED_KEYWORD                                                                                                                          {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   NONSEALED_KEYWORD                                                                                                                       {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   STRICTFP_KEYWORD                                                                                                                        {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   TRANSITIVE_KEYWORD                                                                                                                      {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   FINAL_KEYWORD                                                                                                                           {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   VOLATILE_KEYWORD                                                                                                                           {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   SYNCHRONIZED_KEYWORD                                                                                                                    {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   TRANSIENT_KEYWORD                                                                                                                       {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}
            |   NATIVE_KEYWORD                                                                                                                          {Node* node = createNode("modifiers"); node->addChildren({$1}); $$ = node;}

modifiers_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("modifiers zero or more"); node->addChildren({}); $$ = node;}
            |   modifiers modifiers_zero_or_more                                                                                                        {Node* node = createNode("modifiers zero or more"); node->addChildren({$1,$2}); $$ = node;}

// ########   INTERFACES   ########  

interface_declaration
            :   normal_interface_declaration                                                                                                            {Node* node = createNode("interface declaration"); node->addChildren({$1}); $$ = node;}

normal_interface_declaration
            :   modifiers_zero_or_more INTERFACE_KEYWORD IDENTIFIERS interface_extends_zero_or_one interface_permits_zero_or_one interface_body                 {Node* node = createNode("normal interface declaration"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
            |   modifiers_zero_or_more INTERFACE_KEYWORD IDENTIFIERS type_parameters interface_extends_zero_or_one interface_permits_zero_or_one interface_body {Node* node = createNode("normal interface declaration"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

type_bound
            :   EXTENDS_KEYWORD class_type additional_bound_zero_or_more                                                                                {Node* node = createNode("type bound"); node->addChildren({$1,$2,$3}); $$ = node;}

additional_bound_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("additional bound zero or more"); node->addChildren({}); $$ = node;}
            |   additional_bound additional_bound_zero_or_more                                                                                          {Node* node = createNode("additional bound zero or more"); node->addChildren({$1,$2}); $$ = node;}

additional_bound
            :   ND_OP class_type                                                                                                                        {Node* node = createNode("additional bound"); node->addChildren({$1,$2}); $$ = node;}

class_type
            :   IDENTIFIERS type_arguments                                                                                                              {Node* node = createNode("class type"); node->addChildren({$1,$2}); $$ = node;}
            |   type_name                                                                                                                               {Node* node = createNode("class type"); node->addChildren({$1}); $$ = node;}
            |   class_type DOT_OP IDENTIFIERS                                                                                                           {Node* node = createNode("class type"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   type_name DOT_OP IDENTIFIERS type_arguments                                                                                             {Node* node = createNode("class type"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   class_type DOT_OP IDENTIFIERS type_arguments                                                                                            {Node* node = createNode("class type"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

type_arguments
            :   LT_OP type_argument_list GT_OP                                                                                                          {Node* node = createNode("type arguments"); node->addChildren({$1,$2,$3}); $$ = node;}

type_argument_list
            :   type_argument comma_type_arguement_zero_or_more                                                                                         {Node* node = createNode("type argument list"); node->addChildren({$1,$2}); $$ = node;}
            |   primitive_type dims comma_type_arguement_zero_or_more                                                                                   {Node* node = createNode("type argument list"); node->addChildren({$1,$2,$3}); $$ = node;}

comma_type_arguement_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("comma type arguement zero or more"); node->addChildren({}); $$ = node;}
            |   COMMA_OP type_argument comma_type_arguement_zero_or_more                                                                                {Node* node = createNode("comma type arguement zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   COMMA_OP primitive_type dims comma_type_arguement_zero_or_more                                                                          {Node* node = createNode("comma type arguement zero or more"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            
type_argument
            :   reference_type                                                                                                                          {Node* node = createNode("type argument"); node->addChildren({$1}); $$ = node;}
            |   wild_card                                                                                                                               {Node* node = createNode("type argument"); node->addChildren({$1}); $$ = node;}

wild_card
            :   QN_OP                                                                                                                                   {Node* node = createNode("wild card"); node->addChildren({$1}); $$ = node;}
            |   QN_OP EXTENDS_KEYWORD reference_type                                                                                                    {Node* node = createNode("wild card"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   QN_OP EXTENDS_KEYWORD primitive_type dims                                                                                               {Node* node = createNode("wild card"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   QN_OP SUPER_KEYWORD reference_type                                                                                                      {Node* node = createNode("wild card"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   QN_OP SUPER_KEYWORD primitive_type dims                                                                                                 {Node* node = createNode("wild card"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

reference_type
            :   class_type                                                                                                                              {Node* node = createNode("reference type"); node->addChildren({$1}); $$ = node;}
            |   array_type                                                                                                                              {Node* node = createNode("reference type"); node->addChildren({$1}); $$ = node;}

array_type
            :   class_type dims                                                                                                                         {Node* node = createNode("array type"); node->addChildren({$1,$2}); $$ = node;}

interface_extends_zero_or_one
            :   /* empty */                                                                                                                             {Node* node = createNode("interface extends zero or one"); node->addChildren({}); $$ = node;}
            |   EXTENDS_KEYWORD interface_type_list                                                                                                     {Node* node = createNode("interface extends zero or one"); node->addChildren({$1,$2}); $$ = node;}

interface_permits_zero_or_one
            :   /* empty */                                                                                                                             {Node* node = createNode("interface permits zero or one"); node->addChildren({}); $$ = node;}
            |   interface_permits                                                                                                                       {Node* node = createNode("interface permits zero or one"); node->addChildren({$1}); $$ = node;}

interface_permits
            :   PERMITS_KEYWORD type_name comma_type_name_zero_or_more                                                                                  {Node* node = createNode("interface permits"); node->addChildren({$1,$2,$3}); $$ = node;}

interface_body
            :   OP_CURLY_BRCKT interface_member_decleration_zero_or_more CLOSE_CURLY_BRCKT                                                              {Node* node = createNode("interface body"); node->addChildren({$1,$2,$3}); $$ = node;}

interface_member_decleration_zero_or_more
            :   /* empty */                                                                                                                             {Node* node = createNode("interface member decleration zero or more"); node->addChildren({}); $$ = node;}
            |   interface_member_decleration interface_member_decleration_zero_or_more                                                                  {Node* node = createNode("interface member decleration zero or more"); node->addChildren({$1,$2}); $$ = node;}

interface_member_decleration
            :   constant_declaration                                                                                                                    {Node* node = createNode("interface member decleration"); node->addChildren({$1}); $$ = node;}
            |   interface_method_declaration                                                                                                            {Node* node = createNode("interface member decleration"); node->addChildren({$1}); $$ = node;}
            |   class_declaration                                                                                                                       {Node* node = createNode("interface member decleration"); node->addChildren({$1}); $$ = node;}
            |   interface_declaration                                                                                                                   {Node* node = createNode("interface member decleration"); node->addChildren({$1}); $$ = node;}

constant_declaration
            :   modifiers_zero_or_more unann_type variable_declarator_list SEMICOLON_OP                                                                 {Node* node = createNode("constant decleration"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

interface_method_declaration
            :   modifiers_zero_or_more method_header block                                                                                              {Node* node = createNode("constant decleration"); node->addChildren({$1,$2,$3}); $$ = node;}
            |   modifiers_zero_or_more method_header SEMICOLON_OP                                                                                       {Node* node = createNode("constant decleration"); node->addChildren({$1,$2,$3}); $$ = node;}

//  ########   BLOCKS, STATEMENTS AND PATTERNS   ########  

block
        :   OP_CURLY_BRCKT block_statements_zero_or_one CLOSE_CURLY_BRCKT                                                                               {Node* node = createNode("block"); node->addChildren({$1,$2,$3}); $$ = node;}

block_statements_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("block statements zero or one"); node->addChildren({}); $$ = node;}
        |   block_statements                                                                                                                            {Node* node = createNode("block statements zero or one"); node->addChildren({$1}); $$ = node;}

block_statements
        :   block_statement block_statements_zero_or_more                                                                                               {Node* node = createNode("block statements"); node->addChildren({$1,$2}); $$ = node;}

block_statements_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("block statements zero or more"); node->addChildren({}); $$ = node;}
        |   block_statement block_statements_zero_or_more                                                                                               {Node* node = createNode("block statements zero or more"); node->addChildren({$1,$2}); $$ = node;}

block_statement
        :   statement                                                                                                                                   {Node* node = createNode("block statement"); node->addChildren({$1}); $$ = node;}
        |   local_variable_declaration_statement                                                                                                        {Node* node = createNode("block statement"); node->addChildren({$1}); $$ = node;}
        |   local_class_or_interface_declaration                                                                                                        {Node* node = createNode("block statement"); node->addChildren({$1}); $$ = node;}

local_class_or_interface_declaration
        :   class_declaration                                                                                                                           {Node* node = createNode("local class or interface declaration"); node->addChildren({$1}); $$ = node;}
        |   normal_interface_declaration                                                                                                                {Node* node = createNode("local class or interface declaration"); node->addChildren({$1}); $$ = node;}

local_variable_declaration_statement
        :   local_variable_declaration SEMICOLON_OP                                                                                                     {Node* node = createNode("local variable declaration statemen"); node->addChildren({$1,$2}); $$ = node;}

local_variable_declaration
        :   VAR_KEYWORD variable_declarator_list                                                                                                        {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2}); $$ = node;}
        |   numeric_type dims variable_declarator_list                                                                                                  {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2,$3}); $$ = node;}
        |   BOOLEAN_KEYWORD dims variable_declarator_list                                                                                               {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2,$3}); $$ = node;}
        |   unann_type variable_declarator_list                                                                                                         {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2}); $$ = node;}
        |   type_name variable_declarator_list                                                                                                          {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2}); $$ = node;}
        |   FINAL_KEYWORD VAR_KEYWORD variable_declarator_list                                                                                          {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2,$3}); $$ = node;}
        |   FINAL_KEYWORD unann_type variable_declarator_list                                                                                           {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2,$3}); $$ = node;}

statement
        :   statement_without_trailing_substatement                                                                                                     {Node* node = createNode("statement"); node->addChildren({$1}); $$ = node;}
        |   labeled_statement                                                                                                                           {Node* node = createNode("statement"); node->addChildren({$1}); $$ = node;}
        |   if_then_statement                                                                                                                           {Node* node = createNode("statement"); node->addChildren({$1}); $$ = node;}
        |   if_then_else_statement                                                                                                                      {Node* node = createNode("statement"); node->addChildren({$1}); $$ = node;}
        |   while_statement                                                                                                                             {Node* node = createNode("statement"); node->addChildren({$1}); $$ = node;}
        |   for_statement                                                                                                                               {Node* node = createNode("statement"); node->addChildren({$1}); $$ = node;}

statement_no_short_if
        :   statement_without_trailing_substatement                                                                                                     {Node* node = createNode("statement no short if"); node->addChildren({$1}); $$ = node;}
        |   labeled_statement_no_short_if                                                                                                               {Node* node = createNode("statement no short if"); node->addChildren({$1}); $$ = node;}
        |   if_then_else_statement_no_short_if                                                                                                          {Node* node = createNode("statement no short if"); node->addChildren({$1}); $$ = node;}
        |   while_statement_no_short_if                                                                                                                 {Node* node = createNode("statement no short if"); node->addChildren({$1}); $$ = node;}
        |   for_statement_no_short_if                                                                                                                   {Node* node = createNode("statement no short if"); node->addChildren({$1}); $$ = node;}

statement_without_trailing_substatement
        :   block                                                                                                                                       {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   empty_statement                                                                                                                             {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   expression_statement                                                                                                                        {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   assert_statement                                                                                                                            {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   switch_statement                                                                                                                            {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   do_statememt                                                                                                                                {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   break_statement                                                                                                                             {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   continue_statement                                                                                                                          {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   return_statement                                                                                                                            {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   synchronized_statement                                                                                                                      {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   throw_statement                                                                                                                             {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   try_statement                                                                                                                               {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   yield_statement                                                                                                                             {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}

switch_statement
        :   switch_expression                                                                                                                           {Node* node = createNode("switch statement"); node->addChildren({$1}); $$ = node;}

do_statememt
        :   DO_KEYWORD statement WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT SEMICOLON_OP                                                             {Node* node = createNode("do statement"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

empty_statement
        :   SEMICOLON_OP                                                                                                                                {Node* node = createNode("empty statement"); node->addChildren({$1}); $$ = node;}

labeled_statement
        :   IDENTIFIERS COLON_OP statement                                                                                                              {Node* node = createNode("labeled statement"); node->addChildren({$1,$2,$3}); $$ = node;}

labeled_statement_no_short_if
        :   IDENTIFIERS COLON_OP statement_no_short_if                                                                                                  {Node* node = createNode("labeled statement no short if"); node->addChildren({$1,$2,$3}); $$ = node;}

expression_statement
        :  statement_expression SEMICOLON_OP                                                                                                            {Node* node = createNode("expression statement"); node->addChildren({$1,$2}); $$ = node;}

statement_expression
        :  assignment                                                                                                                                   {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}
        |  pre_increment_expression                                                                                                                     {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}
        |  pre_decrement_expression                                                                                                                     {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}
        |  post_increment_expression                                                                                                                    {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}
        |  post_decrement_expression                                                                                                                    {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}
        |  method_invocation                                                                                                                            {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}
|  class_instance_creation_expression                                                                                                                   {Node* node = createNode("statement expression"); node->addChildren({$1}); $$ = node;}

if_then_statement
        :  IF_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement                                                                                         {Node* node = createNode("if then statement"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

if_then_else_statement
        :  IF_KEYWORD  OP_BRCKT expression CLOSE_BRCKT statement_no_short_if ELSE_KEYWORD statement                                                     {Node* node = createNode("if then else statement"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

if_then_else_statement_no_short_if
        :  IF_KEYWORD  OP_BRCKT expression CLOSE_BRCKT statement_no_short_if ELSE_KEYWORD statement_no_short_if                                         {Node* node = createNode("if then else statement no short if"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

assert_statement
        :  ASSERT_KEYWORD expression SEMICOLON_OP                                                                                                       {Node* node = createNode("assert statement"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  ASSERT_KEYWORD expression COLON_OP expression SEMICOLON_OP                                                                                   {Node* node = createNode("assert statement"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

while_statement
        :  WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement                                                                                      {Node* node = createNode("while statement"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

while_statement_no_short_if
        :  WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement_no_short_if                                                                          {Node* node = createNode("while statement no short if"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

for_statement
        :  basic_for_statement                                                                                                                          {Node* node = createNode("for statement"); node->addChildren({$1}); $$ = node;}
        |  enhanced_for_statement                                                                                                                       {Node* node = createNode("for statement"); node->addChildren({$1}); $$ = node;}

for_statement_no_short_if
        :  basic_for_statement_no_short_if                                                                                                              {Node* node = createNode("for statement no short if"); node->addChildren({$1}); $$ = node;}
        |  enhanced_for_statement_no_short_if                                                                                                           {Node* node = createNode("for statement no short if"); node->addChildren({$1}); $$ = node;}

basic_for_statement
        :  FOR_KEYWORD OP_BRCKT for_init_zero_or_one SEMICOLON_OP expression_zero_or_one SEMICOLON_OP for_update_zero_or_one CLOSE_BRCKT statement      {Node* node = createNode("basic for statement"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8,$9}); $$ = node;}

basic_for_statement_no_short_if
        :  FOR_KEYWORD OP_BRCKT for_init_zero_or_one SEMICOLON_OP expression_zero_or_one SEMICOLON_OP for_update_zero_or_one CLOSE_BRCKT statement_no_short_if {Node* node = createNode("basic for statement no short if"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8,$9}); $$ = node;}

for_init_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("for init zero or one"); node->addChildren({}); $$ = node;}
        |  for_init                                                                                                                                     {Node* node = createNode("for init zero or one"); node->addChildren({$1}); $$ = node;}

expression_zero_or_one
        : /* empty */                                                                                                                                   {Node* node = createNode("expression zero or one"); node->addChildren({}); $$ = node;}
        |  expression                                                                                                                                   {Node* node = createNode("expression zero or one"); node->addChildren({$1}); $$ = node;}

for_update_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("for update zero or one"); node->addChildren({}); $$ = node;}
        |  for_update                                                                                                                                   {Node* node = createNode("for update zero or one"); node->addChildren({$1}); $$ = node;}

for_init
        :  statement_expression_list                                                                                                                    {Node* node = createNode("for init"); node->addChildren({$1}); $$ = node;}
        |  local_variable_declaration                                                                                                                   {Node* node = createNode("for init"); node->addChildren({$1}); $$ = node;}

for_update
        :  statement_expression_list                                                                                                                    {Node* node = createNode("for update"); node->addChildren({$1}); $$ = node;}

statement_expression_list
        :  statement_expression comma_statement_expression_zero_or_more                                                                                 {Node* node = createNode("statement expression list"); node->addChildren({$1,$2}); $$ = node;}

comma_statement_expression_zero_or_more
        :  /* empty */                                                                                                                                  {Node* node = createNode("comma statement expression zero or more"); node->addChildren({}); $$ = node;}
        |  COMMA_OP statement_expression comma_statement_expression_zero_or_more                                                                        {Node* node = createNode("comma statement expression zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

enhanced_for_statement
        :  FOR_KEYWORD OP_BRCKT local_variable_declaration COLON_OP expression CLOSE_BRCKT statement                                                    {Node* node = createNode("enhanced for statement"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

enhanced_for_statement_no_short_if
        :  FOR_KEYWORD OP_BRCKT local_variable_declaration COLON_OP expression CLOSE_BRCKT statement_no_short_if                                        {Node* node = createNode("enhanced for statement no short if"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

break_statement
        :  BREAK_KEYWORD IDENTIFIERS SEMICOLON_OP                                                                                                       {Node* node = createNode("break statement"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  BREAK_KEYWORD SEMICOLON_OP                                                                                                                   {Node* node = createNode("break statement"); node->addChildren({$1,$2}); $$ = node;}

yield_statement
        :  YIELD_KEYWORD expression SEMICOLON_OP                                                                                                        {Node* node = createNode("yield statement"); node->addChildren({$1,$2,$3}); $$ = node;}

continue_statement
        :  CONTINUE_KEYWORD identifier_zero_or_one SEMICOLON_OP                                                                                         {Node* node = createNode("continue statement"); node->addChildren({$1,$2,$3}); $$ = node;}

identifier_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("identifier zero or one"); node->addChildren({}); $$ = node;} 
        | IDENTIFIERS                                                                                                                                   {Node* node = createNode("identifier zero or one"); node->addChildren({$1}); $$ = node;}

return_statement
        :  RETURN_KEYWORD expression_zero_or_one SEMICOLON_OP                                                                                           {Node* node = createNode("return statement"); node->addChildren({$1,$2,$3}); $$ = node;}

throw_statement
        :  THROW_KEYWORD expression SEMICOLON_OP                                                                                                        {Node* node = createNode("throw statement"); node->addChildren({$1,$2,$3}); $$ = node;}

synchronized_statement
        :  SYNCHRONIZED_KEYWORD OP_BRCKT expression CLOSE_BRCKT block                                                                                   {Node* node = createNode("synchronized statement"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

try_statement
        :  TRY_KEYWORD block catches                                                                                                                    {Node* node = createNode("try statement"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  TRY_KEYWORD block catches_zero_or_one finally                                                                                                {Node* node = createNode("try statement"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
        |  try_with_resources_statement                                                                                                                 {Node* node = createNode("try statement"); node->addChildren({$1}); $$ = node;}

catches
        :  catch_clause catch_clause_zero_or_more                                                                                                       {Node* node = createNode("catches"); node->addChildren({$1,$2}); $$ = node;}

catch_clause_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("catch clause zero or more"); node->addChildren({}); $$ = node;}
        |   catch_clause catch_clause_zero_or_more                                                                                                      {Node* node = createNode("catch clause zero or more"); node->addChildren({$1,$2}); $$ = node;}

catch_clause
        : CATCH_KEYWORD OP_BRCKT catch_formal_parameter CLOSE_BRCKT block                                                                               {Node* node = createNode("catch clause"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

catch_formal_parameter
        :   catch_type variable_declarator_id                                                                                                           {Node* node = createNode("catch formal parameter"); node->addChildren({$1,$2}); $$ = node;}
        |   variable_modifier_one_or_more catch_type variable_declarator_id                                                                             {Node* node = createNode("catch formal parameter"); node->addChildren({$1,$2,$3}); $$ = node;}

catch_type
        : unann_class_type slash_class_type_zero_or_more                                                                                                {Node* node = createNode("catch type"); node->addChildren({$1,$2}); $$ = node;}

slash_class_type_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("slash class type zero or more"); node->addChildren({}); $$ = node;}
        |   BAR_OP class_type slash_class_type_zero_or_more                                                                                             {Node* node = createNode("slash class type zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

finally
        : FINALLY_KEYWORD block                                                                                                                         {Node* node = createNode("finally"); node->addChildren({$1,$2}); $$ = node;}

try_with_resources_statement
        :  TRY_KEYWORD resources_specification block catches_zero_or_one finally_zero_or_one                                                            {Node* node = createNode("try with resources statement"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

catches_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("catches zero  or one"); node->addChildren({}); $$ = node;}
        |  catches                                                                                                                                      {Node* node = createNode("catches zero  or one"); node->addChildren({$1}); $$ = node;}

finally_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("finally zero  or one"); node->addChildren({}); $$ = node;}
        |   finally                                                                                                                                     {Node* node = createNode("finally zero  or one"); node->addChildren({$1}); $$ = node;}

resources_specification
        :  OP_BRCKT resource_list semicolon_zero_or_one CLOSE_BRCKT                                                                                     {Node* node = createNode("resources specification"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

semicolon_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("semicolon zero  or one"); node->addChildren({}); $$ = node;}
        |   SEMICOLON_OP                                                                                                                                {Node* node = createNode("semicolon zero  or one"); node->addChildren({$1}); $$ = node;}

resource_list
        :  resource semicolon_resource_zero_or_more                                                                                                     {Node* node = createNode("resource list"); node->addChildren({$1,$2}); $$ = node;}

semicolon_resource_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("semicolon resource zero or more"); node->addChildren({}); $$ = node;}
        |   SEMICOLON_OP resource semicolon_resource_zero_or_more                                                                                       {Node* node = createNode("semicolon resource zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

resource
        :  local_variable_declaration                                                                                                                   {Node* node = createNode("resource"); node->addChildren({$1}); $$ = node;}
        |  type_name                                                                                                                                    {Node* node = createNode("resource"); node->addChildren({$1}); $$ = node;}
        |  field_access                                                                                                                                 {Node* node = createNode("resource"); node->addChildren({$1}); $$ = node;}

pattern 
        :  type_pattern                                                                                                                                 {Node* node = createNode("pattern"); node->addChildren({$1}); $$ = node;}

type_pattern 
        : local_variable_declaration                                                                                                                    {Node* node = createNode("type pattern"); node->addChildren({$1}); $$ = node;}

//  ########   CLASSES   ########  

class_declaration
        :  normal_class_declaration                                                                                                                     {Node* node = createNode("class declaration"); node->addChildren({$1}); $$ = node;}
        |  enum_declaration                                                                                                                             {Node* node = createNode("class declaration"); node->addChildren({$1}); $$ = node;}
        |  record_declaration                                                                                                                           {Node* node = createNode("class declaration"); node->addChildren({$1}); $$ = node;}

record_declaration
        :  modifiers_zero_or_more RECORD_KEYWORD IDENTIFIERS type_parameters_zero_or_one record_header class_implements_zero_or_one record_body         {Node* node = createNode("record declaration"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

record_header
        :  OP_BRCKT CLOSE_BRCKT                                                                                                                         {Node* node = createNode("record header"); node->addChildren({$1,$2}); $$ = node;}
        |  OP_BRCKT record_component_list CLOSE_BRCKT                                                                                                   {Node* node = createNode("record header"); node->addChildren({$1,$2,$3}); $$ = node;}

record_component_list
        :  record_component                                                                                                                             {Node* node = createNode("record component list"); node->addChildren({$1}); $$ = node;}
        |  record_component_list COMMA_OP record_component                                                                                              {Node* node = createNode("record component list"); node->addChildren({$1,$2,$3}); $$ = node;}

record_component
        :  unann_type IDENTIFIERS                                                                                                                       {Node* node = createNode("record component"); node->addChildren({$1,$2}); $$ = node;}
        |  unann_type ELLIPSIS IDENTIFIERS                                                                                                              {Node* node = createNode("record component"); node->addChildren({$1,$2,$3}); $$ = node;}

record_body
        :  OP_CURLY_BRCKT record_body_declaration_zero_or_more CLOSE_CURLY_BRCKT                                                                        {Node* node = createNode("record body"); node->addChildren({$1,$2,$3}); $$ = node;}

record_body_declaration_zero_or_more
        :  /* empty */                                                                                                                                  {Node* node = createNode("record_body_declaration_zero_or_more"); node->addChildren({}); $$ = node;}
        |  record_body_declaration_zero_or_more record_body_declaration                                                                                 {Node* node = createNode("record_body_declaration_zero_or_more"); node->addChildren({$1,$2}); $$ = node;}

record_body_declaration
        :  class_body_declaration                                                                                                                       {Node* node = createNode("record_body_declaration"); node->addChildren({$1}); $$ = node;}
        |  modifiers_zero_or_more IDENTIFIERS constructor_body                                                                                          {Node* node = createNode("record_body_declaration"); node->addChildren({$1,$2,$3}); $$ = node;}

enum_declaration
        :  modifiers_zero_or_more ENUM_KEYWORD IDENTIFIERS class_implements_zero_or_one enum_body                                                       {Node* node = createNode("enum declaration"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

enum_body
        :  OP_CURLY_BRCKT enum_constant_list_zero_or_more CLOSE_CURLY_BRCKT                                                                             {Node* node = createNode("enum body"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  OP_CURLY_BRCKT SEMICOLON_OP class_body_declaration_zero_or_more CLOSE_CURLY_BRCKT                                                            {Node* node = createNode("enum body"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
        |  OP_CURLY_BRCKT enum_constant_list_zero_or_more SEMICOLON_OP class_body_declaration_zero_or_more CLOSE_CURLY_BRCKT                            {Node* node = createNode("enum body"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

enum_constant_list_zero_or_more 
        :  enum_constant                                                                                                                                {Node* node = createNode("enum_constant_list_zero_or_more"); node->addChildren({$1}); $$ = node;}
        |  enum_constant_list_zero_or_more COMMA_OP enum_constant                                                                                       {Node* node = createNode("enum_constant_list_zero_or_more"); node->addChildren({$1,$2,$3}); $$ = node;}

enum_constant
        :  IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one                                                            {Node* node = createNode("enum constant"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

normal_class_declaration
        :  modifiers_zero_or_more CLASS_KEYWORD IDENTIFIERS type_parameters_zero_or_one class_extends_zero_or_one class_implements_zero_or_one class_permits_zero_or_one class_body {Node* node = createNode("normal class declaration"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8}); $$ = node;}

type_parameters_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("type parameters zero or one"); node->addChildren({}); $$ = node;}
        |  type_parameters                                                                                                                              {Node* node = createNode("type parameters zero or one"); node->addChildren({$1}); $$ = node;}

class_extends_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("class extends zero or one"); node->addChildren({}); $$ = node;}
        |  class_extends                                                                                                                                {Node* node = createNode("class extends zero or one"); node->addChildren({$1}); $$ = node;}

class_implements_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("class implements zero or one"); node->addChildren({}); $$ = node;}
        |  class_implements                                                                                                                             {Node* node = createNode("class implements zero or one"); node->addChildren({$1}); $$ = node;}

class_permits_zero_or_one
        : /* empty */                                                                                                                                   {Node* node = createNode("class permits zero or one"); node->addChildren({}); $$ = node;}
        |  class_permits                                                                                                                                {Node* node = createNode("class permits zero or one"); node->addChildren({$1}); $$ = node;}

type_parameters
        :  LT_OP type_parameter_list GT_OP                                                                                                              {Node* node = createNode("type parameters"); node->addChildren({$1,$2,$3}); $$ = node;}

type_parameter_list
        :  IDENTIFIERS comma_type_parameter_zero_or_more                                                                                                {Node* node = createNode("type parameter list"); node->addChildren({$1,$2}); $$ = node;}
        |  IDENTIFIERS type_bound comma_type_parameter_zero_or_more                                                                                     {Node* node = createNode("type parameter list"); node->addChildren({$1,$2,$3}); $$ = node;}

comma_type_parameter_zero_or_more
        :  /* empty */                                                                                                                                  {Node* node = createNode("comma type parameter zero or more"); node->addChildren({}); $$ = node;}
        |  COMMA_OP IDENTIFIERS comma_type_parameter_zero_or_more                                                                                       {Node* node = createNode("comma type parameter zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  COMMA_OP IDENTIFIERS type_bound comma_type_parameter_zero_or_more                                                                            {Node* node = createNode("comma type parameter zero or more"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

class_extends
        :  EXTENDS_KEYWORD class_type                                                                                                                   {Node* node = createNode("class extends"); node->addChildren({$1,$2}); $$ = node;}

class_implements
        :  IMPLEMENTS_KEYWORD interface_type_list                                                                                                       {Node* node = createNode("class implements"); node->addChildren({$1,$2}); $$ = node;}

interface_type_list
        :   class_type comma_interface_type_zero_or_more                                                                                                {Node* node = createNode("interface type list"); node->addChildren({$1,$2}); $$ = node;}

comma_interface_type_zero_or_more
        :  /* empty */                                                                                                                                  {Node* node = createNode("comma interface type zero or more"); node->addChildren({}); $$ = node;}
        |  COMMA_OP class_type comma_interface_type_zero_or_more                                                                                        {Node* node = createNode("comma interface type zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

class_permits
        :  PERMITS_KEYWORD type_name comma_type_name_zero_or_more                                                                                       {Node* node = createNode("class permits"); node->addChildren({$1,$2,$3}); $$ = node;}

class_body
        :  OP_CURLY_BRCKT class_body_declaration_zero_or_more CLOSE_CURLY_BRCKT                                                                         {Node* node = createNode("class body"); node->addChildren({$1,$2,$3}); $$ = node;}

class_body_declaration_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("class body declaration zero or more"); node->addChildren({}); $$ = node;}
        |  class_body_declaration class_body_declaration_zero_or_more                                                                                   {Node* node = createNode("class body declaration zero or more"); node->addChildren({$1,$2}); $$ = node;}

class_body_declaration
        :  class_member_declaration                                                                                                                     {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  block                                                                                                                                        {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  static_initializer                                                                                                                           {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  constructor_declaration                                                                                                                      {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}

class_member_declaration
        :  field_declaration                                                                                                                            {Node* node = createNode("class member declaration"); node->addChildren({$1}); $$ = node;}
        |  method_declaration                                                                                                                           {Node* node = createNode("class member declaration"); node->addChildren({$1}); $$ = node;}              
        |  class_declaration                                                                                                                            {Node* node = createNode("class member declaration"); node->addChildren({$1}); $$ = node;}
        |  interface_declaration                                                                                                                        {Node* node = createNode("class member declaration"); node->addChildren({$1}); $$ = node;}
        |  SEMICOLON_OP                                                                                                                                 {Node* node = createNode("class member declaration"); node->addChildren({$1}); $$ = node;}

field_declaration
        :  modifiers_zero_or_more unann_type variable_declarator_list SEMICOLON_OP                                                                      {Node* node = createNode("field declaration"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

variable_declarator_list
        :  variable_declarator comma_variable_declarator_zero_or_more                                                                                   {Node* node = createNode("variable declarator list"); node->addChildren({$1,$2}); $$ = node;}

comma_variable_declarator_zero_or_more
        :  /* empty */                                                                                                                                  {Node* node = createNode("comma variable declarator zero or more"); node->addChildren({}); $$ = node;}
        |  comma_variable_declarator_zero_or_more COMMA_OP variable_declarator                                                                          {Node* node = createNode("comma variable declarator zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

variable_declarator
        :  variable_declarator_id equals_variable_initializer_zero_or_one                                                                               {Node* node = createNode("variable declarator"); node->addChildren({$1,$2}); $$ = node;}

equals_variable_initializer_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("equals variable initializer zero or one"); node->addChildren({}); $$ = node;}
        |  ASSIGNMENT_OP expression                                                                                                                     {Node* node = createNode("equals variable initializer zero or one"); node->addChildren({$1,$2}); $$ = node;}
        |  ASSIGNMENT_OP array_initializer                                                                                                              {Node* node = createNode("equals variable initializer zero or one"); node->addChildren({$1,$2}); $$ = node;}

variable_declarator_id
        :  IDENTIFIERS dims_zero_or_one                                                                                                                 {Node* node = createNode("variable declarator id"); node->addChildren({$1,$2}); $$ = node;}

unann_type
        :  primitive_type                                                                                                                               {Node* node = createNode("unann type"); node->addChildren({$1}); $$ = node;}
        |  unann_reference_type                                                                                                                         {Node* node = createNode("unann type"); node->addChildren({$1}); $$ = node;}

unann_reference_type
        :  unann_class_type                                                                                                                             {Node* node = createNode("unann reference type"); node->addChildren({$1}); $$ = node;}
        |  unann_array_type                                                                                                                             {Node* node = createNode("unann reference type"); node->addChildren({$1}); $$ = node;}

unann_class_type
        :  type_name                                                                                                                                    {Node* node = createNode("unann class type"); node->addChildren({$1}); $$ = node;}
        |  type_name type_arguments                                                                                                                     {Node* node = createNode("unann class type"); node->addChildren({$1,$2}); $$ = node;}
        |  unann_class_type DOT_OP IDENTIFIERS                                                                                                          {Node* node = createNode("unann class type"); node->addChildren({$1,$2,$3}); $$ = node;}

method_declaration
        :  modifiers_zero_or_more method_header block                                                                                                   {Node* node = createNode("method declaration"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  modifiers_zero_or_more method_header SEMICOLON_OP                                                                                            {Node* node = createNode("method declaration"); node->addChildren({$1,$2,$3}); $$ = node;}

method_header
        :  unann_type method_declarator throws_zero_or_one                                                                                              {Node* node = createNode("method header"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  VOID_KEYWORD method_declarator throws_zero_or_one                                                                                            {Node* node = createNode("method header"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  type_parameters unann_type method_declarator throws_zero_or_one                                                                              {Node* node = createNode("method header"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
        |  type_parameters VOID_KEYWORD method_declarator throws_zero_or_one                                                                            {Node* node = createNode("method header"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

throws_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("throws zero or one"); node->addChildren({}); $$ = node;}
        |   throws                                                                                                                                      {Node* node = createNode("throws zero or one"); node->addChildren({$1}); $$ = node;}

method_declarator
        :  IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT dims_zero_or_one                                                          {Node* node = createNode("method declarator"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        |  IDENTIFIERS OP_BRCKT reciever_parameter COMMA_OP formal_parameter_list_zero_or_one CLOSE_BRCKT dims_zero_or_one                              {Node* node = createNode("method declarator"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

formal_parameter_list_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("formal parameter list zero or one"); node->addChildren({}); $$ = node;}
        |  formal_parameter_list                                                                                                                        {Node* node = createNode("formal parameter list zero or one"); node->addChildren({$1}); $$ = node;}

reciever_parameter
        :  unann_type identifier_dot_zero_or_one THIS_KEYWORD                                                                                           {Node* node = createNode("reciever parameter"); node->addChildren({$1,$2,$3}); $$ = node;}

identifier_dot_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("identifier dot zero or one"); node->addChildren({}); $$ = node;}
        |  IDENTIFIERS DOT_OP                                                                                                                           {Node* node = createNode("identifier dot zero or one"); node->addChildren({$1,$2}); $$ = node;}

formal_parameter_list
        :  formal_parameter                                                                                                                             {Node* node = createNode("formal parameter list"); node->addChildren({$1}); $$ = node;}
        |  formal_parameter COMMA_OP formal_parameter_list                                                                                              {Node* node = createNode("formal parameter list"); node->addChildren({$1,$2,$3}); $$ = node;}

formal_parameter
        :  unann_type variable_declarator_id                                                                                                            {Node* node = createNode("formal parameter"); node->addChildren({$1,$2}); $$ = node;}
        |  variable_modifier_one_or_more unann_type variable_declarator_id                                                                              {Node* node = createNode("formal parameter"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  variable_arity_parameter                                                                                                                     {Node* node = createNode("formal parameter"); node->addChildren({$1}); $$ = node;}

variable_arity_parameter
        :  unann_type ELLIPSIS IDENTIFIERS                                                                                                              {Node* node = createNode("variable arity parameter"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  variable_modifier_one_or_more unann_type ELLIPSIS IDENTIFIERS                                                                                {Node* node = createNode("variable arity parameter"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

throws
        :  THROWS_KEYWORD exception_type_list                                                                                                           {Node* node = createNode("throws"); node->addChildren({$1,$2}); $$ = node;}

exception_type_list 
        :  class_type comma_exception_type_zero_or_more                                                                                                 {Node* node = createNode("exception type list"); node->addChildren({$1,$2}); $$ = node;}

comma_exception_type_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("comma exception type zero or more"); node->addChildren({}); $$ = node;}
        |  COMMA_OP class_type comma_exception_type_zero_or_more                                                                                        {Node* node = createNode("comma exception type zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}

static_initializer
        :  STATIC_KEYWORD block                                                                                                                         {Node* node = createNode("static initializer"); node->addChildren({$1,$2}); $$ = node;}

constructor_declaration
        :  modifiers_zero_or_more constructor_declarator throws_zero_or_one constructor_body                                                            {Node* node = createNode("constructor declaration"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

constructor_declarator
        :  IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT                                                                           {Node* node = createNode("constructor declarator"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
        |  IDENTIFIERS OP_BRCKT reciever_parameter COMMA_OP formal_parameter_list_zero_or_one CLOSE_BRCKT                                               {Node* node = createNode("constructor declarator"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
        |  type_parameters IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT                                                           {Node* node = createNode("constructor declarator"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        |  type_parameters IDENTIFIERS OP_BRCKT reciever_parameter COMMA_OP formal_parameter_list_zero_or_one CLOSE_BRCKT                               {Node* node = createNode("constructor declarator"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

constructor_body
        :  OP_CURLY_BRCKT explicit_constructor_invocation CLOSE_CURLY_BRCKT                                                                             {Node* node = createNode("constructor body"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  OP_CURLY_BRCKT block_statements CLOSE_CURLY_BRCKT                                                                                            {Node* node = createNode("constructor body"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  OP_CURLY_BRCKT explicit_constructor_invocation block_statements CLOSE_CURLY_BRCKT                                                            {Node* node = createNode("constructor body"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
        |  OP_CURLY_BRCKT CLOSE_CURLY_BRCKT                                                                                                             {Node* node = createNode("constructor body"); node->addChildren({$1,$2}); $$ = node;}

explicit_constructor_invocation
        :  THIS_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                                     {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        |  SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                                    {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        |  type_name DOT_OP SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                             {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}
        |  primary DOT_OP SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                     {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}
        |  type_arguments THIS_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                      {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
        |  type_arguments SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                     {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
        |  type_name DOT_OP type_arguments SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                              {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8}); $$ = node;}
        |  primary DOT_OP type_arguments SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                      {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8}); $$ = node;}

argument_list_zero_or_one
        :   /* empty */                                                 {Node* node = createNode("argument list zero or one"); node->addChildren({}); $$ = node;} 
        |  argument_list                                                {Node* node = createNode("argument list zero or one"); node->addChildren({$1}); $$ = node;}

// TERMINALS 

ASSIGNMENT_OP
        :       '='                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
GT_OP
        :       '>'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
LT_OP
        :       '<'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
EX_OP
        :       '!'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
TL_OP
        :       '~'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
QN_OP
        :       '?'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
COLON_OP
        :       ':'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
PLUS_OP
        :       '+'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
MINUS_OP
        :       '-'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
STAR_OP
        :       '*'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
DIV_OP
        :       '/'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
ND_OP
        :       '&'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
BAR_OP
        :       '|'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
RAISE_OP
        :       '^'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
PCNT_OP
        :       '%'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
COMMA_OP
        :       ','                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
DOT_OP
        :       '.'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
SEMICOLON_OP
        :       ';'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
OP_BRCKT
        :       '('                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
CLOSE_BRCKT
        :       ')'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
OP_SQR_BRCKT
        :       '['                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
CLOSE_SQR_BRCKT
        :       ']'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
OP_CURLY_BRCKT
        :       '{'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
CLOSE_CURLY_BRCKT
        :       '}'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ABSTRACT_KEYWORD
        :       abstract_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CONTINUE_KEYWORD
        :       continue_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true;$$ = temp;}

FOR_KEYWORD
        :       for_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

NEW_KEYWORD
        :       new_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SWITCH_KEYWORD
        :       switch_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ASSERT_KEYWORD
        :       assert_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DEFAULT_KEYWORD
        :       default_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

IF_KEYWORD
        :       if_keyword_terminal                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PACKAGE_KEYWORD
        :       package_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SYNCHRONIZED_KEYWORD
        :       synchronized_keyword_terminal                                           {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

BOOLEAN_KEYWORD
        :       boolean_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DO_KEYWORD
        :       do_keyword_terminal                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PRIVATE_KEYWORD
        :       private_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

THIS_KEYWORD
        :       this_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

BREAK_KEYWORD
        :       break_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DOUBLE_KEYWORD
        :       double_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

IMPLEMENTS_KEYWORD
        :       implements_keyword_terminal                                             {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PROTECTED_KEYWORD
        :       protected_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

THROW_KEYWORD
        :       throw_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

BYTE_KEYWORD
        :       byte_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ELSE_KEYWORD
        :       else_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

IMPORT_KEYWORD
        :       import_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PUBLIC_KEYWORD
        :       public_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

THROWS_KEYWORD
        :       throws_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CASE_KEYWORD
        :       case_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ENUM_KEYWORD
        :       enum_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true;  $$ = temp;}

INSTANCEOF_KEYWORD
        :       instanceof_keyword_terminal                                             {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

RETURN_KEYWORD
        :       return_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

TRANSIENT_KEYWORD
        :       transient_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CATCH_KEYWORD
        :       catch_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

EXTENDS_KEYWORD
        :       extends_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

INT_KEYWORD
        :       int_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SHORT_KEYWORD
        :       short_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

TRY_KEYWORD
        :       try_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CHAR_KEYWORD
        :       char_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

FINAL_KEYWORD
        :       final_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

INTERFACE_KEYWORD
        :       interface_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

STATIC_KEYWORD
        :       static_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

VOID_KEYWORD
        :       void_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CLASS_KEYWORD
        :       class_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

FINALLY_KEYWORD
        :       finally_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

LONG_KEYWORD
        :       long_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

STRICTFP_KEYWORD
        :       strictfp_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

VOLATILE_KEYWORD
        :       volatile_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

FLOAT_KEYWORD
        :       float_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

NATIVE_KEYWORD
        :       native_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SUPER_KEYWORD
        :       super_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

WHILE_KEYWORD
        :       while_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

EXPORTS_KEYWORD
        :       exports_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

OPENS_KEYWORD
        :       opens_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

REQUIRES_KEYWORD
        :       requires_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

USES_KEYWORD
        :       uses_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

MODULE_KEYWORD
        :       module_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PERMITS_KEYWORD
        :       permits_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SEALED_KEYWORD
        :       sealed_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

VAR_KEYWORD
        :       var_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

NONSEALED_KEYWORD
        :       nonsealed_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PROVIDES_KEYWORD
        :       provides_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

TO_KEYWORD
        :       to_keyword_terminal                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

WITH_KEYWORD
        :       with_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

OPEN_KEYWORD
        :       open_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

RECORD_KEYWORD
        :       record_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

TRANSITIVE_KEYWORD
        :       transitive_keyword_terminal                                             {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

YIELD_KEYWORD
        :       yield_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PTR_OP
        :       PTR_OP_TERMINAL                                                         {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

EQ_OP
        :       EQ_OP_TERMINAL                                                          {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

GE_OP
        :       GE_OP_TERMINAL                                                          {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

LE_OP
        :       LE_OP_TERMINAL                                                          {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

NE_OP
        :       NE_OP_TERMINAL                                                          {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

AND_OP
        :       AND_OP_TERMINAL                                                         {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

OR_OP
        :       OR_OP_TERMINAL                                                          {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

INC_OP
        :       INC_OP_TERMINAL                                                         {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DEC_OP
        :       DEC_OP_TERMINAL                                                         {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

LEFT_OP
        :       LEFT_OP_TERMINAL                                                        {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

RIGHT_OP
        :       RIGHT_OP_TERMINAL                                                       {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

BIT_RIGHT_SHFT_OP
        :       BIT_RIGHT_SHFT_OP_TERMINAL                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ADD_ASSIGN
        :       ADD_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SUB_ASSIGN
        :       SUB_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

MUL_ASSIGN
        :       MUL_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DIV_ASSIGN
        :       DIV_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

AND_ASSIGN
        :       AND_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

OR_ASSIGN
        :       OR_ASSIGN_TERMINAL                                                      {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

XOR_ASSIGN
        :       XOR_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

MOD_ASSIGN
        :       MOD_ASSIGN_TERMINAL                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

LEFT_ASSIGN
        :       LEFT_ASSIGN_TERMINAL                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

RIGHT_ASSIGN
        :       RIGHT_ASSIGN_TERMINAL                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

BIT_RIGHT_SHFT_ASSIGN
        :       BIT_RIGHT_SHFT_ASSIGN_TERMINAL                                          {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ELLIPSIS
        :       ELLIPSIS_TERMINAL                                                       {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DOUBLE_COLON
        :       DOUBLE_COLON_TERMINAL                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

DIAMOND
        :       DIAMOND_TERMINAL                                                        {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

IDENTIFIERS
        :       IDENTIFIERS_TERMINAL                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

LITERALS
        :       LITERALS_TERMINAL                                                       {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

%%

int main(int argc, char **argv){
    // 3 arguments are compulsory 
    /*
        ./myASTGenerator --input=../tests/test5.java −−output=test5.dot
    */

    // Lets look at the error cases first
    if (argc != 3){
        if(argc == 4 && strcmp(argv[3], "--verbose") == 0) {
                yydebug = 1;        
        }
        else if (argc == 2 && strcmp(argv[1], "--help") == 0)
        {
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
            return 0;
        } 

        else{
            printf("Usage: %s [--input=<input_file_name> --output=<output_file_name>][--verbose]\n", argv[0]);
            printf("--verbose is an optional flag ...\n");
            return 0;
        }
    }

    // Get input file
    char input_file[10000];

    // Extract the first token
    char * token_in = strtok(argv[1], "=");
    // loop through the string to extract all other tokens
    while( token_in != NULL ) {
       strcpy(input_file, token_in);
       token_in = strtok(NULL, "=");
    }

    FILE *myfile = fopen(input_file, "r");
    // make sure it's valid:
    if (!myfile) {
       cout << "Given file does not exists" << endl;
       return -1;
    }
    yyin = myfile;

    // Extract the first token
    char * token_out = strtok(argv[2], "=");
    // loop through the string to extract all other tokens
    while( token_out != NULL ) {
       strcpy(output_file, token_out);
       token_out = strtok(NULL, "=");
    }
    
    yyparse();
    fclose(yyin);
    return 0;
}

void yyerror (char const *s) {
  printf("\nError: %s. Line number %d\n\n", s, yylineno);
}