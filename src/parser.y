%{
    #include <stdio.h>
    #include <string.h>
    #include "inc/helper.h"
    #include "inc/3ac.h"
    #define YYDEBUG 1
    int yylex(void);
    void yyerror(char const*);
    int functionOffset = 8;
    extern int yylineno;
    extern vector<string> typeStrings;
    GlobalSymbolTable* global_symtab = new GlobalSymbolTable();
    vector<bool> temporary_registors_in_use(MAX_REGISTORS, false);
    vector<int> typeSizes = {1, 1, 2, 4, 8, 4, 8, 1, -1, 0};
    vector<string> calleeSavedRegistors = {"%r12", "%rbx", "%r10", "%r13", "%r14", "%r15"};
    vector<string> smallCalleeSavedRegistors = {"%r12b", "%bl", "%r10b", "%r13b", "%r14b", "%r15b"};
    vector<bool> calleeSavedInUse(calleeSavedRegistors.size(), false);
    vector<bool> calleeGlobalCalled(calleeSavedRegistors.size(), false);
    vector<string> argumentRegistors = {"%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"};
    int break_posn = -1;
    int continue_posn = -1;
    vector<ThreeAC*> threeAC_list;
    int label_count = 1;
    int alternate_label_count = 1111;
    map<string, int> caches;
    int stack_frame_pointer = 0;
    NormalClassDeclaration* curr_class;
    int curr_address = 0;
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

%token<lex_val> string_keyword_terminal goto_keyword_terminal const_keyword_terminal __keyword_terminal do_keyword_terminal system_keyword_terminal out_keyword_terminal println_keyword_terminal abstract_keyword_terminal continue_keyword_terminal for_keyword_terminal new_keyword_terminal default_keyword_terminal if_keyword_terminal boolean_keyword_terminal private_keyword_terminal this_keyword_terminal break_keyword_terminal double_keyword_terminal implements_keyword_terminal protected_keyword_terminal byte_keyword_terminal else_keyword_terminal public_keyword_terminal return_keyword_terminal transient_keyword_terminal extends_keyword_terminal int_keyword_terminal short_keyword_terminal char_keyword_terminal final_keyword_terminal static_keyword_terminal void_keyword_terminal class_keyword_terminal long_keyword_terminal strictfp_keyword_terminal volatile_keyword_terminal float_keyword_terminal native_keyword_terminal super_keyword_terminal while_keyword_terminal record_keyword_terminal
%token<lex_val> '=' '>' '<' '!' '~' '?' ':' '+' '-' '*' '/' '&' '|' '^' '%' ',' '.' ';' '(' ')' '[' ']' '{' '}' '@'
%token<lex_val> EQ_OP_TERMINAL GE_OP_TERMINAL LE_OP_TERMINAL NE_OP_TERMINAL AND_OP_TERMINAL OR_OP_TERMINAL INC_OP_TERMINAL DEC_OP_TERMINAL LEFT_OP_TERMINAL RIGHT_OP_TERMINAL BIT_RIGHT_SHFT_OP_TERMINAL ADD_ASSIGN_TERMINAL SUB_ASSIGN_TERMINAL MUL_ASSIGN_TERMINAL DIV_ASSIGN_TERMINAL AND_ASSIGN_TERMINAL OR_ASSIGN_TERMINAL XOR_ASSIGN_TERMINAL MOD_ASSIGN_TERMINAL LEFT_ASSIGN_TERMINAL RIGHT_ASSIGN_TERMINAL BIT_RIGHT_SHFT_ASSIGN_TERMINAL
%token<lex_val> IDENTIFIERS_TERMINAL NUM_LITERALS DOUBLE_LITERALS STRING_LITERALS CHAR_LITERALS BOOLEAN_LITERALS

%left AND_OP_TERMINAL
%left OR_OP_TERMINAL
%left EQ_OP_TERMINAL NE_OP_TERMINAL
%left RIGHT_OP_TERMINAL LEFT_OP_TERMINAL
%left INC_OP_TERMINAL DEC_OP_TERMINAL

%type<node> STRING_KEYWORD DO_KEYWORD SYSTEM_KEYWORD OUT_KEYWORD PRINTLN_KEYWORD ABSTRACT_KEYWORD CONTINUE_KEYWORD FOR_KEYWORD NEW_KEYWORD IF_KEYWORD BOOLEAN_KEYWORD PRIVATE_KEYWORD THIS_KEYWORD BREAK_KEYWORD DOUBLE_KEYWORD PROTECTED_KEYWORD EXTENDS_KEYWORD BYTE_KEYWORD ELSE_KEYWORD PUBLIC_KEYWORD RETURN_KEYWORD TRANSIENT_KEYWORD INT_KEYWORD SHORT_KEYWORD CHAR_KEYWORD FINAL_KEYWORD STATIC_KEYWORD VOID_KEYWORD CLASS_KEYWORD LONG_KEYWORD STRICTFP_KEYWORD VOLATILE_KEYWORD FLOAT_KEYWORD NATIVE_KEYWORD SUPER_KEYWORD WHILE_KEYWORD
%type<node> ASSIGNMENT_OP GT_OP LT_OP EX_OP TL_OP QN_OP COLON_OP PLUS_OP MINUS_OP STAR_OP DIV_OP ND_OP BAR_OP RAISE_OP PCNT_OP COMMA_OP DOT_OP SEMICOLON_OP OP_BRCKT CLOSE_BRCKT OP_SQR_BRCKT CLOSE_SQR_BRCKT OP_CURLY_BRCKT CLOSE_CURLY_BRCKT
%type<node> EQ_OP GE_OP  LE_OP  NE_OP  AND_OP  OR_OP  INC_OP  DEC_OP  LEFT_OP  RIGHT_OP  BIT_RIGHT_SHFT_OP ADD_ASSIGN  SUB_ASSIGN  MUL_ASSIGN  DIV_ASSIGN  AND_ASSIGN  OR_ASSIGN  XOR_ASSIGN  MOD_ASSIGN  LEFT_ASSIGN  RIGHT_ASSIGN  BIT_RIGHT_SHFT_ASSIGN
%type<node> IDENTIFIERS

%type<node> print_statement expression_statement normal_class_declaration_statement assignment_operators basic_for_statement basic_for_statement_no_short_if block block_statement block_statements block_statements_zero_or_more block_statements_zero_or_one break_statement class_body class_body_declaration class_body_declaration_zero_or_more class_body_zero_or_one class_declaration class_extends class_extends_zero_or_one compilation_unit constructor_body continue_statement do_statememt empty_statement explicit_constructor_invocation field_declaration for_init for_init_zero_or_one for_statement for_statement_no_short_if for_update for_update_zero_or_one if_then_else_statement if_then_else_statement_no_short_if if_then_statement labeled_statement labeled_statement_no_short_if local_class_or_interface_declaration local_variable_declaration local_variable_declaration_statement normal_class_declaration ordinary_compilation_unit return_statement start_state statement  statement_no_short_if statement_without_trailing_substatement static_initializer top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more while_statement while_statement_no_short_if
%type<expression> argument_expression array_creation_expression assignment LITERALS array_access class_instance_creation_expression additive_expression and_expression assignment_expression unary_expression unary_expression_not_plus_minus statement_expression conditional_and_expression conditional_or_expression condtional_expression equality_expression exclusive_or_expression expression expression_zero_or_one inclusive_or_expression multiplicative_expression post_decrement_expression post_increment_expression postfix_expression pre_decrement_expression pre_increment_expression primary primary_no_new_array relational_expression shift_expression variable_initializer field_access method_invocation
%type<expression_list> argument_list statement_expression_list argument_list_zero_or_one comma_expression_zero_or_more comma_statement_expression_zero_or_more
%type<formal_parameter> formal_parameter 
%type<formal_parameter_list> formal_parameter_list formal_parameter_list_zero_or_one
%type<modifier_list> modifiers_one_or_more
%type<modifier> modifiers
%type<type> unann_type primitive_type numeric_type
%type<method_declaration> method_declaration method_declaration_statement constructor_declaration constructor_declarator method_header method_declarator
%type<variable_declarator_id> variable_declarator_id variable_declarator
%type<variable_declarator_list> variable_declarator_list comma_variable_declarator_zero_or_more
%type<dims> dims dims_zero_or_one
%type<identifiers_list> type_name type_name_scoping

%% 

//  ########   COMPILATION UNIT   ########  

start_state 
            :   compilation_unit                                                       
            {
                $$ = $1; 
                // create3ACCode($$, true); 
                cout<<".LC0:\n";
                cout<<"\t.text\n";
                cout<<"\t.string\t\"%lld\\n\"\n";
                createAsm($$);
                // createAST($$, output_file);
            }

compilation_unit
            :   ordinary_compilation_unit                                              
            {   
                Node* node = createNode("compilation unit"); 
                node->addChildren({$1}); 
                $$ = node;
            }

ordinary_compilation_unit
            :   top_level_class_or_interface_declaration_zero_or_more                                                                           
            {
                Node* node = createNode("ordinary compilation unit"); 
                node->addChildren({$1}); 
                $$ = node;
            }

top_level_class_or_interface_declaration_zero_or_more
            :   /* empty */                                                                                                                     
            {
                Node* node = createNode("top level class or interface declaration zero or more"); 
                $$ = node;
            } 
            |   top_level_class_or_interface_declaration top_level_class_or_interface_declaration_zero_or_more                                  
            {
                Node* node = createNode("top level class or interface declaration zero or more"); 
                node->addChildren({$1, $2}); 
                $$ = node;
            }

top_level_class_or_interface_declaration
            :   class_declaration                                                                                                               
            {
                Node* node = createNode("top level class or interface declaration"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   SEMICOLON_OP                                                                                                                    
            {
                Node* node = createNode("top level class or interface declaration"); 
                node->addChildren({$1}); 
                $$ = node;
            }

//  ########   EXPRESSIONS   ########  

primary
            :   primary_no_new_array                                                                                                            
            {
                Expression* node = grammar_1("primary",$1, $1->isPrimary, $1->isLiteral); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   array_creation_expression                                                                                                       
            {
                Expression* node = grammar_1("primary",$1, $1->isPrimary, $1->isLiteral); 
                node->addChildren({$1}); 
                $$ = node;
            }

primary_no_new_array
            :   LITERALS                                                                                                                        
            {
                Expression* node = grammar_1("primary no new array", $1, $1->isPrimary, $1->isLiteral); 
                node->primary_exp_val = $1->lexeme; 
                assignLiteralValue($1, node);
                node->addChildren({$1}); 
                int n = findEmptyCalleeSavedRegistor();
                node->calleeSavedRegistorIndex = n;
                calleeSavedInUse[n] = true;
                if($1->value->primitivetypeIndex == BOOLEAN)
                    node->x86_64.push_back("movq\t$" + to_string($1->value->boolean_val[0]) + "," + calleeSavedRegistors[n]);
                else
                    node->x86_64.push_back("movq\t$" + $1->lexeme + "," + calleeSavedRegistors[n]);
                $$ = node;
            }
            |   class_instance_creation_expression                                                                                              
            {
                Expression* node = grammar_1("primary no new array", $1, false, false); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   OP_BRCKT expression CLOSE_BRCKT                                                                                                 
            {
                Expression* node = grammar_1("primary no new array", $2, $2->isPrimary, $2->isLiteral); 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }
            |   method_invocation                                                                                                               
            {
                Expression* node = grammar_1("primary no new array", $1, true, false); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   field_access                                                                                                                    
            {
                Expression* node = grammar_1("primary no new array", $1, $1->isPrimary, $1->isLiteral); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   array_access                                                                                                                    
            {   
                Expression* node = grammar_1("primary no new array", $1, $1->isPrimary, $1->isLiteral); 
                node->addChildren({$1}); 
                $$ = node;
            }
            // |   THIS_KEYWORD                                                                                                                    
            // {   Expression* node = grammar_1("primary no new array",$1, $1->isPrimary, $1->isLiteral); 
            //     node->addChildren({$1}); 
            //     $$ = node;
            // }

field_access
            :   IDENTIFIERS DOT_OP type_name_scoping                                                                                            
            {
                IdentifiersList* temp = new IdentifiersList("type_name", $1->lexeme, $3->identifiers); 
                if(!typenameErrorChecking(temp, global_symtab->current_level, 0)) 
                    YYERROR; 
                Value* va = new Value(); 
                Expression* node = new Expression("postfix expression", va, true, false);
                va->primitivetypeIndex = ((LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($3->identifiers[0], 0)))->type->primitivetypeIndex;
                node->name = $3->identifiers[0];
                if(caches.find(temp->createString())==caches.end()){
                    int tt = findEmptyRegistor();
                    temporary_registors_in_use[tt] = true;
                    LocalVariableDeclaration* temp2 = ((LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, 0)));
                    int regtt = temp2->reg_index;
                    int offset = -1;
                    for(int i=0;i<curr_class->field_variables.size();i++){
                        if(curr_class->field_variables[i].first->name == $3->identifiers[0]) {
                            offset = curr_class->field_variables[i].second;
                            break;
                        }
                    }
                    ThreeAC* inst = new ThreeAC("+", "", tt, regtt, -1, "", to_string(offset), 0);
                    node->code.push_back(threeAC_list.size());
                    threeAC_list.push_back(inst);
                    node->primary_exp_val = "*t" + to_string(tt); 
                    caches.insert({temp->createString(), tt});
                }
                else{
                    node->primary_exp_val = "t" + to_string(caches[temp->createString()]);
                }
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }
            // |   THIS_KEYWORD DOT_OP IDENTIFIERS                                                                                                
            // {   
            //     Node* node = createNode("field access"); 
            //     node->addChildren({$1,$2,$3}); 
            //     $$ = node;
            // }

array_access
            :   type_name_scoping OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                               
            {
                Expression* node = getArrayAccess($1->identifiers[0], $3);
                if(node == NULL)
                    YYERROR;
                node->addChildren({$1,$2,$3,$4}); 
                $$ = node;
            }

method_invocation
            :   IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                                    
            {
                IdentifiersList* temp = new IdentifiersList("type_name", $1->lexeme, {});                                    
                if(!typenameErrorChecking(temp, global_symtab->current_level, -1)) 
                    YYERROR; 
                Value* va = new Value(); 
                va->primitivetypeIndex = ((MethodDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, -1)))->type->primitivetypeIndex; 
                Expression* node = new Expression("postfix expression", va, false, false); 
                if(node == NULL) 
                    YYERROR; 
                if(!checkParams($1->lexeme, $3))
                    YYERROR;
                node->name = temp->createString(); 
                node->entry_type = METHOD_INVOCATION; 
                int n = findEmptyCalleeSavedRegistor();
                node->calleeSavedRegistorIndex = n;
                calleeSavedInUse[n] = true;
                node->x86_64.push_back("movq\t%rax, " + calleeSavedRegistors[n]);
                int tx = findEmptyRegistor();
                temporary_registors_in_use[tx] = true;
                node->reg_index = tx;
                node->registor_index = tx;
                node->primary_exp_val = "t" + to_string(tx);
                node->addChildren({$1,$2,$3,$4}); 
                $$ = node;
            }
            // |   field_access OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT                                                                    
            // {
            //     IdentifiersList* temp = new IdentifiersList("type_name", "", {}); 
            //     temp->addIdentifiers($1->primary_exp_val); 
            //     if(!typenameErrorChecking(temp, global_symtab->current_level, -1)) 
            //         YYERROR; 
            //     Value* va = new Value(); 
            //     va->primitivetypeIndex = ((MethodDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, -1)))->type->primitivetypeIndex; 
            //     Expression* node = new Expression("postfix expression", va, false, false); 
            //     if(node == NULL) 
            //         YYERROR; 
            //     node->name = temp->createString(); 
            //     node->entry_type = METHOD_INVOCATION; 
            //     node->addChildren({$1,$2,$3,$4}); 
            //     $$ = node;
            // }

expression
            :   assignment_expression
            {
                Expression* node =grammar_1("expression", $1, $1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           

assignment_expression
            :   condtional_expression
            {
                Expression* node = grammar_1("assignment expression",$1, $1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   assignment                                                                                                                      
            {
                Expression* node = grammar_1("assignment expression",$1, $1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }

condtional_expression
            :   conditional_or_expression                                                                                                       
            {
                Expression* node = grammar_1("condtional expression",$1, $1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   conditional_or_expression QN_OP expression COLON_OP condtional_expression                                                       
            {
                Expression* node = cond_qn_co("condtional expression",$1,$3,$5); 
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3,$4,$5}); 
                node->entry_type = TERNARY_EXPRESSION;   
                $$ = node;
            }           

conditional_or_expression
            :   conditional_and_expression                                                                                                      
            {
                Expression* node = grammar_1("condtional or expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   conditional_or_expression OR_OP conditional_and_expression                                                                      
            {
                Expression* node = evalOR_AND("condtional or expression",$1,"||",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

conditional_and_expression
            :   inclusive_or_expression                                                                                                         
            {
                Expression* node = grammar_1("condtional and expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   conditional_and_expression AND_OP inclusive_or_expression                                                                       
            {
                Expression* node = evalOR_AND("condtional and expression",$1,"&&",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

inclusive_or_expression
            :   exclusive_or_expression                                                                                                         
            {
                Expression* node = grammar_1("inclusive or expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   inclusive_or_expression BAR_OP exclusive_or_expression                                                                          
            {
                Expression* node = evalBITWISE("inclusive or expression",$1,"|",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

exclusive_or_expression
            :   and_expression                                                                                                                  
            {
                Expression* node = grammar_1("exclusive or expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   exclusive_or_expression RAISE_OP and_expression                                                                                 
            {
                Expression* node = evalBITWISE("exclusive or expression",$1,"^",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

and_expression
            :   equality_expression                                                                                                             
            {
                Expression* node = grammar_1("and expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   and_expression ND_OP equality_expression                                                                                        
            {
                Expression* node = evalBITWISE("and expression",$1,"&",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

equality_expression
            :   relational_expression                                                                                                           
            {
                Expression* node = grammar_1("equality expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   equality_expression EQ_OP relational_expression                                                                                 
            {
                Expression* node = evalEQ("equality expression",$1,"==",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   equality_expression NE_OP relational_expression                                                                                 
            {
                Expression* node = evalEQ("equality expression",$1,"!=",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

relational_expression
            :   shift_expression                                                                                                                
            {
                Expression* node = grammar_1("relational expression",$1,$1->isPrimary, $1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   relational_expression LT_OP shift_expression                                                                                    
            {
                Expression* node = evalRELATIONAL("relational expression",$1,"<",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   relational_expression GT_OP shift_expression                                                                                    
            {
                Expression* node = evalRELATIONAL("relational expression",$1,">",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   relational_expression LE_OP shift_expression                                                                                    
            {
                Expression* node = evalRELATIONAL("relational expression",$1,"<=",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   relational_expression GE_OP shift_expression                                                                                    
            {
                Expression* node = evalRELATIONAL("relational expression",$1,">=",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

shift_expression
            :   additive_expression                                                                                                             
            {
                Expression* node = grammar_1("shift expression",$1,$1->isPrimary,$1->isLiteral);
                if(node == NULL)
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   shift_expression LEFT_OP additive_expression                                                                                    
            {
                Expression* node = evalSHIFT("shift expression",$1,"<<",$3);
                if(node == NULL) 
                    YYERROR;  
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   shift_expression RIGHT_OP additive_expression                                                                                   
            {
                Expression* node = evalSHIFT("shift expression",$1,">>",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   shift_expression BIT_RIGHT_SHFT_OP additive_expression                                                                          
            {
                Expression* node = evalSHIFT("shift expression",$1,">>>",$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

additive_expression
            :   multiplicative_expression                                                                                                       
            {
                Expression* node = grammar_1("additive expression",$1,$1->isPrimary,$1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   additive_expression PLUS_OP multiplicative_expression                                                                           
            {
                Expression* node = evalARITHMETIC("additive expression","+",$1,$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   additive_expression MINUS_OP multiplicative_expression                                                                          
            {
                Expression* node = evalARITHMETIC("additive expression","-",$1,$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

multiplicative_expression
            :   unary_expression                                                                                                                
            {
                Expression* node = grammar_1("multiplicative expression",$1,$1->isPrimary,$1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   multiplicative_expression STAR_OP unary_expression                                                                              
            {
                Expression* node = evalARITHMETIC("multiplicative expression","*",$1,$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   multiplicative_expression PCNT_OP unary_expression                                                                              
            {
                Expression* node = evalARITHMETIC("multiplicative expression","%",$1,$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           
            |   multiplicative_expression DIV_OP unary_expression                                                                               
            {
                Expression* node = evalARITHMETIC("multiplicative expression","/",$1,$3);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

unary_expression
            :   pre_increment_expression                                                                                                        
            {
                Expression* node = grammar_1("unary expression",$1,$1->isPrimary,$1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   pre_decrement_expression                                                                                                        
            {
                Expression* node = grammar_1("unary expression",$1,$1->isPrimary,$1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   PLUS_OP unary_expression                                                                                                        
            {
                Expression* node = evalUNARY("unary expression","+",$2);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           
            |   MINUS_OP unary_expression                                                                                                       
            {
                Expression* node = evalUNARY("unary expression","-",$2);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           
            |   unary_expression_not_plus_minus                                                                                                 
            {
                Expression* node = grammar_1("unary expression",$1,$1->isPrimary,$1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           

pre_increment_expression
            :   INC_OP unary_expression                                                                                                         
            {
                Expression* node = evalIC_DC("pre increment expression","++",$2, true);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           

pre_decrement_expression
            :   DEC_OP unary_expression                                                                                                         
            {
                Expression* node = evalIC_DC("pre decrement expression","--",$2, true);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           

unary_expression_not_plus_minus
            :   postfix_expression                                                                                                              
            {
                Expression* node = grammar_1("unary expression not plus minus",$1, $1->isPrimary,$1->isLiteral);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   TL_OP unary_expression                                                                                                          
            {
                Expression* node = evalTL("unary expression not plus minus",$2);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           
            |   EX_OP unary_expression                                                                                                          
            {
                Expression* node = evalEX("unary expression not plus minus",$2);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           
     //     |   cast_expression                                                                                                                 {Node* node = createNode("unary expression not plus minus");if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           
     //     |   switch_expression                                                                                                               {Node* node = createNode("unary expression not plus minus");if(node == NULL) YYERROR; node->addChildren({$1}); $$ = node;}           

postfix_expression
            :   primary                                                                                                                         
            {
                Expression* node = grammar_1("postfix expression",$1, $1->isPrimary,$1->isLiteral); 
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   IDENTIFIERS                                                                                                                     
            {
                IdentifiersList* temp = new IdentifiersList("identifiers", "", {$1->lexeme}); 
                if(!typenameErrorChecking(temp, global_symtab->current_level, -1)) 
                    YYERROR; 
                Value* va = new Value(); 
                va->primitivetypeIndex = ((LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, 0)))->type->primitivetypeIndex; 
                Expression* node = new Expression("postfix expression", va, true, false); 
                if(node == NULL) 
                    YYERROR; 
                int t = get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, 0)->reg_index;
                if(t != -1) node->primary_exp_val = "t" + to_string(t);
                else node->primary_exp_val = $1->lexeme; 
                node->registor_index = t;
                node->name = $1->lexeme;
                node->isPrimary = true; 
                node->addChildren({$1}); 
                int n = findEmptyCalleeSavedRegistor();
                node->calleeSavedRegistorIndex = n;
                calleeSavedInUse[n] = true;
                int posn = ((LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, 0)))->offset;
                node->x86_64.push_back("movq\t-" + to_string(posn) + "(%rbp)," + calleeSavedRegistors[n]);
                $$ = node;
            }           
            |   post_increment_expression                                                                                                       
            {
                Expression* node = grammar_1("postfix expression",$1, $1->isPrimary,$1->isLiteral); 
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   post_decrement_expression                                                                                                       
            {
                Expression* node = grammar_1("postfix expression",$1, $1->isPrimary,$1->isLiteral); 
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }           

post_increment_expression
            :   postfix_expression INC_OP                                                                                                       
            {
                Expression* node = evalIC_DC("post increment expression","++",$1, false);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           

post_decrement_expression
            :   postfix_expression DEC_OP                                                                                                       
            {
                Expression* node = evalIC_DC("post decrement expression","--",$1, false);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2}); 
                $$ = node;
            }           

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
            :   NEW_KEYWORD IDENTIFIERS OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT class_body_zero_or_one                                              
            {
                Value* val = createObject($2->lexeme, $4, global_symtab->current_level); 
                if(val == NULL) 
                    YYERROR; 
                Expression* node = new Expression("class instance creation expression", val, false, false); 

                node->addChildren({$1,$2,$3,$4,$5,$6}); 
                $$ = node;
            }

// ##############  class_body is ignored for time being  ##############

class_body_zero_or_one
            :   /* empty */                                                                                                                             
            {
                Node* node = createNode("class body zero or one"); 
                node->addChildren({}); 
                $$ = node;
            }           
            |   class_body
            {
                Node* node = createNode("class body zero or one"); 
                node->addChildren({$1}); 
                $$ = node;
            }           

argument_list
            :   argument_expression comma_expression_zero_or_more
            {
                ExpressionList* node = new ExpressionList("argument list", $1, $2->lists); 
                node->addChildren({$1, $2}); 
                $$ = node;
            }

comma_expression_zero_or_more
            :   /* empty */
            {
                ExpressionList* node = new ExpressionList("comma expression zero or more", NULL, {}); 
                node->addChildren({}); 
                $$ = node;
            }           
            |   COMMA_OP argument_expression comma_expression_zero_or_more                                                                                       
            {
                ExpressionList* node = new ExpressionList("comma expression zero or more", $2, $3->lists); 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }           

argument_expression
            :   expression
            {
                Expression* node = grammar_1("variable initializer", $1, $1->isPrimary, $1->isLiteral); 
                calleeSavedInUse[node->calleeSavedRegistorIndex] = false;
                node->addChildren({$1}); 
                $$ = node;
            }

assignment
            :   IDENTIFIERS assignment_operators expression                                                                                             
            {
                IdentifiersList* temp = new IdentifiersList("identifiers", "", {$1->lexeme}); 
                if(!typenameErrorChecking(temp, global_symtab->current_level, 0)) 
                    YYERROR; 
                Value* va = new Value(); 
                va->primitivetypeIndex = ((LocalVariableDeclaration*)(get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, 0)))->type->primitivetypeIndex; 
                Expression* node1 = new Expression("postfix expression", va, true, false); 
                int t = get_local_symtab(global_symtab->current_level)->get_entry($1->lexeme, 0)->reg_index;
                if(t != -1) node1->primary_exp_val = "t" + to_string(t);
                else node1->primary_exp_val = $1->lexeme; 
                node1->registor_index = t;
                Expression* node = assignValue(node1, $2->children[0]->lexeme, $3, $1->lexeme);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3});  
                $$ = node;
            }           
            |   field_access assignment_operators expression                                                                                            
            {   
                Expression* node = assignValue($1, $2->children[0]->lexeme, $3, $1->name); 
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3});  
                $$ = node;
            }
            |   array_access assignment_operators expression                                                                                            
            {   
                Expression* node = assignValue($1,  $2->children[0]->lexeme, $3, $1->name);
                if(node == NULL) 
                    YYERROR; 
                node->addChildren({$1,$2,$3});
                $$ = node;
            }           

assignment_operators 
            :   ASSIGNMENT_OP                                                                                                                           
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   ADD_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators");
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   SUB_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   MUL_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   DIV_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   AND_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   OR_ASSIGN                                                                                                                               
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   XOR_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   MOD_ASSIGN                                                                                                                              
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   LEFT_ASSIGN                                                                                                                             
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   RIGHT_ASSIGN                                                                                                                            
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           
            |   BIT_RIGHT_SHFT_ASSIGN                                                                                                                   
            {
                Node* node = createNode("assignment operators"); 
                node->addChildren({$1}); 
                $$ = node;
            }           

array_creation_expression
            :   NEW_KEYWORD primitive_type OP_SQR_BRCKT expression CLOSE_SQR_BRCKT                                                                      
            {
                if($4->value->primitivetypeIndex > LONG) {
                    string err = "type mismatch: cannot convert from \"" + typeStrings[$4->value->primitivetypeIndex] + "\" to int";
                    yyerror(const_cast<char*>(err.c_str()));
                    YYERROR;
                }
                if($4->value->num_val.size() == 0) {
                    yyerror("Variable must provide dimension literal only");
                    YYERROR;
                }
                Value* val = new Value(); 
                val->primitivetypeIndex = $2->primitivetypeIndex; 
                val->dim1_count = $4->value->num_val[0];
                Expression* node = new Expression("array creation expression", val, false, false); 
                node->addChildren({$1,$2,$3,$4,$5}); 
                $$ = node;
            }

dims_zero_or_one
            :   /* empty */                                                                                                                             
            {
                Dims* node = new Dims("dims zero or one", 0); 
                node->addChildren({}); 
                $$ = node;
            }           
            |   dims                                                                                                                                    
            {
                Dims* node = new Dims("dims zero or one", $1->count_dims); 
                node->addChildren({$1}); 
                $$ = node;
            }           

dims
            :   OP_SQR_BRCKT CLOSE_SQR_BRCKT                                                                                                            
            {
                Dims* node = new Dims("dims", 1); 
                node->addChildren({$1,$2}); 
                $$ = node;
            }

primitive_type
            :   numeric_type                                                                                                                            
            {
                Type* node = new Type("primitive type", $1->primitivetypeIndex); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   BOOLEAN_KEYWORD                                                                                                                         
            {
                Type* node = new Type("primitive type", BOOLEAN); 
                node->addChildren({$1}); 
                $$ = node;
            }

numeric_type
            :   BYTE_KEYWORD                                                                                                                            
            {
                Type* node = new Type("numeric type", BYTE); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   SHORT_KEYWORD                                                                                                                           
            {
                Type* node = new Type("numeric type", SHORT); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   INT_KEYWORD                                                                                                                             
            {
                Type* node = new Type("numeric type", INT); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   LONG_KEYWORD                                                                                                                            
            {
                Type* node = new Type("numeric type", LONG); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   CHAR_KEYWORD                                                                                                                            
            {
                Type* node = new Type("numeric type", CHAR); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   FLOAT_KEYWORD                                                                                                                           
            {
                Type* node = new Type("numeric type", FLOAT); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   DOUBLE_KEYWORD                                                                                                                          
            {
                Type* node = new Type("numeric type", DOUBLE); 
                node->addChildren({$1}); 
                $$ = node;
            }

variable_initializer
            :   expression                                                                                                                              
            {
                Expression* node = grammar_1("variable initializer", $1, $1->isPrimary, $1->isLiteral); 
                calleeSavedInUse[node->calleeSavedRegistorIndex] = false;
                node->addChildren({$1}); 
                $$ = node;
            }

type_name
            :   type_name_scoping                                                                                                                       
            {
                IdentifiersList* node = new IdentifiersList("type name", "", $1->identifiers); 
                if(!typenameErrorChecking(node, global_symtab->current_level, -1)) 
                    YYERROR; 
                node->addChildren({$1}); 
                $$ = node;
            }

type_name_scoping
            :   IDENTIFIERS                                                                                                                             
            {
                IdentifiersList* node = new IdentifiersList("type name", $1->lexeme, {}); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   type_name_scoping DOT_OP IDENTIFIERS                                                                                                    
            {
                IdentifiersList* node = new IdentifiersList("type name", $3->lexeme, $1->identifiers); 
                node->addChildren({$1,$2,$3}); 
                $$ = node;
            }

modifiers
            :   PUBLIC_KEYWORD                                                                                                                          
            {
                Modifier* node = new Modifier(PUBLIC, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   PROTECTED_KEYWORD                                                                                                                       
            {
                Modifier* node = new Modifier(PROTECTED, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   PRIVATE_KEYWORD                                                                                                                         
            {
                Modifier* node = new Modifier(PRIVATE, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   ABSTRACT_KEYWORD                                                                                                                        
            {
                Modifier* node = new Modifier(ABSTRACT, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   STATIC_KEYWORD                                                                                                                          
            {
                Modifier* node = new Modifier(STATIC, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   STRICTFP_KEYWORD                                                                                                                        
            {
                Modifier* node = new Modifier(STRICTFP, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   FINAL_KEYWORD                                                                                                                           
            {
                Modifier* node = new Modifier(FINAL, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   VOLATILE_KEYWORD                                                                                                                        
            {
                Modifier* node = new Modifier(VOLATILE, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   TRANSIENT_KEYWORD                                                                                                                       
            {
                Modifier* node = new Modifier(TRANSIENT, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   NATIVE_KEYWORD                                                                                                                          
            {
                Modifier* node = new Modifier(NATIVE, "modifiers"); 
                node->addChildren({$1}); 
                $$ = node;
            }

modifiers_one_or_more
            :   modifiers                                                                                                                               
            {
                ModifierList* node = new ModifierList("modifiers zero or more", $1, {}); 
                node->addChildren({$1}); 
                $$ = node;
            }
            |   modifiers modifiers_one_or_more                                                                                                        
            {
                ModifierList* node = new ModifierList("modifiers zero or more", $1, $2->lists); 
                node->addChildren({$1,$2}); 
                $$ = node;
            }


//  ########   BLOCKS, STATEMENTS AND PATTERNS   ########  

block
        :   OP_CURLY_BRCKT block_statements_zero_or_one CLOSE_CURLY_BRCKT                                                                               
        {
            Node* node = createNode("block"); 
            node->addChildren({$1,$2,$3}); 
            node->parent_level = $1->parent_level; 
            $$ = node;
        }

block_statements_zero_or_one
        :   /* empty */                                                                                                                                 
        {
            Node* node = createNode("block statements zero or one"); 
            node->addChildren({}); 
            $$ = node;
        }
        |   block_statements                                                                                                                            
        {
            Node* node = createNode("block statements zero or one"); 
            node->addChildren({$1}); 
            $$ = node;
        }

block_statements
        :   block_statement block_statements_zero_or_more                                                                                               
        {
            Node* node = createNode("block statements"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

block_statements_zero_or_more
        :   /* empty */                                                                                                                                 
        {
            Node* node = createNode("block statements zero or more"); 
            node->addChildren({}); 
            $$ = node;
        }
        |   block_statement block_statements_zero_or_more                                                                                               
        {
            Node* node = createNode("block statements zero or more"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

block_statement
        :   statement                                                                                                                                   
        {
            Node* node = createNode("block statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   local_variable_declaration_statement                                                                                                        
        {
            Node* node = createNode("block statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   local_class_or_interface_declaration                                                                                                        
        {
            Node* node = createNode("block statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }

local_class_or_interface_declaration
        :   class_declaration                                                                                                                           
        {
            Node* node = createNode("local class or interface declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }

local_variable_declaration_statement
        :   local_variable_declaration SEMICOLON_OP                                                                                                     
        {
            Node* node = createNode("local variable declaration statemen"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

local_variable_declaration
        :   unann_type variable_declarator_list                                                                                                         
        {
            Node* node = createNode("local variable declaration"); 
            node->addChildren({$1,$2}); 
            if(!addVariablesToSymtab($1, $2, global_symtab->current_level, NULL, false)) 
                YYERROR; 
            $$ = node;
        }

statement
        :   statement_without_trailing_substatement                                                                                                     
        {
            Node* node = createNode("statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   labeled_statement                                                                                                                           
        {
            Node* node = createNode("statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   if_then_statement                                                                                                                           
        {
            Node* node = createNode("statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   if_then_else_statement                                                                                                                      
        {
            Node* node = createNode("statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   while_statement                                                                                                                             
        {
            Node* node = createNode("statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   for_statement                                                                                                                               
        {
            Node* node = createNode("statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }

statement_no_short_if
        :   statement_without_trailing_substatement                                                                                                     
        {
            Node* node = createNode("statement no short if"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   labeled_statement_no_short_if                                                                                                               
        {
            Node* node = createNode("statement no short if"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   if_then_else_statement_no_short_if                                                                                                          
        {
            Node* node = createNode("statement no short if"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   while_statement_no_short_if                                                                                                                 
        {
            Node* node = createNode("statement no short if"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   for_statement_no_short_if                                                                                                                  
        {
            Node* node = createNode("statement no short if"); 
            node->addChildren({$1}); 
            $$ = node;
        }

statement_without_trailing_substatement
        :   block                                                                                                                                       
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   empty_statement                                                                                                                             
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   expression_statement                                                                                                                        
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
     // |   switch_statement
        |   do_statememt
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   break_statement                                                                                                                             
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   continue_statement                                                                                                                          
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   return_statement                                                                                                                            
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   print_statement
        {
            Node* node = createNode("statement without trailing substatement"); 
            node->addChildren({$1}); 
            $$ = node;
        }

print_statement 
        :    SYSTEM_KEYWORD DOT_OP OUT_KEYWORD DOT_OP PRINTLN_KEYWORD OP_BRCKT expression CLOSE_BRCKT
        {
            Node* node = createNode("print_statement"); 
            node->addChildren({$1}); 
            node->x86_64.push_back("movq\t" + calleeSavedRegistors[$7->calleeSavedRegistorIndex] + ", %rsi");
            node->x86_64.push_back("leaq\t.LC0(%rip), %rdi");
            node->x86_64.push_back("movq $0, %rax");
            node->x86_64.push_back("call\tprintf");
            calleeSavedInUse[$7->calleeSavedRegistorIndex] = false;
            node->addChildren({$1, $2, $3, $4, $5, $6, $7, $8});
            $$ = node;
        }

// switch_statement
//      :   switch_expression                                                                                                                           {Node* node = createNode("switch statement"); node->addChildren({$1}); $$ = node;}

do_statememt
        :   DO_KEYWORD statement WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT SEMICOLON_OP
        {
            Node* node = createNode("while statement"); 
            node->addChildren({$1,$2,$3,$4,$5,$6,$7}); 
            node->entry_type = DO_STATEMENT; 
            $$ = node;
        }

empty_statement
        :   SEMICOLON_OP                                                                                                                                
        {
            Node* node = createNode("empty statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }

labeled_statement
        :   IDENTIFIERS COLON_OP statement                                                                                                              
        {
            Node* node = createNode("labeled statement"); 
            node->addChildren({$1,$2,$3});
            $$ = node;
        }

labeled_statement_no_short_if
        :   IDENTIFIERS COLON_OP statement_no_short_if                                                                                                  
        {
            Node* node = createNode("labeled statement no short if"); 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }

expression_statement
        :  statement_expression SEMICOLON_OP                                                                                                            
        {
            Node* node = createNode("expression statement"); 
            node->addChildren({$1,$2}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }

statement_expression
        :  assignment                                                                                                                                   
        {
            Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |  pre_increment_expression                                                                                                                     
        {
            Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |  pre_decrement_expression                                                                                                                     
        {
            Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |  post_increment_expression                                                                                                                    
        {
            Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |  post_decrement_expression                                                                                                                    
        {
            Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |  method_invocation                                                                                                                            
        {   Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |  class_instance_creation_expression                                                                                                           
        {
            Expression* node = grammar_1("statement expression", $1, $1->isPrimary, $1->isLiteral); 
            node->addChildren({$1}); 
            calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            $$ = node;
        }

if_then_statement
        :  IF_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement                                                                                         
        {
            Node* node = createNode("if then statement"); 
            node->addChildren({$1,$2,$3,$4,$5}); 
            node->entry_type = IF_THEN_STATEMENT; 
            $$ = node;
        }

if_then_else_statement
        :  IF_KEYWORD  OP_BRCKT expression CLOSE_BRCKT statement_no_short_if ELSE_KEYWORD statement                                                     
        {
            Node* node = createNode("if then else statement"); 
            node->addChildren({$1,$2,$3,$4,$5,$6,$7}); 
            node->entry_type = IF_THEN_ELSE_STATEMENT; 
            $$ = node;
        }

if_then_else_statement_no_short_if
        :  IF_KEYWORD  OP_BRCKT expression CLOSE_BRCKT statement_no_short_if ELSE_KEYWORD statement_no_short_if                                         
        {
            Node* node = createNode("if then else statement no short if"); 
            node->addChildren({$1,$2,$3,$4,$5,$6,$7}); 
            node->entry_type = IF_THEN_ELSE_STATEMENT; 
            $$ = node;
        }

while_statement
        :  WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement                                                                                      
        {
            int ind = $3->registor_index; 
            Node* node = createNode("while statement"); 
            node->addChildren({$1,$2,$3,$4,$5}); 
            node->entry_type = WHILE_STATEMENT; 
            temporary_registors_in_use[ind] = false; 
            $$ = node;
        }

while_statement_no_short_if
        :  WHILE_KEYWORD OP_BRCKT expression CLOSE_BRCKT statement_no_short_if                                                                          
        {
            int ind = $3->registor_index; 
            Node* node = createNode("while statement no short if"); 
            node->addChildren({$1,$2,$3,$4,$5}); 
            node->entry_type = WHILE_STATEMENT;  
            temporary_registors_in_use[ind] = false; 
            $$ = node;
        }

for_statement
        :  basic_for_statement                                                                                                                          
        {
            Node* node = createNode("for statement"); 
            node->addChildren({$1}); 
            $$ = node;
        }
     // |  enhanced_for_statement                                                                                                                       {Node* node = createNode("for statement"); node->addChildren({$1}); $$ = node;}

for_statement_no_short_if
        :  basic_for_statement_no_short_if                                                                                                              
        {
            Node* node = createNode("for statement no short if"); 
            node->addChildren({$1}); 
            $$ = node;
        }
     // |  enhanced_for_statement_no_short_if                                                                                                           {Node* node = createNode("for statement no short if"); node->addChildren({$1}); $$ = node;}

basic_for_statement
        :  FOR_KEYWORD OP_BRCKT for_init_zero_or_one SEMICOLON_OP expression_zero_or_one SEMICOLON_OP for_update_zero_or_one CLOSE_BRCKT statement      
        {
            Node* node = createNode("basic for statement"); 
            node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8,$9}); 
            node->entry_type = FOR_STATEMENT; 
            $$ = node;
        }

basic_for_statement_no_short_if
        :  FOR_KEYWORD OP_BRCKT for_init_zero_or_one SEMICOLON_OP expression_zero_or_one SEMICOLON_OP for_update_zero_or_one CLOSE_BRCKT statement_no_short_if 
        {
            Node* node = createNode("basic for statement no short if"); 
            node->addChildren({$1,$2,$3,$4,$5,$6,$7,$8,$9}); 
            node->entry_type = FOR_STATEMENT; 
            $$ = node;
        }

for_init_zero_or_one
        :  /* empty */                                                                                                                                  
        {
            Node* node = createNode("for init zero or one"); 
            node->addChildren({}); 
            $$ = node;
        }
        |  for_init                                                                                                                                     
        {
            Node* node = createNode("for init zero or one"); 
            node->addChildren({$1}); 
            $$ = node;
        }

expression_zero_or_one
        : /* empty */                                                                                                                                   
        {
            Expression* node = new Expression("expression zero or one", NULL, false, false); 
            node->addChildren({}); 
            $$ = node;
        }
        |  expression                                                                                                                                   
        {
            Expression* node = grammar_1("expression zero or one", $1, $1->isPrimary, $1->isLiteral); 
            int nn = $1->calleeSavedRegistorIndex;
            if(nn >=0 && nn< calleeSavedInUse.size())
                calleeSavedInUse[$1->calleeSavedRegistorIndex] = false;
            node->addChildren({$1}); 
            $$ = node;
        }

for_update_zero_or_one
        :  /* empty */                                                                                                                                  
        {
            Node* node = createNode("for update zero or one"); 
            node->addChildren({}); 
            $$ = node;
        }
        |  for_update                                                                                                                                   
        {
            Node* node = createNode("for update zero or one"); 
            node->addChildren({$1}); 
            $$ = node;
        }

for_init
        :  statement_expression_list                                                                                                                    
        {
            Node* node = createNode("for init"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  local_variable_declaration                                                                                                                   
        {
            Node* node = createNode("for init"); 
            node->addChildren({$1}); 
            $$ = node;
        }

for_update
        :  statement_expression_list                                                                                                                    
        {
            ExpressionList* node = new ExpressionList("for update", NULL, $1->lists); 
            node->addChildren({$1}); 
            $$ = node;
        }

statement_expression_list
        :  statement_expression comma_statement_expression_zero_or_more                                                                                 
        {
            ExpressionList* node = new ExpressionList("statement expression list", $1, $2->lists); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

comma_statement_expression_zero_or_more
        :  /* empty */                                                                                                                                  
        {
            ExpressionList* node = new ExpressionList("comma statement expression zero or more", NULL, {}); 
            node->addChildren({}); 
            $$ = node;
        }
        |  COMMA_OP statement_expression comma_statement_expression_zero_or_more                                                                        
        {
            ExpressionList* node = new ExpressionList("comma statement expression zero or more", $2, $3->lists); 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }

// enhanced_for_statement
//         :  FOR_KEYWORD OP_BRCKT local_variable_declaration COLON_OP expression CLOSE_BRCKT statement                                                    {Node* node = createNode("enhanced for statement"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

// enhanced_for_statement_no_short_if
//         :  FOR_KEYWORD OP_BRCKT local_variable_declaration COLON_OP expression CLOSE_BRCKT statement_no_short_if                                        {Node* node = createNode("enhanced for statement no short if"); node->addChildren({$1,$2,$3,$4,$5,$6,$7}); $$ = node;}

break_statement
        :  BREAK_KEYWORD SEMICOLON_OP                                                                                                                   
        {
            Node* node = createNode("break statement"); 
            node->addChildren({$1,$2}); 
            node->entry_type = BREAK_STATEMENT;
            $$ = node;
        }

continue_statement
        :  CONTINUE_KEYWORD SEMICOLON_OP                                                                                         
        {
            Node* node = createNode("continue statement"); 
            node->addChildren({$1,$2});
            node->entry_type = CONTINUE_STATEMENT;
            $$ = node;
        }

return_statement
        :  RETURN_KEYWORD expression SEMICOLON_OP                                                                                           
        {
            Node* node = createNode("return statement"); 
            node->addChildren({$1,$2,$3}); 
            node->entry_type = EXPRESSIONS; 
            Expression* node1 = new Expression("return_registor", NULL, true, false);
            node1->primary_exp_val = "%rax";
            node->code.push_back(addInstruction(node1, $2, NULL, "", 0));
            node->x86_64.push_back("movq\t" + calleeSavedRegistors[$2->calleeSavedRegistorIndex] + ", %rax");
            calleeSavedInUse[$2->calleeSavedRegistorIndex] = false;
            $$ = node;
        }
        |   RETURN_KEYWORD SEMICOLON_OP
        {
            Node* node = createNode("return statement"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

//  ########   CLASSES   ########  

class_declaration
        :  normal_class_declaration                                                                                                                     
        {
            Node* node = createNode("class declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }

normal_class_declaration
        :  normal_class_declaration_statement class_body                                                                                                   
        {
            Node* node = createNode("normal_class_declaration"); 
            ((LocalSymbolTable*)((global_symtab->symbol_tables)[$2->parent_level.first][$2->parent_level.second]))->level_node = (Node*)($1); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

normal_class_declaration_statement
        :  CLASS_KEYWORD IDENTIFIERS class_extends_zero_or_one                                                                                         
        {
            NormalClassDeclaration* node = new NormalClassDeclaration("normal class declaration statement", NULL, $2->lexeme); 
            node->line_no = $1->line_no; 
            node->entry_type = CLASS_DECLARATION; 
            node->addChildren({$1,$2,$3}); 
            get_local_symtab(global_symtab->current_level)->add_entry(node); 
            curr_class = node;
            $$ = node;
        }
        |  modifiers_one_or_more CLASS_KEYWORD IDENTIFIERS class_extends_zero_or_one                                                                   
        {
            NormalClassDeclaration* node = new NormalClassDeclaration("normal class declaration statement", $1, $3->lexeme); 
            node->line_no = $2->line_no; 
            node->entry_type = CLASS_DECLARATION; 
            node->addChildren({$1,$2,$3,$4}); 
            get_local_symtab(global_symtab->current_level)->add_entry(node); 
            curr_class = node;
            $$ = node;
        }

class_extends_zero_or_one
        :   /* empty */                                                                                                                                 
        {
            Node* node = createNode("class extends zero or one"); 
            node->addChildren({});
            $$ = node;
        }
        |  class_extends                                                                                                                                
        {
            Node* node = createNode("class extends zero or one"); 
            node->addChildren({$1}); 
            $$ = node;
        }

class_extends
        :  EXTENDS_KEYWORD IDENTIFIERS                                                                                                                   
        {
            Node* node = createNode("class extends"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

class_body
        :  OP_CURLY_BRCKT class_body_declaration_zero_or_more CLOSE_CURLY_BRCKT                                                                         
        {
            Node* node = createNode("class body"); 
            node->addChildren({$1,$2,$3}); 
            node->parent_level = $1->parent_level; 
            $$ = node;
        }

class_body_declaration_zero_or_more
        :   /* empty */                                                                                                                                 
        {
            Node* node = createNode("class body declaration zero or more"); 
            node->addChildren({}); 
            $$ = node;
        }
        |  class_body_declaration class_body_declaration_zero_or_more                                                                                   
        {
            Node* node = createNode("class body declaration zero or more"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

class_body_declaration
        :  constructor_declaration                                                                                                                      
        {
            Node* node = createNode("class body declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  block                                                                                                                                        
        {
            Node* node = createNode("class body declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  static_initializer                                                                                                                           
        {
            Node* node = createNode("class body declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  field_declaration                                                                                                                            
        {
            Node* node = createNode("class body declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  method_declaration                                                                                                                           
        {
            Node* node = createNode("class body declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }             
        |  SEMICOLON_OP                                                                                                                                 
        {
            Node* node = createNode("class body declaration"); 
            node->addChildren({$1}); 
            $$ = node;
        }

field_declaration
        :  unann_type variable_declarator_list SEMICOLON_OP                                                                                            
        {
            Node* node = createNode("field declaration"); 
            if(!addVariablesToSymtab($1, $2, global_symtab->current_level, NULL, true)) 
                YYERROR;  
            node->addChildren({$1,$2,$3});  
            $$ = node;
        }
        |  modifiers_one_or_more unann_type variable_declarator_list SEMICOLON_OP                                                                      
        {
            Node* node = createNode("field declaration");
            if(!addVariablesToSymtab($2, $3, global_symtab->current_level, $1, true)) 
                YYERROR;  
            node->addChildren({$1,$2,$3,$4}); 
            $$ = node;
        }

variable_declarator_list
        :  variable_declarator comma_variable_declarator_zero_or_more                                                                                   
        {
            VariableDeclaratorList* node = new VariableDeclaratorList("variable declarator list", $1, $2->lists); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

comma_variable_declarator_zero_or_more
        :  /* empty */                                                                                                                                  
        {
            VariableDeclaratorList* node = new VariableDeclaratorList("comma variable declarator zero or more", NULL, {}); 
            node->addChildren({}); 
            $$ = node;
        }
        |  comma_variable_declarator_zero_or_more COMMA_OP variable_declarator                                                                          
        {
            VariableDeclaratorList* node = new VariableDeclaratorList("comma variable declarator zero or more", $3, $1->lists); 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }

variable_declarator
        :  variable_declarator_id                                                                                                                       
        {
            VariableDeclaratorId* node = new VariableDeclaratorId("variable_declarator", $1->identifier, $1->num_of_dims, NULL);      
            node->entry_type = VARIABLE_DECLARATION; 
            node->lex_val = ""; 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  variable_declarator_id ASSIGNMENT_OP variable_initializer                                                                                    
        {
            VariableDeclaratorId* node = new VariableDeclaratorId("variable_declarator", $1->identifier, $1->num_of_dims, $3->value); 
            node->entry_type = VARIABLE_DECLARATION; 
            node->lex_val = $3->primary_exp_val; 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }

variable_declarator_id
        :  IDENTIFIERS dims_zero_or_one                                                                                                                 
        {
            VariableDeclaratorId* node = new VariableDeclaratorId("variable declarator id", $1->lexeme, $2->count_dims, NULL); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

unann_type
        :  primitive_type                                                                                                                               
        {
            Type* node = new Type("unann type", $1->primitivetypeIndex); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  type_name                                                                                                                                    
        {
            Type* node = new Type("unann type", -1); 
            Node* temp = get_local_symtab(global_symtab->current_level)->get_entry($1->identifiers[0], 1); 
            if(temp==NULL) 
                YYERROR; 
            node->class_instantiated_from = (NormalClassDeclaration*)(temp); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |   STRING_KEYWORD
        {
            Type* node = new Type("unann type", STRING); 
            node->addChildren({$1}); 
            $$ = node;
        }

method_declaration
        :   method_declaration_statement block
        {
            MethodDeclaration* node = new MethodDeclaration("method_declaration_statement");   
            node->entry_type = METHOD_DECLARATION; 
            node->line_no = $1->line_no; 
            node->name = $1->name; 
            node->formal_parameter_list = $1->formal_parameter_list; 
            node->type = $1->type;
            node->modifiers = $1->modifiers;
            ((LocalSymbolTable*)((global_symtab->symbol_tables)[$2->parent_level.first][$2->parent_level.second]))->level_node = (Node*)(node); 
            for(int i=0;i<node->formal_parameter_list->lists.size();i++){
                int t = node->formal_parameter_list->lists[i]->reg_index;
                temporary_registors_in_use[t] = false;
            }
            node->addChildren({$1, $2});
            node->local_variables_size = (functionOffset%16 == 0) ? 16*((functionOffset/16)) : 16*((functionOffset/16) + 1);
            functionOffset = 8;
            int nn = calleeGlobalCalled.size();
            for(int i=0;i<nn;i++) {
                if(calleeGlobalCalled[i] == true) node->calleeRegCalled.push_back(i);    
                calleeGlobalCalled[i] = false;
            }
            $$ = node;
        }
        |   method_declaration_statement SEMICOLON_OP
        {
            MethodDeclaration* node = new MethodDeclaration("method_declaration_statement");   
            node->entry_type = METHOD_DECLARATION; 
            node->line_no = $1->line_no; 
            node->name = $1->name; 
            node->formal_parameter_list = $1->formal_parameter_list; 
            node->type = $1->type; 
            node->modifiers = $1->modifiers;
            node->addChildren({$1, $2});
            node->local_variables_size = 16*((functionOffset/16) + 1);
            functionOffset = 8;
            int nn = calleeGlobalCalled.size();
            for(int i=0;i<nn;i++) {
                if(calleeGlobalCalled[i] == true) node->calleeRegCalled.push_back(i);    
                calleeGlobalCalled[i] = false;
            }
            $$ = node;
        }

method_declaration_statement
        :  method_header                                                                                                                          
        {
            MethodDeclaration* node = new MethodDeclaration("method_declaration"); 
            node->line_no = $1->line_no; 
            node->name = $1->name; 
            node->formal_parameter_list = $1->formal_parameter_list; 
            node->type = $1->type; 
            node->modifiers = NULL; 
            node->addChildren({$1});  
            get_local_symtab(global_symtab->current_level)->add_entry(node); 
            $$ = node;
        }
        |  modifiers_one_or_more method_header                                                                                             
        {
            MethodDeclaration* node = new MethodDeclaration("method_declaration"); 
            node->line_no = $2->line_no; 
            node->name = $2->name; 
            node->formal_parameter_list = $2->formal_parameter_list; 
            node->type = $2->type; 
            node->modifiers = $1; 
            node->addChildren({$1,$2}); 
            get_local_symtab(global_symtab->current_level)->add_entry(node); 
            $$ = node;
        }

method_header
        :  unann_type method_declarator                                                                                                                 
        {
            MethodDeclaration* node = new MethodDeclaration("method_header"); 
            node->name = $2->name; 
            node->formal_parameter_list = $2->formal_parameter_list; 
            node->type = $1;  
            node->addChildren({$1,$2}); 
            $$ = node;
        }
        |  VOID_KEYWORD method_declarator                                                                                                               
        {
            Type* t = new Type("result", VOID); 
            MethodDeclaration* node = new MethodDeclaration("method_header"); 
            node->name = $2->name; 
            node->formal_parameter_list = $2->formal_parameter_list; 
            node->type = t; 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

method_declarator
        :  IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT dims_zero_or_one                                                          
        {
            MethodDeclaration* node = new MethodDeclaration("method declarator"); 
            node->name = $1->lexeme; 
            node->formal_parameter_list = $3; 
            node->addChildren({$1,$2,$3,$4,$5}); 
            $$ = node;
        }

formal_parameter_list_zero_or_one
        :   /* empty */                                                                                                                                 
        {
            FormalParameterList* node = new FormalParameterList("formal parameter list zero or one", NULL, {}); 
            node->addChildren({}); 
            $$ = node;
        }
        |  formal_parameter_list                                                                                                                        
        {
            FormalParameterList* node = new FormalParameterList("formal parameter list zero or one", NULL, $1->lists); 
            node->addChildren({$1}); 
            $$ = node;
        }

formal_parameter_list
        :  formal_parameter                                                                                                                             
        {
            FormalParameterList* node = new FormalParameterList("formal parameter list", $1, {}); 
            node->addChildren({$1}); 
            $$ = node;
        }
        |  formal_parameter COMMA_OP formal_parameter_list                                                                                              
        {
            FormalParameterList* node = new FormalParameterList("formal parameter list", $1, $3->lists); 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }

formal_parameter
        :  unann_type variable_declarator_id                                                                                                            
        {
            FormalParameter* node = new FormalParameter("formal parameter", $1, $2, false); 
            node->addChildren({$1,$2}); 
            node->name = $2->identifier;
            node->entry_type = VARIABLE_DECLARATION;
            int t = findEmptyRegistor();
            node->reg_index = t;
            node->offset = functionOffset;
            functionOffset += 8;
            temporary_registors_in_use[t] = true;
            get_local_symtab(global_symtab->current_level)->add_entry(node);
            $$ = node;
        }
        |  unann_type OP_SQR_BRCKT CLOSE_SQR_BRCKT IDENTIFIERS                                                                                                            
        {
            FormalParameter* node = new FormalParameter("formal parameter", $1, NULL, false); 
            node->addChildren({$1,$2,$3,$4}); 
            node->name = $4->lexeme;
            node->entry_type = VARIABLE_DECLARATION;
            int t = findEmptyRegistor();
            node->reg_index = t;
            temporary_registors_in_use[t] = true;
            get_local_symtab(global_symtab->current_level)->add_entry(node);
            $$ = node;
        }
        |  FINAL_KEYWORD unann_type variable_declarator_id                                                                                              
        {
            FormalParameter* node = new FormalParameter("formal parameter", $2, $3, true); 
            node->name = $3->identifier;
            node->entry_type = VARIABLE_DECLARATION;
            int t = findEmptyRegistor();
            node->reg_index = t;
            node->offset = functionOffset;
            functionOffset += 8;
            temporary_registors_in_use[t] = true;
            get_local_symtab(global_symtab->current_level)->add_entry(node);
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }

static_initializer
        :  STATIC_KEYWORD block                                                                                                                         
        {   
            Node* node = createNode("static initializer"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

constructor_declaration
        :  constructor_declarator constructor_body                                                                                                      
        {
            MethodDeclaration* node = new MethodDeclaration("constructor_declaration"); 
            node->name = $1->name; 
            node->formal_parameter_list = $1->formal_parameter_list; 
            node->modifiers = NULL; 
            node->entry_type = METHOD_DECLARATION; 
            node->isConstructor = true; 
            node->addChildren({$1,$2}); 
            get_local_symtab(global_symtab->current_level)->add_entry(node); 
            $$ = node;
        }
        |  modifiers_one_or_more constructor_declarator constructor_body                                                                                
        {
            MethodDeclaration* node = new MethodDeclaration("constructor_declaration"); 
            node->name = $2->name; 
            node->formal_parameter_list = $2->formal_parameter_list; 
            node->modifiers = $1; 
            node->entry_type = METHOD_DECLARATION; 
            node->isConstructor = true; 
            node->addChildren({$1,$2,$3}); 
            get_local_symtab(global_symtab->current_level)->add_entry(node);
            $$ = node;
        }

constructor_declarator
        :  IDENTIFIERS OP_BRCKT formal_parameter_list_zero_or_one CLOSE_BRCKT                                                                           
        {
            MethodDeclaration* node = new MethodDeclaration("constructor declarator"); 
            node->name = $1->lexeme; 
            node->formal_parameter_list = $3;  
            node->addChildren({$1,$2,$3,$4}); 
            $$ = node;
        }

constructor_body
        :  OP_CURLY_BRCKT explicit_constructor_invocation CLOSE_CURLY_BRCKT                                                                             
        {
            Node* node = createNode("constructor body"); 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }
        |  OP_CURLY_BRCKT block_statements CLOSE_CURLY_BRCKT                                                                                            
        {
            Node* node = createNode("constructor body"); 
            node->addChildren({$1,$2,$3}); 
            $$ = node;
        }
        |  OP_CURLY_BRCKT explicit_constructor_invocation block_statements CLOSE_CURLY_BRCKT                                                            
        {
            Node* node = createNode("constructor body"); 
            node->addChildren({$1,$2,$3,$4}); 
            $$ = node;
        }
        |  OP_CURLY_BRCKT CLOSE_CURLY_BRCKT                                                                                                             
        {
            Node* node = createNode("constructor body"); 
            node->addChildren({$1,$2}); 
            $$ = node;
        }

explicit_constructor_invocation
        :  THIS_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                                     
        {
            Node* node = createNode("explicit constructor invocation"); 
            node->addChildren({$1,$2,$3,$4,$5}); 
            $$ = node;
        }
        |  SUPER_KEYWORD OP_BRCKT argument_list_zero_or_one CLOSE_BRCKT SEMICOLON_OP                                                                    
        {
            Node* node = createNode("explicit constructor invocation"); 
            node->addChildren({$1,$2,$3,$4,$5}); 
            $$ = node;
        }

argument_list_zero_or_one
        :   /* empty */                                                                                                                                 
        {
            ExpressionList* node = new ExpressionList("argument list zero or one", NULL, {}); 
            node->addChildren({}); 
            $$ = node;
        } 
        |  argument_list                                                                                                                                
        {
            ExpressionList* node = new ExpressionList("argument list zero or one", NULL, $1->lists); 
            node->addChildren({$1}); 
            $$ = node;
        }

// TERMINALS 

ASSIGNMENT_OP
        :       '='                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
GT_OP
        :       '>'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
LT_OP
        :       '<'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
EX_OP
        :       '!'                                                    
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
TL_OP
        :       '~'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
QN_OP
        :       '?'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
COLON_OP
        :       ':'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
PLUS_OP
        :       '+'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
MINUS_OP
        :       '-'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
STAR_OP
        :       '*'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
DIV_OP
        :       '/'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
ND_OP
        :       '&'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
BAR_OP
        :       '|'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
RAISE_OP
        :       '^'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
PCNT_OP
        :       '%'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
COMMA_OP
        :       ','                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
DOT_OP
        :       '.'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
SEMICOLON_OP
        :       ';'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
OP_BRCKT
        :       '('                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            // global_symtab->increase_level(); 
            $$ = temp;
        }
CLOSE_BRCKT
        :       ')'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            // global_symtab->decrease_level(); 
            $$ = temp;
        }
OP_SQR_BRCKT
        :       '['                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
CLOSE_SQR_BRCKT
        :       ']'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
OP_CURLY_BRCKT
        :       '{'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            global_symtab->increase_level(); 
            temp->parent_level = global_symtab->current_level; 
            $$ = temp;
        }
CLOSE_CURLY_BRCKT
        :       '}'                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            global_symtab->decrease_level(); 
            $$ = temp;
        }

ABSTRACT_KEYWORD
        :       abstract_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

SYSTEM_KEYWORD
        :       system_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

DO_KEYWORD
        :       do_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

OUT_KEYWORD
        :       out_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

PRINTLN_KEYWORD
        :       println_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

CONTINUE_KEYWORD
        :       continue_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

FOR_KEYWORD
        :       for_keyword_terminal                                                    
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

NEW_KEYWORD
        :       new_keyword_terminal                                                    
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

// SWITCH_KEYWORD
//         :       switch_keyword_terminal                                                 {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

IF_KEYWORD
        :       if_keyword_terminal                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

BOOLEAN_KEYWORD
        :       boolean_keyword_terminal                                                
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

PRIVATE_KEYWORD
        :       private_keyword_terminal                                                
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

THIS_KEYWORD
        :       this_keyword_terminal                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }
BREAK_KEYWORD
        :       break_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

DOUBLE_KEYWORD
        :       double_keyword_terminal                                                 
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

PROTECTED_KEYWORD
        :       protected_keyword_terminal                                              
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

BYTE_KEYWORD
        :       byte_keyword_terminal                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

ELSE_KEYWORD
        :       else_keyword_terminal                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

PUBLIC_KEYWORD
        :       public_keyword_terminal                                                 
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

// CASE_KEYWORD
//         :       case_keyword_terminal                                                   {Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}

RETURN_KEYWORD
        :       return_keyword_terminal                                                 
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

TRANSIENT_KEYWORD
        :       transient_keyword_terminal                                              
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

EXTENDS_KEYWORD
        :       extends_keyword_terminal                                                
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

INT_KEYWORD
        :       int_keyword_terminal                                                    
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

SHORT_KEYWORD
        :       short_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

CHAR_KEYWORD
        :       char_keyword_terminal                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

FINAL_KEYWORD
        :       final_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

STATIC_KEYWORD
        :       static_keyword_terminal                                                 
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

VOID_KEYWORD
        :       void_keyword_terminal                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

CLASS_KEYWORD
        :       class_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

LONG_KEYWORD
        :       long_keyword_terminal                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

STRICTFP_KEYWORD
        :       strictfp_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

VOLATILE_KEYWORD
        :       volatile_keyword_terminal                                               
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

FLOAT_KEYWORD
        :       float_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

STRING_KEYWORD
        :       string_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

NATIVE_KEYWORD
        :       native_keyword_terminal                                                 
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

SUPER_KEYWORD
        :       super_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

WHILE_KEYWORD
        :       while_keyword_terminal                                                  
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

EQ_OP
        :       EQ_OP_TERMINAL                                                          
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

GE_OP
        :       GE_OP_TERMINAL                                                          
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

LE_OP
        :       LE_OP_TERMINAL                                                          
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

NE_OP
        :       NE_OP_TERMINAL                                                          
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

AND_OP
        :       AND_OP_TERMINAL                                                         
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

OR_OP
        :       OR_OP_TERMINAL 
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

INC_OP
        :       INC_OP_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

DEC_OP
        :       DEC_OP_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

LEFT_OP
        :       LEFT_OP_TERMINAL                                                        
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

RIGHT_OP
        :       RIGHT_OP_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

BIT_RIGHT_SHFT_OP
        :       BIT_RIGHT_SHFT_OP_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

ADD_ASSIGN
        :       ADD_ASSIGN_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

SUB_ASSIGN
        :       SUB_ASSIGN_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

MUL_ASSIGN
        :       MUL_ASSIGN_TERMINAL
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

DIV_ASSIGN
        :       DIV_ASSIGN_TERMINAL                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

AND_ASSIGN
        :       AND_ASSIGN_TERMINAL                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

OR_ASSIGN
        :       OR_ASSIGN_TERMINAL                                                      
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

XOR_ASSIGN
        :       XOR_ASSIGN_TERMINAL                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

MOD_ASSIGN
        :       MOD_ASSIGN_TERMINAL                                                     
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

LEFT_ASSIGN
        :       LEFT_ASSIGN_TERMINAL                                                    
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

RIGHT_ASSIGN
        :       RIGHT_ASSIGN_TERMINAL                                                   
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

BIT_RIGHT_SHFT_ASSIGN
        :       BIT_RIGHT_SHFT_ASSIGN_TERMINAL                                          
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

IDENTIFIERS
        :       IDENTIFIERS_TERMINAL                                                    
        {
            Node* temp = createNode($1); 
            temp->isTerminal = true; 
            $$ = temp;
        }

LITERALS
        :       NUM_LITERALS   
        {
            Value* va = new Value(); 
            va->primitivetypeIndex = INT;    
            va->num_val.push_back(strtol($1, NULL, 10));      
            Expression* temp = new Expression($1, va, true, true); 
            temp->isTerminal = true; 
            temp->primary_exp_val = $1;
            $$ = temp;
        }
        |       DOUBLE_LITERALS                                                         
        {
            Value* va = new Value(); 
            va->primitivetypeIndex = DOUBLE;  
            va->double_val.push_back(strtod($1, NULL));       
            Expression* temp = new Expression($1, va, true, true); 
            temp->isTerminal = true; 
            temp->primary_exp_val = $1; 
            $$ = temp;
        }
        |       STRING_LITERALS                                                         
        {
            Value* va = new Value(); 
            va->primitivetypeIndex = STRING;  
            va->string_val.push_back($1);                     
            Expression* temp = new Expression($1, va, true, true); 
            temp->isTerminal = true; 
            temp->primary_exp_val = $1; 
            $$ = temp;
        }
        |       CHAR_LITERALS  
        {
            Value* va = new Value(); 
            va->primitivetypeIndex = CHAR;    
            va->string_val.push_back($1);                     
            Expression* temp = new Expression($1, va, true, true); 
            temp->isTerminal = true; 
            temp->primary_exp_val = $1; 
            temp->value->is_char_val = true;  
            $$ = temp;
        }
        |       BOOLEAN_LITERALS                                                        
        {
            Value* va = new Value(); 
            va->primitivetypeIndex = BOOLEAN; 
            va->boolean_val.push_back(strcmp($1, "true")==0); 
            Expression* temp = new Expression($1, va, true, true); 
            temp->isTerminal = true; 
            temp->primary_exp_val = $1; 
            temp->value->is_char_val = false; 
            $$ = temp;
        }

%%

int main(int argc, char **argv){
    if (argc != 3){
        if(argc == 4 && strcmp(argv[3], "--verbose") == 0) {
            yydebug = 1;        
        }
        else if (argc == 2 && strcmp(argv[1], "--help") == 0){
            printHelpCommand();
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

//     redirecting output to 3ac file
    fstream file;
    file.open(output_file, ios::out);
    streambuf* stream_buffer_cout = cout.rdbuf();
    streambuf* stream_buffer_file = file.rdbuf();
    cout.rdbuf(stream_buffer_file);

    LocalSymbolTable* locale = new LocalSymbolTable({0,0}, NULL);
    global_symtab->symbol_tables[0][0] = locale;

    yyparse();

//     does not work on windows systems :(
//     createSymbolTableCSV();

    fclose(yyin);
    // Redirect cout back to screen
    cout.rdbuf(stream_buffer_cout);
    file.close();
    return 0;
}

void yyerror (char const *s) {
   printf("\nError: %s. Line number %d\n\n", s, yylineno);
}