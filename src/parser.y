%{
    #include <stdio.h>
    #include <string.h>
    #include "inc/helper.h"
    #include "inc/3ac.h"
    #define YYDEBUG 1

    int yylex(void);
    void yyerror(char const*);
    extern int yylineno;
    GlobalSymbolTable* global_symtab = new GlobalSymbolTable();
    vector<bool> temporary_registors_in_use(MAX_REGISTORS, false);
    vector<ThreeAC*> threeAC_list;
    map<string, int> method_address;

    extern FILE* yyin;
    char output_file[10000];
%}

%locations

%union{
    Node* node;
    char* lex_val;
    FormalParameter* formal_parameter;
    FormalParameterList* formal_parameter_list;
    Modifier* modifier;
    ModifierList* modifier_list;
    Type* type;
    MethodDeclaration* method_declaration;
    VariableDeclaratorId* variable_declarator_id;
    VariableDeclaratorList* variable_declarator_list;
    Dims* dims;
    Expression* expression;
    IdentifiersList* identifiers_list;
    ExpressionList* expression_list;
}
// type == nonterminal, token = terminal

%token<lex_val> goto_keyword_terminal const_keyword_terminal __keyword_terminal abstract_keyword_terminal continue_keyword_terminal for_keyword_terminal new_keyword_terminal  assert_keyword_terminal default_keyword_terminal if_keyword_terminal synchronized_keyword_terminal boolean_keyword_terminal do_keyword_terminal private_keyword_terminal this_keyword_terminal break_keyword_terminal double_keyword_terminal implements_keyword_terminal protected_keyword_terminal throw_keyword_terminal byte_keyword_terminal else_keyword_terminal public_keyword_terminal return_keyword_terminal transient_keyword_terminal extends_keyword_terminal int_keyword_terminal short_keyword_terminal char_keyword_terminal final_keyword_terminal static_keyword_terminal void_keyword_terminal class_keyword_terminal long_keyword_terminal strictfp_keyword_terminal volatile_keyword_terminal float_keyword_terminal native_keyword_terminal super_keyword_terminal while_keyword_terminal record_keyword_terminal
%token<lex_val> '=' '>' '<' '!' '~' '?' ':' '+' '-' '*' '/' '&' '|' '^' '%' ',' '.' ';' '(' ')' '[' ']' '{' '}' '@'
%token<lex_val> EQ_OP_TERMINAL GE_OP_TERMINAL LE_OP_TERMINAL NE_OP_TERMINAL AND_OP_TERMINAL OR_OP_TERMINAL INC_OP_TERMINAL DEC_OP_TERMINAL LEFT_OP_TERMINAL RIGHT_OP_TERMINAL BIT_RIGHT_SHFT_OP_TERMINAL ADD_ASSIGN_TERMINAL SUB_ASSIGN_TERMINAL MUL_ASSIGN_TERMINAL DIV_ASSIGN_TERMINAL AND_ASSIGN_TERMINAL OR_ASSIGN_TERMINAL XOR_ASSIGN_TERMINAL MOD_ASSIGN_TERMINAL LEFT_ASSIGN_TERMINAL RIGHT_ASSIGN_TERMINAL BIT_RIGHT_SHFT_ASSIGN_TERMINAL
%token<lex_val> IDENTIFIERS_TERMINAL NUM_LITERALS DOUBLE_LITERALS STRING_LITERALS CHAR_LITERALS

%left AND_OP_TERMINAL
%left OR_OP_TERMINAL
%left EQ_OP_TERMINAL NE_OP_TERMINAL
%left RIGHT_OP_TERMINAL LEFT_OP_TERMINAL
%left INC_OP_TERMINAL DEC_OP_TERMINAL

%type<node> ABSTRACT_KEYWORD CONTINUE_KEYWORD FOR_KEYWORD NEW_KEYWORD ASSERT_KEYWORD IF_KEYWORD SYNCHRONIZED_KEYWORD BOOLEAN_KEYWORD DO_KEYWORD PRIVATE_KEYWORD THIS_KEYWORD BREAK_KEYWORD DOUBLE_KEYWORD PROTECTED_KEYWORD EXTENDS_KEYWORD THROW_KEYWORD BYTE_KEYWORD ELSE_KEYWORD PUBLIC_KEYWORD RETURN_KEYWORD TRANSIENT_KEYWORD INT_KEYWORD SHORT_KEYWORD CHAR_KEYWORD FINAL_KEYWORD STATIC_KEYWORD VOID_KEYWORD CLASS_KEYWORD LONG_KEYWORD STRICTFP_KEYWORD VOLATILE_KEYWORD FLOAT_KEYWORD NATIVE_KEYWORD SUPER_KEYWORD WHILE_KEYWORD
%type<node> ASSIGNMENT_OP GT_OP LT_OP EX_OP TL_OP QN_OP COLON_OP PLUS_OP MINUS_OP STAR_OP DIV_OP ND_OP BAR_OP RAISE_OP PCNT_OP COMMA_OP DOT_OP SEMICOLON_OP OP_BRCKT CLOSE_BRCKT OP_SQR_BRCKT CLOSE_SQR_BRCKT OP_CURLY_BRCKT CLOSE_CURLY_BRCKT
%type<node> EQ_OP GE_OP  LE_OP  NE_OP  AND_OP  OR_OP  INC_OP  DEC_OP  LEFT_OP  RIGHT_OP  BIT_RIGHT_SHFT_OP ADD_ASSIGN  SUB_ASSIGN  MUL_ASSIGN  DIV_ASSIGN  AND_ASSIGN  OR_ASSIGN  XOR_ASSIGN  MOD_ASSIGN  LEFT_ASSIGN  RIGHT_ASSIGN  BIT_RIGHT_SHFT_ASSIGN
%type<node> IDENTIFIERS

%type<node> expression_statement normal_class_declaration_statement array_access array_initializer assert_statement assignment_operators basic_for_statement basic_for_statement_no_short_if block block_statement block_statements block_statements_zero_or_more block_statements_zero_or_one break_statement class_body class_body_declaration class_body_declaration_zero_or_more class_body_zero_or_one class_declaration class_extends class_extends_zero_or_one compilation_unit constructor_body continue_statement dim_expr dim_exprs do_statememt empty_statement enhanced_for_statement enhanced_for_statement_no_short_if explicit_constructor_invocation field_access field_declaration for_init for_init_zero_or_one for_statement for_statement_no_short_if for_update for_update_zero_or_one identifier_zero_or_one if_then_else_statement if_then_else_statement_no_short_if if_then_statement labeled_statement labeled_statement_no_short_if local_class_or_interface_declaration local_variable_declaration local_variable_declaration_statement method_invocation normal_class_declaration ordinary_compilation_unit return_statement start_state statement  statement_no_short_if statement_without_trailing_substatement static_initializer synchronized_statement throw_statement top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more while_statement while_statement_no_short_if
%type<expression> assignment LITERALS class_instance_creation_expression additive_expression and_expression assignment_expression unary_expression unary_expression_not_plus_minus statement_expression conditional_and_expression conditional_or_expression condtional_expression equality_expression exclusive_or_expression expression expression_zero_or_one inclusive_or_expression multiplicative_expression post_decrement_expression post_increment_expression postfix_expression pre_decrement_expression pre_increment_expression primary primary_no_new_array relational_expression shift_expression variable_initializer
%type<expression_list> argument_list statement_expression_list argument_list_zero_or_one comma_expression_zero_or_more comma_statement_expression_zero_or_more variable_initializer_list_zero_or_more variable_initializer_list
%type<formal_parameter> formal_parameter 
%type<formal_parameter_list> formal_parameter_list formal_parameter_list_zero_or_one
%type<modifier_list> modifiers_zero_or_more
%type<modifier> modifiers
%type<type> unann_type primitive_type numeric_type
%type<method_declaration> constructor_declaration constructor_declarator method_declaration method_header method_declarator
%type<variable_declarator_id> variable_declarator_id variable_declarator
%type<variable_declarator_list> variable_declarator_list comma_variable_declarator_zero_or_more
%type<dims> dims dims_zero_or_one
%type<identifiers_list> type_name type_name_scoping
%% 

//  ########   COMPILATION UNIT   ########  

start_state 
            :   compilation_unit                                                                                                                {$$ = $1; createAST($$, output_file);}

compilation_unit
            :   ordinary_compilation_unit                                                                                                       {Node* node = createNode("compilation unit"); node->addChildren({$1}); $$ = node;}

ordinary_compilation_unit
            :   top_level_class_or_interface_declaration_zero_or_more                                                                           {Node* node = createNode("ordinary compilation unit"); node->addChildren({$1}); $$ = node;}

top_level_class_or_interface_declaration_zero_or_more
            :   /* empty */                                                                                                                     {Node* node = createNode("top level class or interface declaration zero or more"); $$ = node;} 
            |   top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more                                  {Node* node = createNode("top level class or interface declaration zero or more"); node->addChildren({$1, $2}); $$ = node;}

top_level_class_or_interface_declaration
            :   class_declaration                                                                                                               {Node* node = createNode("top level class or interface declaration"); node->addChildren({$1}); $$ = node;}
            |   SEMICOLON_OP                                                                                                                    {Node* node = createNode("top level class or interface declaration"); node->addChildren({$1}); $$ = node;}

//  ########   EXPRESSIONS   ########  

primary
            :   primary_no_new_array                                                                                                            {Expression* node = grammar_1("primary",$1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        //     |   array_creation_expression                                                                                                       {Expression* node = grammar_1("primary",$1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}

primary_no_new_array
            :   LITERALS                                                                                                                        {Expression* node = grammar_1("primary no new array", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        //     |   THIS_KEYWORD                                                                                                                    {Expression* node = grammar_1("primary no new array",$1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        //     |   type_name DOT_OP THIS_KEYWORD                                                                                                   {Node* node = createNode("primary no new array"); node->addChildren({$1,$2,$3}); $$ = node;}
        //     |   class_literal                                                                                                                   {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
            |   class_instance_creation_expression                                                                                              {Expression* node = grammar_1("primary no new array", $1, false, false); node->addChildren({$1}); $$ = node;}
            |   OP_BRCKT expression CLOSE_BRCKT                                                                                                 {Expression* node = grammar_1("primary no new array", $2, $2->isPrimary, $2->isLiteral); node->addChildren({$1,$2,$3}); $$ = node;}
        //     |   method_invocation                                                                                                               {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
        //     |   field_access                                                                                                                    {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}
        //     |   array_access                                                                                                                    {Node* node = createNode("primary no new array"); node->addChildren({$1}); $$ = node;}

field_access
            :   primary DOT_OP IDENTIFIERS                                                                                                      {Node* node = createNode("field access");  node->addChildren({$1,$2,$3}); $$ = node;}
        //     |   SUPER_KEYWORD DOT_OP IDENTIFIERS                                                                                                {Node* node = createNode("field access"); node->addChildren({$1,$2,$3}); $$ = node;}

array_access
            :   type_name OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                         {Node* node = createNode("array access"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
            |   primary_no_new_array OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                    {Node* node = createNode("array access"); node->addChildren({$1,$2,$3,$4}); $$ = node;}

method_invocation
            :   type_name OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                                        {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4}); $$ = node;}         
            |   primary DOT_OP IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                       {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}
            |   SUPER_KEYWORD DOT_OP IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                 {Node* node = createNode("method invocation"); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}

expression
            :   assignment_expression                                                                                                           {Expression* node =grammar_1("expression", $1, $1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           

assignment_expression
            :   condtional_expression                                                                                                           {Expression* node = grammar_1("assignment expression",$1, $1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   assignment                                                                                                                      {Expression* node = grammar_1("assignment expression",$1, $1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           

condtional_expression
            :   conditional_or_expression                                                                                                       {Expression* node = grammar_1("condtional expression",$1, $1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   conditional_or_expression QN_OP expression COLON_OP condtional_expression                                                       {Expression* node = cond_qn_co("condtional expression",$1,$3,$5); node->addChildren({$1,$2,$3,$4,$5});if(node == NULL) YYERROR; $$ = node;}           

conditional_or_expression
            :   conditional_and_expression                                                                                                      {Expression* node = grammar_1("condtional or expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   conditional_or_expression OR_OP conditional_and_expression                                                                      {Expression* node = evalOR_AND("condtional or expression",$1,"||",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

conditional_and_expression
            :   inclusive_or_expression                                                                                                         {Expression* node = grammar_1("condtional and expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   conditional_and_expression AND_OP inclusive_or_expression                                                                       {Expression* node = evalOR_AND("condtional and expression",$1,"&&",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

inclusive_or_expression
            :   exclusive_or_expression                                                                                                         {Expression* node = grammar_1("inclusive or expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   inclusive_or_expression BAR_OP exclusive_or_expression                                                                          {Expression* node = evalBITWISE("inclusive or expression",$1,"|",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

exclusive_or_expression
            :   and_expression                                                                                                                  {Expression* node = grammar_1("exclusive or expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   exclusive_or_expression RAISE_OP and_expression                                                                                 {Expression* node = evalBITWISE("exclusive or expression",$1,"^",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

and_expression
            :   equality_expression                                                                                                             {Expression* node = grammar_1("and expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   and_expression ND_OP equality_expression                                                                                        {Expression* node = evalBITWISE("and expression",$1,"&",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

equality_expression
            :   relational_expression                                                                                                           {Expression* node = grammar_1("equality expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   equality_expression EQ_OP relational_expression                                                                                 {Expression* node = evalEQ("equality expression",$1,"==",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   equality_expression NE_OP relational_expression                                                                                 {Expression* node = evalEQ("equality expression",$1,"!=",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

relational_expression
            :   shift_expression                                                                                                                {Expression* node = grammar_1("relational expression",$1,$1->isPrimary, $1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   relational_expression LT_OP shift_expression                                                                                    {Expression* node = evalRELATIONAL("relational expression",$1,"<",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression GT_OP shift_expression                                                                                    {Expression* node = evalRELATIONAL("relational expression",$1,">",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression LE_OP shift_expression                                                                                    {Expression* node = evalRELATIONAL("relational expression",$1,"<=",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   relational_expression GE_OP shift_expression                                                                                    {Expression* node = evalRELATIONAL("relational expression",$1,">=",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

shift_expression
            :   additive_expression                                                                                                             {Expression* node = grammar_1("shift expression",$1,$1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}
            |   shift_expression LEFT_OP additive_expression                                                                                    {Expression* node = evalSHIFT("shift expression",$1,"<<",$3);if(node == NULL) YYERROR;  node->addChildren({$1,$2,$3}); $$ = node;}           
            |   shift_expression RIGHT_OP additive_expression                                                                                   {Expression* node = evalSHIFT("shift expression",$1,">>",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   shift_expression BIT_RIGHT_SHFT_OP additive_expression                                                                          {Expression* node = evalSHIFT("shift expression",$1,">>>",$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

additive_expression
            :   multiplicative_expression                                                                                                       {Expression* node = grammar_1("additive expression",$1,$1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   additive_expression PLUS_OP multiplicative_expression                                                                           {Expression* node = evalARITHMETIC("additive expression","+",$1,$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   additive_expression MINUS_OP multiplicative_expression                                                                          {Expression* node = evalARITHMETIC("additive expression","-",$1,$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

multiplicative_expression
            :   unary_expression                                                                                                                {Expression* node = grammar_1("multiplicative expression",$1,$1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   multiplicative_expression STAR_OP unary_expression                                                                              {Expression* node = evalARITHMETIC("multiplicative expression","*",$1,$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   multiplicative_expression PCNT_OP unary_expression                                                                              {Expression* node = evalARITHMETIC("multiplicative expression","%",$1,$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           
            |   multiplicative_expression DIV_OP unary_expression                                                                               {Expression* node = evalARITHMETIC("multiplicative expression","/",$1,$3);if(node == NULL) YYERROR; node->addChildren({$1,$2,$3}); $$ = node;}           

unary_expression
            :   pre_increment_expression                                                                                                        {Expression* node = grammar_1("unary expression",$1,$1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   pre_decrement_expression                                                                                                        {Expression* node = grammar_1("unary expression",$1,$1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   PLUS_OP unary_expression                                                                                                        {Expression* node = evalUNARY("unary expression","+",$2);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           
            |   MINUS_OP unary_expression                                                                                                       {Expression* node = evalUNARY("unary expression","-",$2);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           
            |   unary_expression_not_plus_minus                                                                                                 {Expression* node = grammar_1("unary expression",$1,$1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           

pre_increment_expression
            :   INC_OP unary_expression                                                                                                         {Expression* node = evalIC_DC("pre increment expression","++",$2);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           

pre_decrement_expression
            :   DEC_OP unary_expression                                                                                                         {Expression* node = evalIC_DC("pre decrement expression","--",$2);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           

unary_expression_not_plus_minus
            :   postfix_expression                                                                                                              {Expression* node = grammar_1("unary expression not plus minus",$1, $1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   TL_OP unary_expression                                                                                                          {Expression* node = evalTL("unary expression not plus minus",$2);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           
            |   EX_OP unary_expression                                                                                                          {Expression* node = evalEX("unary expression not plus minus",$2);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           
        //     |   cast_expression                                                                                                                 {Node* node = createNode("unary expression not plus minus");if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
        //     |   switch_expression                                                                                                               {Node* node = createNode("unary expression not plus minus");if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           

postfix_expression
            :   primary                                                                                                                         {Expression* node = grammar_1("postfix expression",$1, $1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   type_name                                                                                                                       {Expression* node = grammar_1("postfix expression",(Expression*)$1, true,false);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   post_increment_expression                                                                                                       {Expression* node = grammar_1("postfix expression",$1, $1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
            |   post_decrement_expression                                                                                                       {Expression* node = grammar_1("postfix expression",$1, $1->isPrimary,$1->isLiteral);if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           

post_increment_expression
            :   postfix_expression INC_OP                                                                                                       {Expression* node = evalIC_DC("post increment expression","++",$1);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           

post_decrement_expression
            :   postfix_expression DEC_OP                                                                                                       {Expression* node = evalIC_DC("post decrement expression","--",$1);if(node == NULL) YYERROR; node->addChildren({$1,$2}); $$ = node;}           

// cast_expression
//             :   OP_BRCKT primitive_type CLOSE_BRCKT unary_expression                                                                                    {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
//             |   OP_BRCKT IDENTIFIERS CLOSE_BRCKT unary_expression                                                                                       {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
//             |   OP_BRCKT type_name CLOSE_BRCKT unary_expression                                                                                         {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
//             |   OP_BRCKT IDENTIFIERS additional_bound CLOSE_BRCKT unary_expression                                                                      {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
//             |   OP_BRCKT type_name additional_bound CLOSE_BRCKT unary_expression                                                                        {Node* node = createNode("cast expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           

// switch_expression
//             :   SWITCH_KEYWORD OP_BRCKT expression CLOSE_BRCKT switch_block                                                                             {Node* node = createNode("cswitch expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           

// switch_block
//             :   OP_CURLY_BRCKT switch_rule switch_rule_zero_or_more CLOSE_CURLY_BRCKT                                                                   {Node* node = createNode("switch block"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
//             |   OP_CURLY_BRCKT switch_block_statement_group_zero_or_more switch_label_colon_zero_or_more CLOSE_CURLY_BRCKT                              {Node* node = createNode("switch block"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

// switch_rule_zero_or_more
//             :   /* empty */                                                                                                                             {Node* node = createNode("switch rule zero or more"); node->addChildren({}); $$ = node;}           
//             |   switch_rule switch_rule_zero_or_more                                                                                                    {Node* node = createNode("switch rule zero or more"); node->addChildren({$1,$2}); $$ = node;}           

// switch_block_statement_group_zero_or_more
//             :   /* empty */                                                                                                                             {Node* node = createNode("switch block statement group zero or more"); node->addChildren({}); $$ = node;}           
//             |   switch_block_statement_group switch_block_statement_group_zero_or_more                                                                  {Node* node = createNode("switch block statement group zero or more"); node->addChildren({$1,$2}); $$ = node;}           

// switch_label_colon_zero_or_more
//             :   /* empty */                                                                                                                             {Node* node = createNode("switch label colon zero or more"); node->addChildren({}); $$ = node;}           
//             |   switch_label COLON_OP switch_label_colon_zero_or_more                                                                                   {Node* node = createNode("switch label colon zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}           

// switch_rule
//             :   switch_label PTR_OP expression SEMICOLON_OP                                                                                             {Node* node = createNode("switch rule"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
//             |   switch_label PTR_OP block                                                                                                               {Node* node = createNode("switch rule"); node->addChildren({$1,$2,$3}); $$ = node;}           
//             |   switch_label PTR_OP throw_statement                                                                                                     {Node* node = createNode("switch rule"); node->addChildren({$1,$2,$3}); $$ = node;}           

// switch_block_statement_group
//             :   switch_label COLON_OP switch_label_colon_zero_or_more block_statements                                                                  {Node* node = createNode("switch block statement group"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

// switch_label
//             :   CASE_KEYWORD case_constant comma_case_constant_zero_or_more                                                                             {Node* node = createNode("switch label"); node->addChildren({$1,$2,$3}); $$ = node;}           
//             |   DEFAULT_KEYWORD                                                                                                                         {Node* node = createNode("switch label"); node->addChildren({$1}); $$ = node;}           

// comma_case_constant_zero_or_more
//             :   /* empty */                                                                                                                             {Node* node = createNode("comma case constant zero or more"); node->addChildren({}); $$ = node;}           
//             |   COMMA_OP case_constant comma_case_constant_zero_or_more                                                                                 {Node* node = createNode("comma case constant zero or more"); node->addChildren({$1,$2,$3}); $$ = node;}           

// case_constant
//             :   condtional_expression                                                                                                                   {Node* node = createNode("case constant"); node->addChildren({$1}); $$ = node;}           

class_instance_creation_expression
            :   NEW_KEYWORD IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one                                              {Value* val = createObject($2->lexeme, $4, global_symtab->current_level); Expression* node = new Expression("class instance creation expression", val, false, false); node->addChildren({$1,$2,$3,$4,$5,$6}); $$ = node;}

// ##############  class_body is ignored for time being  ##################

class_body_zero_or_one
            :   /* empty */                                                                                                                             {Node* node = createNode("class body zero or one"); node->addChildren({}); $$ = node;}           
            |   class_body                                                                                                                              {Node* node = createNode("class body zero or one"); node->addChildren({$1}); $$ = node;}           

argument_list
            :   expression comma_expression_zero_or_more                                                                                                {ExpressionList* node = new ExpressionList("argument list", $1, $2->lists); node->addChildren({$1, $2}); $$ = node;}           

comma_expression_zero_or_more
            :   /* empty */                                                                                                                             {ExpressionList* node = new ExpressionList("comma expression zero or more", NULL, {}); node->addChildren({}); $$ = node;}           
            |   COMMA_OP expression comma_expression_zero_or_more                                                                                       {ExpressionList* node = new ExpressionList("comma expression zero or more", $2, $3->lists); node->addChildren({$1,$2,$3}); $$ = node;}           

assignment
            :   type_name assignment_operators expression                                                                                               {Expression* node = new Expression("assignment", $3->value, false, false); node->addChildren({$1,$2,$3}); $$ = node;}           
        //     |   field_access assignment_operators expression                                                                                            {Node* node = createNode("assignment"); node->addChildren({$1,$2,$3}); $$ = node;}           
        //     |   array_access assignment_operators expression                                                                                            {Node* node = createNode("assignment"); node->addChildren({$1,$2,$3}); $$ = node;}           

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

// array_creation_expression
//             :   NEW_KEYWORD primitive_type dim_expr dim_exprs dims_zero_or_one                                                                          {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
//             |   NEW_KEYWORD primitive_type dims array_initializer                                                                                       {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           
//             |   NEW_KEYWORD type_name dim_expr dim_exprs dims_zero_or_one                                                                              {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}           
//             |   NEW_KEYWORD type_name dims array_initializer                                                                                           {Node* node = createNode("array creation expression"); node->addChildren({$1,$2,$3,$4}); $$ = node;}           

dims_zero_or_one
            :   /* empty */                                                                                                                             {Dims* node = new Dims("dims zero or one", 0); node->addChildren({}); $$ = node;}           
            |   dims                                                                                                                                    {Dims* node = new Dims("dims zero or one", $1->count_dims); node->addChildren({$1}); $$ = node;}           

dim_exprs
            :   /* empty */                                                                                                                             {Node* node = createNode("dim exprs"); node->addChildren({}); $$ = node;}           
            |   dim_exprs dim_expr                                                                                                                      {Node* node = createNode("dim exprs"); node->addChildren({$1,$2}); $$ = node;}           

dim_expr    
            :  OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                                                  {Node* node = createNode("dim expr"); node->addChildren({$1,$2,$3}); $$ = node;}

dims
            :   OP_SQR_BRCKT CLOSE_SQR_BRCKT                                                                                                            {Dims* node = new Dims("dims", 1); node->addChildren({$1,$2}); $$ = node;}
            |   OP_SQR_BRCKT CLOSE_SQR_BRCKT dims                                                                                                       {Dims* node = new Dims("dims", $3->count_dims + 1); node->addChildren({$1,$2,$3}); $$ = node;} 

primitive_type
            :   numeric_type                                                                                                                            {Type* node = new Type("primitive type", $1->primitivetypeIndex); node->addChildren({$1}); $$ = node;}
            |   BOOLEAN_KEYWORD                                                                                                                         {Type* node = new Type("primitive type", 7); node->addChildren({$1}); $$ = node;}

numeric_type
            :   BYTE_KEYWORD                                                                                                                            {Type* node = new Type("numeric type", 0); node->addChildren({$1}); $$ = node;}
            |   SHORT_KEYWORD                                                                                                                           {Type* node = new Type("numeric type", 1); node->addChildren({$1}); $$ = node;}
            |   INT_KEYWORD                                                                                                                             {Type* node = new Type("numeric type", 2); node->addChildren({$1}); $$ = node;}
            |   LONG_KEYWORD                                                                                                                            {Type* node = new Type("numeric type", 3); node->addChildren({$1}); $$ = node;}
            |   CHAR_KEYWORD                                                                                                                            {Type* node = new Type("numeric type", 4); node->addChildren({$1}); $$ = node;}
            |   FLOAT_KEYWORD                                                                                                                           {Type* node = new Type("numeric type", 5); node->addChildren({$1}); $$ = node;}
            |   DOUBLE_KEYWORD                                                                                                                          {Type* node = new Type("numeric type", 6); node->addChildren({$1}); $$ = node;}

array_initializer
            :   OP_CURLY_BRCKT variable_initializer_list_zero_or_more CLOSE_CURLY_BRCKT                                                                 {Node* node = createNode("array initializer"); node->addChildren({$1,$2,$3}); $$ = node;}

variable_initializer_list_zero_or_more
            :   /* empty */                                                                                                                             {ExpressionList* node = new ExpressionList("variable initializer list zero or more", NULL, {}); node->addChildren({}); $$ = node;}
            |   variable_initializer_list                                                                                                               {ExpressionList* node = new ExpressionList("variable initializer list zero or more", NULL, $1->lists); node->addChildren({$1}); $$ = node;}

variable_initializer_list
            :   variable_initializer                                                                                                                    {ExpressionList* node = new ExpressionList("variable initializer list", $1, {}); node->addChildren({$1}); $$ = node;}
            |   variable_initializer COMMA_OP variable_initializer_list                                                                                 {ExpressionList* node = new ExpressionList("variable initializer list", $1, $3->lists); node->addChildren({$1,$2,$3}); $$ = node;}

variable_initializer
            :   expression                                                                                                                              {Expression* node = grammar_1("variable initializer", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        //     |   array_initializer                                                                                                                       {Expression* node = grammar_1("variable initializer", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}

type_name
            :   type_name_scoping                                                                                                                             {IdentifiersList* node = new IdentifiersList("type name", "", $1->identifiers); if(!typenameErrorChecking(node, global_symtab->current_level)) YYERROR; $$ = node;}

type_name_scoping
            :   IDENTIFIERS                                                                                                                             {IdentifiersList* node = new IdentifiersList("type name", $1->lexeme, {}); node->addChildren({$1}); $$ = node;}
            |   type_name_scoping DOT_OP IDENTIFIERS                                                                                                            {IdentifiersList* node = new IdentifiersList("type name", $3->lexeme, $1->identifiers); node->addChildren({$1,$2,$3}); $$ = node;}

// ########   MODIFIERS   ########  

modifiers
            :   PUBLIC_KEYWORD                                                                                                                          {Modifier* node = new Modifier(PUBLIC, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   PROTECTED_KEYWORD                                                                                                                       {Modifier* node = new Modifier(PROTECTED, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   PRIVATE_KEYWORD                                                                                                                         {Modifier* node = new Modifier(PRIVATE, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   ABSTRACT_KEYWORD                                                                                                                        {Modifier* node = new Modifier(ABSTRACT, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   STATIC_KEYWORD                                                                                                                          {Modifier* node = new Modifier(STATIC, "modifiers"); node->addChildren({$1}); $$ = node;}
        //     |   SEALED_KEYWORD                                                                                                                          {Modifier* node = new Modifier(SEALED, "modifiers"); node->addChildren({$1}); $$ = node;}
        //     |   NONSEALED_KEYWORD                                                                                                                       {Modifier* node = new Modifier(NONSEALED, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   STRICTFP_KEYWORD                                                                                                                        {Modifier* node = new Modifier(STRICTFP, "modifiers"); node->addChildren({$1}); $$ = node;}
        //     |   TRANSITIVE_KEYWORD                                                                                                                      {Modifier* node = new Modifier(TRANSITIVE, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   FINAL_KEYWORD                                                                                                                           {Modifier* node = new Modifier(FINAL, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   VOLATILE_KEYWORD                                                                                                                        {Modifier* node = new Modifier(VOLATILE, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   SYNCHRONIZED_KEYWORD                                                                                                                    {Modifier* node = new Modifier(SYNCHRONIZED, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   TRANSIENT_KEYWORD                                                                                                                       {Modifier* node = new Modifier(TRANSIENT, "modifiers"); node->addChildren({$1}); $$ = node;}
            |   NATIVE_KEYWORD                                                                                                                          {Modifier* node = new Modifier(NATIVE, "modifiers"); node->addChildren({$1}); $$ = node;}

modifiers_zero_or_more
            :   /* empty */                                                                                                                             {ModifierList* node = new ModifierList("modifiers zero or more", NULL, {}); node->addChildren({}); $$ = node;}
            |   modifiers modifiers_zero_or_more                                                                                                        {ModifierList* node = new ModifierList("modifiers zero or more", $1, $2->lists); node->addChildren({$1,$2}); $$ = node;}


//  ########   BLOCKS, STATEMENTS AND PATTERNS   ########  

block
        :   OP_CURLY_BRCKT block_statements_zero_or_one CLOSE_CURLY_BRCKT                                                                               {Node* node = createNode("block"); node->addChildren({$1,$2,$3}); node->parent_level = $1->parent_level; $$ = node;}

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

local_variable_declaration_statement
        :   local_variable_declaration SEMICOLON_OP                                                                                                     {Node* node = createNode("local variable declaration statemen"); node->addChildren({$1,$2}); $$ = node;}

local_variable_declaration
        :   unann_type variable_declarator_list                                                                                                         {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2}); addVariablesToSymtab($1, $2, global_symtab->current_level, NULL, false); $$ = node;}
        // |   FINAL_KEYWORD unann_type variable_declarator_list                                                                                           {Node* node = createNode("local variable declaration"); node->addChildren({$1,$2,$3}); $$ = node;}

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
        // |   switch_statement                                                                                                                            {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   do_statememt                                                                                                                                {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   break_statement                                                                                                                             {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   continue_statement                                                                                                                          {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   return_statement                                                                                                                            {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   synchronized_statement                                                                                                                      {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}
        |   throw_statement                                                                                                                             {Node* node = createNode("statement without trailing substatement"); node->addChildren({$1}); $$ = node;}

// switch_statement
//         :   switch_expression                                                                                                                           {Node* node = createNode("switch statement"); node->addChildren({$1}); $$ = node;}

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
        :  assignment                                                                                                                                   {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        |  pre_increment_expression                                                                                                                     {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        |  pre_decrement_expression                                                                                                                     {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        |  post_increment_expression                                                                                                                    {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        |  post_decrement_expression                                                                                                                    {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        // |  method_invocation                                                                                                                            {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}
        |  class_instance_creation_expression                                                                                                           {Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}

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
        : /* empty */                                                                                                                                   {Expression* node = new Expression("expression zero or one", NULL, false, false); node->addChildren({}); $$ = node;}
        |  expression                                                                                                                                   {Expression* node = grammar_1("expression zero or one", $1, $1->isPrimary, $1->isLiteral); node->addChildren({$1}); $$ = node;}

for_update_zero_or_one
        :  /* empty */                                                                                                                                  {Node* node = createNode("for update zero or one"); node->addChildren({}); $$ = node;}
        |  for_update                                                                                                                                   {Node* node = createNode("for update zero or one"); node->addChildren({$1}); $$ = node;}

for_init
        :  statement_expression_list                                                                                                                    {Node* node = createNode("for init"); node->addChildren({$1}); $$ = node;}
        |  local_variable_declaration                                                                                                                   {Node* node = createNode("for init"); node->addChildren({$1}); $$ = node;}

for_update
        :  statement_expression_list                                                                                                                    {ExpressionList* node = new ExpressionList("for update", NULL, $1->lists); node->addChildren({$1}); $$ = node;}

statement_expression_list
        :  statement_expression comma_statement_expression_zero_or_more                                                                                 {ExpressionList* node = new ExpressionList("statement expression list", $1, $2->lists); node->addChildren({$1,$2}); $$ = node;}

comma_statement_expression_zero_or_more
        :  /* empty */                                                                                                                                  {ExpressionList* node = new ExpressionList("comma statement expression zero or more", NULL, {}); node->addChildren({}); $$ = node;}
        |  COMMA_OP statement_expression comma_statement_expression_zero_or_more                                                                        {ExpressionList* node = new ExpressionList("comma statement expression zero or more", $2, $3->lists); node->addChildren({$1,$2,$3}); $$ = node;}

enhanced_for_statement
        :  FOR_KEYWORD OP_BRCKT local_variable_declaration COLON_OP expression CLOSE_BRCKT statement                                                    {Node* node = createNode("enhanced for statement"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

enhanced_for_statement_no_short_if
        :  FOR_KEYWORD OP_BRCKT local_variable_declaration COLON_OP expression CLOSE_BRCKT statement_no_short_if                                        {Node* node = createNode("enhanced for statement no short if"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

break_statement
        :  BREAK_KEYWORD IDENTIFIERS SEMICOLON_OP                                                                                                       {Node* node = createNode("break statement"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  BREAK_KEYWORD SEMICOLON_OP                                                                                                                   {Node* node = createNode("break statement"); node->addChildren({$1,$2}); $$ = node;}

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


//  ########   CLASSES   ########  

class_declaration
        :  normal_class_declaration                                                                                                                     {Node* node = createNode("class declaration"); node->addChildren({$1}); $$ = node;}

normal_class_declaration
        :  normal_class_declaration_statement class_body                                                                                                {Node* node = createNode("normal_class_declaration"); ((LocalSymbolTable*)((global_symtab->symbol_tables)[$2->parent_level.first][$2->parent_level.second]))->level_node = (Node*)($1); node->addChildren({$1,$2}); $$ = node;}

normal_class_declaration_statement
        :  modifiers_zero_or_more CLASS_KEYWORD IDENTIFIERS class_extends_zero_or_one                                                                   {NormalClassDeclaration* node = new NormalClassDeclaration("normal class declaration statement", $1, $3->lexeme); node->line_no = $2->line_no; node->entry_type = CLASS_DECLARATION; node->addChildren({$1,$2,$3,$4}); get_local_symtab(global_symtab->current_level)->add_entry(node); $$ = node;}

class_extends_zero_or_one
        :   /* empty */                                                                                                                                 {Node* node = createNode("class extends zero or one"); node->addChildren({}); $$ = node;}
        |  class_extends                                                                                                                                {Node* node = createNode("class extends zero or one"); node->addChildren({$1}); $$ = node;}

class_extends
        :  EXTENDS_KEYWORD IDENTIFIERS                                                                                                                   {Node* node = createNode("class extends"); node->addChildren({$1,$2}); $$ = node;}

class_body
        :  OP_CURLY_BRCKT class_body_declaration_zero_or_more CLOSE_CURLY_BRCKT                                                                         {Node* node = createNode("class body"); node->addChildren({$1,$2,$3}); node->parent_level = $1->parent_level; $$ = node;}

class_body_declaration_zero_or_more
        :   /* empty */                                                                                                                                 {Node* node = createNode("class body declaration zero or more"); node->addChildren({}); $$ = node;}
        |  class_body_declaration class_body_declaration_zero_or_more                                                                                   {Node* node = createNode("class body declaration zero or more"); node->addChildren({$1,$2}); $$ = node;}

class_body_declaration
        :  constructor_declaration                                                                                                                      {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  block                                                                                                                                        {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  static_initializer                                                                                                                           {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  field_declaration                                                                                                                            {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}
        |  method_declaration                                                                                                                           {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}              
        |  SEMICOLON_OP                                                                                                                                 {Node* node = createNode("class body declaration"); node->addChildren({$1}); $$ = node;}

field_declaration
        :  modifiers_zero_or_more unann_type variable_declarator_list SEMICOLON_OP                                                                      {Node* node = createNode("field declaration"); addVariablesToSymtab($2, $3, global_symtab->current_level, $1, true); node->addChildren({$1,$2,$3,$4}); $$ = node;}

variable_declarator_list
        :  variable_declarator comma_variable_declarator_zero_or_more                                                                                   {VariableDeclaratorList* node = new VariableDeclaratorList("variable declarator list", $1, $2->lists); node->addChildren({$1,$2}); $$ = node;}

comma_variable_declarator_zero_or_more
        :  /* empty */                                                                                                                                  {VariableDeclaratorList* node = new VariableDeclaratorList("comma variable declarator zero or more", NULL, {}); node->addChildren({}); $$ = node;}
        |  comma_variable_declarator_zero_or_more COMMA_OP variable_declarator                                                                          {VariableDeclaratorList* node = new VariableDeclaratorList("comma variable declarator zero or more", $3, $1->lists); node->addChildren({$1,$2,$3}); $$ = node;}

variable_declarator
        :  variable_declarator_id                                                                                                                       {VariableDeclaratorId* node = new VariableDeclaratorId("variable_declarator", $1->identifier, $1->num_of_dims, NULL); node->addChildren({$1}); $$ = node;}
        |  variable_declarator_id ASSIGNMENT_OP variable_initializer                                                                                    {VariableDeclaratorId* node = new VariableDeclaratorId("variable_declarator", $1->identifier, $1->num_of_dims, $3->value); node->addChildren({$1,$2,$3}); $$ = node;}

variable_declarator_id
        :  IDENTIFIERS dims_zero_or_one                                                                                                                 {VariableDeclaratorId* node = new VariableDeclaratorId("variable declarator id", $1->lexeme, $2->count_dims, NULL); node->addChildren({$1,$2}); $$ = node;}

unann_type
        :  primitive_type                                                                                                                               {Type* node = new Type("unann type", $1->primitivetypeIndex); node->addChildren({$1}); $$ = node;}
        |  type_name                                                                                                                                    {Type* node = new Type("unann type", -1); node->class_instantiated_from = get_local_symtab(global_symtab->current_level)->get_entry($1->identifiers[0], -1); node->addChildren({$1}); $$ = node;}

method_declaration
        :  modifiers_zero_or_more method_header block                                                                                                   {MethodDeclaration* node = new MethodDeclaration("method_declaration"); node->name = $2->name; node->formal_parameter_list = $2->formal_parameter_list; node->type = $2->type; node->modifiers = $2->modifiers; node->addChildren({$1,$2,$3}); node->entry_type = METHOD_DECLARATION; get_local_symtab(global_symtab->current_level)->add_entry(node); ((LocalSymbolTable*)((global_symtab->symbol_tables)[$3->parent_level.first][$3->parent_level.second]))->level_node = (Node*)(node); $$ = node;}
        |  modifiers_zero_or_more method_header SEMICOLON_OP                                                                                            {MethodDeclaration* node = new MethodDeclaration("method_declaration"); node->name = $2->name; node->formal_parameter_list = $2->formal_parameter_list; node->type = $2->type; node->modifiers = $2->modifiers; node->addChildren({$1,$2,$3}); node->entry_type = METHOD_DECLARATION; get_local_symtab(global_symtab->current_level)->add_entry(node); $$ = node;}

method_header
        :  unann_type method_declarator                                                                                                                 {MethodDeclaration* node = new MethodDeclaration("method_header"); node->name = $2->name; node->formal_parameter_list = $2->formal_parameter_list; node->type = $1;  node->addChildren({$1,$2}); $$ = node;}
        |  VOID_KEYWORD method_declarator                                                                                                               {Type* t = new Type("result", 8); MethodDeclaration* node = new MethodDeclaration("method_header"); node->name = $2->name; node->formal_parameter_list = $2->formal_parameter_list; node->type = t; node->addChildren({$1,$2}); $$ = node;}

method_declarator
        :  IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT dims_zero_or_one                                                          {MethodDeclaration* node = new MethodDeclaration("method declarator"); node->name = $1->lexeme; node->formal_parameter_list = $3; node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        // |  IDENTIFIERS OP_BRCKT reciever_parameter COMMA_OP formal_parameter_list_zero_or_one CLOSE_BRCKT dims_zero_or_one                              {Node* node = createNode("method declarator"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

formal_parameter_list_zero_or_one
        :   /* empty */                                                                                                                                 {FormalParameterList* node = new FormalParameterList("formal parameter list zero or one", NULL, {}); node->addChildren({}); $$ = node;}
        |  formal_parameter_list                                                                                                                        {FormalParameterList* node = new FormalParameterList("formal parameter list zero or one", NULL, $1->lists); node->addChildren({$1}); $$ = node;}

formal_parameter_list
        :  formal_parameter                                                                                                                             {FormalParameterList* node = new FormalParameterList("formal parameter list", $1, {}); node->addChildren({$1}); $$ = node;}
        |  formal_parameter COMMA_OP formal_parameter_list                                                                                              {FormalParameterList* node = new FormalParameterList("formal parameter list", $1, $3->lists); node->addChildren({$1,$2,$3}); $$ = node;}

formal_parameter
        :  unann_type variable_declarator_id                                                                                                            {FormalParameter* node = new FormalParameter("formal parameter", $1, $2, false); node->addChildren({$1,$2}); $$ = node;}
        |  FINAL_KEYWORD unann_type variable_declarator_id                                                                                              {FormalParameter* node = new FormalParameter("formal parameter", $2, $3, true); node->addChildren({$1,$2,$3}); $$ = node;}

static_initializer
        :  STATIC_KEYWORD block                                                                                                                         {Node* node = createNode("static initializer"); node->addChildren({$1,$2}); $$ = node;}

constructor_declaration
        :  modifiers_zero_or_more constructor_declarator constructor_body                                                                                  {MethodDeclaration* node = new MethodDeclaration("constructor_declaration"); node->name = $2->name; node->formal_parameter_list = $2->formal_parameter_list; node->modifiers = $1; node->entry_type = METHOD_DECLARATION; node->isConstructor = true; node->addChildren({$1,$2,$3}); get_local_symtab(global_symtab->current_level)->add_entry(node); $$ = node;}

constructor_declarator
        :  IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT                                                                           {MethodDeclaration* node = new MethodDeclaration("constructor declarator"); node->name = $1->lexeme; node->formal_parameter_list = $3;  node->addChildren({$1,$2,$3,$4}); $$ = node;}

constructor_body
        :  OP_CURLY_BRCKT explicit_constructor_invocation CLOSE_CURLY_BRCKT                                                                             {Node* node = createNode("constructor body"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  OP_CURLY_BRCKT block_statements CLOSE_CURLY_BRCKT                                                                                            {Node* node = createNode("constructor body"); node->addChildren({$1,$2,$3}); $$ = node;}
        |  OP_CURLY_BRCKT explicit_constructor_invocation block_statements CLOSE_CURLY_BRCKT                                                            {Node* node = createNode("constructor body"); node->addChildren({$1,$2,$3,$4}); $$ = node;}
        |  OP_CURLY_BRCKT CLOSE_CURLY_BRCKT                                                                                                             {Node* node = createNode("constructor body"); node->addChildren({$1,$2}); $$ = node;}

explicit_constructor_invocation
        :  THIS_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                                     {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}
        |  SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                                    {Node* node = createNode("explicit constructor invocation"); node->addChildren({$1,$2,$3,$4,$5}); $$ = node;}

argument_list_zero_or_one
        :   /* empty */                                                                                                                                 {ExpressionList* node = new ExpressionList("argument list zero or one", NULL, {}); node->addChildren({}); $$ = node;} 
        |  argument_list                                                                                                                                {ExpressionList* node = new ExpressionList("argument list zero or one", NULL, $1->lists); node->addChildren({$1}); $$ = node;}

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
        :       '('                                                     {Node* temp = createNode($1); temp->isTerminal = true; global_symtab->increase_level(); $$ = temp;}
CLOSE_BRCKT
        :       ')'                                                     {Node* temp = createNode($1); temp->isTerminal = true; global_symtab->decrease_level(); $$ = temp;}
OP_SQR_BRCKT
        :       '['                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
CLOSE_SQR_BRCKT
        :       ']'                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}
OP_CURLY_BRCKT
        :       '{'                                                     {Node* temp = createNode($1); temp->isTerminal = true; global_symtab->increase_level(); temp->parent_level = global_symtab->current_level; $$ = temp;}
CLOSE_CURLY_BRCKT
        :       '}'                                                     {Node* temp = createNode($1); temp->isTerminal = true; global_symtab->decrease_level(); $$ = temp;}

ABSTRACT_KEYWORD
        :       abstract_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CONTINUE_KEYWORD
        :       continue_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true;$$ = temp;}

FOR_KEYWORD
        :       for_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

NEW_KEYWORD
        :       new_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// SWITCH_KEYWORD
//         :       switch_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ASSERT_KEYWORD
        :       assert_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// DEFAULT_KEYWORD
//         :       default_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

IF_KEYWORD
        :       if_keyword_terminal                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// PACKAGE_KEYWORD
//         :       package_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

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

// IMPLEMENTS_KEYWORD
//         :       implements_keyword_terminal                                             {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PROTECTED_KEYWORD
        :       protected_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

THROW_KEYWORD
        :       throw_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

BYTE_KEYWORD
        :       byte_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

ELSE_KEYWORD
        :       else_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// IMPORT_KEYWORD
//         :       import_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

PUBLIC_KEYWORD
        :       public_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// THROWS_KEYWORD
//         :       throws_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// CASE_KEYWORD
//         :       case_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// ENUM_KEYWORD
//         :       enum_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true;  $$ = temp;}

// INSTANCEOF_KEYWORD
//         :       instanceof_keyword_terminal                                             {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

RETURN_KEYWORD
        :       return_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

TRANSIENT_KEYWORD
        :       transient_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// CATCH_KEYWORD
//         :       catch_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

EXTENDS_KEYWORD
        :       extends_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

INT_KEYWORD
        :       int_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

SHORT_KEYWORD
        :       short_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// TRY_KEYWORD
//         :       try_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CHAR_KEYWORD
        :       char_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

FINAL_KEYWORD
        :       final_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// INTERFACE_KEYWORD
//         :       interface_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

STATIC_KEYWORD
        :       static_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

VOID_KEYWORD
        :       void_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

CLASS_KEYWORD
        :       class_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// FINALLY_KEYWORD
//         :       finally_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

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

// EXPORTS_KEYWORD
//         :       exports_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// OPENS_KEYWORD
//         :       opens_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// REQUIRES_KEYWORD
//         :       requires_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// USES_KEYWORD
//         :       uses_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// MODULE_KEYWORD
//         :       module_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// PERMITS_KEYWORD
//         :       permits_keyword_terminal                                                {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// SEALED_KEYWORD
//         :       sealed_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// VAR_KEYWORD
//         :       var_keyword_terminal                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// NONSEALED_KEYWORD
//         :       nonsealed_keyword_terminal                                              {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// PROVIDES_KEYWORD
//         :       provides_keyword_terminal                                               {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// TO_KEYWORD
//         :       to_keyword_terminal                                                     {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// WITH_KEYWORD
//         :       with_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// OPEN_KEYWORD
//         :       open_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// RECORD_KEYWORD
//         :       record_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// TRANSITIVE_KEYWORD
//         :       transitive_keyword_terminal                                             {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// YIELD_KEYWORD
//         :       yield_keyword_terminal                                                  {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

// PTR_OP
//         :       PTR_OP_TERMINAL                                                         {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

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

IDENTIFIERS
        :       IDENTIFIERS_TERMINAL                                                    {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

LITERALS
        :       NUM_LITERALS                                                            {Value* va = new Value(); va->num_val.push_back(strtol($1, NULL, 10)); Expression* temp = new Expression($1, va, true, true);  temp->isTerminal = true; $$ = temp;}
        |       DOUBLE_LITERALS                                                         {Value* va = new Value(); va->double_val.push_back(strtod($1, NULL)); Expression* temp = new Expression($1, va, true, true);  temp->isTerminal = true; $$ = temp;}
        |       STRING_LITERALS                                                         {Value* va = new Value(); va->string_val.push_back($1); Expression* temp = new Expression($1, va, true, true);  temp->isTerminal = true; $$ = temp;}
        |       CHAR_LITERALS                                                           {Value* va = new Value(); va->string_val.push_back($1); Expression* temp = new Expression($1, va, true, true); temp->value->is_char_val = true; temp->isTerminal = true; $$ = temp;}

%%

int main(int argc, char **argv){
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
    if (strcmp(token_in, "--input") != 0){
        printf("Usage: %s [--input=<input_file_name> --output=<output_file_name>][--verbose]\n", argv[0]);
        printf("--verbose is an optional flag ...\n");
        return 0;
    }
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
    if (strcmp(token_out, "--output") != 0){
        printf("Usage: %s [--input=<input_file_name> --output=<output_file_name>][--verbose]\n", argv[0]);
        printf("--verbose is an optional flag ...\n");
        return 0;
    }
    // loop through the string to extract all other tokens
    while( token_out != NULL ) {
       strcpy(output_file, token_out);
       token_out = strtok(NULL, "=");
    }
    LocalSymbolTable* locale = new LocalSymbolTable({0,0}, NULL);
    global_symtab->symbol_tables[0][0] = locale;
    yyparse();
    fclose(yyin);
    generate3AC();
    return 0;
}

void yyerror (char const *s) {
  printf("\nerror: %s. Line number %d\n\n", s, yylineno);
}