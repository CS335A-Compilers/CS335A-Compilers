#include "../bits/stdc++.h"

using namespace std;

enum ModifierType {PUBLIC, PROTECTED, PRIVATE, ABSTRACT, STATIC, SEALED, NONSEALED, STRICTFP, TRANSITIVE, FINAL, VOLATILE, SYNCHRONIZED, TRANSIENT, NATIVE, };
enum Types {CHAR, BYTE, SHORT, INT, LONG, FLOAT, DOUBLE, BOOLEAN, STRING, VOID, };
// symbol table entry is added whenever one of these declaration is done
enum DeclarationType {VARIABLE_DECLARATION, CLASS_DECLARATION, METHOD_DECLARATION, METHOD_INVOCATION, FIELD_METHOD_INVOCATION, IF_THEN_STATEMENT, IF_THEN_ELSE_STATEMENT, WHILE_STATEMENT, EXPRESSIONS, FOR_STATEMENT, TERNARY_EXPRESSION, BREAK_STATEMENT, CONTINUE_STATEMENT, DO_STATEMENT};

class Node {

    public:
        Node() = default;
        string lexeme;      //used for ast
        string name;        //used for symbol tables
        static int node_id;
        vector<Node*> children;
        bool isTerminal;
        bool isWritten;
        // stores the index of threeAC_list containing the instruction;
        vector<int> code;
        // stores the actual x86 instruction for the given expression
        vector<string> x86_64; 
        // stores the offset of any variable, field_variable or parameter relative to the function
        int offset;
        // denotes the callee saved registor number where the expression's value is stored
        int calleeSavedRegistorIndex;
        // stores the jump address for some expressions
        int entry_type;
        int line_no;
        bool is_parameter;
        pair<int, int> current_level;
        long long int id;
        // used to store temporary registor values for local variables only
        int reg_index;
        Node(string lex);
        pair<int,int> parent_level;
        void addChildren(vector<Node*> childrens);
};

class NormalClassDeclaration;

class Type : public Node{
    public :
        Type() = default;
        // gives enum index value of the data type
        // gives -1 if type is class_type;
        int primitivetypeIndex;
        NormalClassDeclaration* class_instantiated_from;
        Type(string lex, int primitivetype);
};

class Expression;

class IdentifiersList : public Node {
    public:
        vector<string> identifiers;
        // Expression* exp;
        IdentifiersList(string lex, string single_ident, vector<string> idents);
        string createString();
        void addIdentifiers(string lists);
};

class LocalVariableDeclaration;

// Need changes; 
class Value : public Node {
    public:
        // array is used to store both single variable or 1d array or 2d or 3d arrays;
        // value of -1 means that the variable is an object;
        int primitivetypeIndex;
        // long and int both stored in num_val itself
        vector<long long> num_val;
        vector<float> float_val;
        vector<double> double_val;
        vector<bool> boolean_val;
        vector<string> string_val;
        // for byte and short type, values are stored in int_val itself
        bool is_byte_val;
        bool is_short_val;
        //for char to check whether it is char or not
        bool is_char_val;
        // to access (say 2d array x[a][b]) we access by int_val[a*dim1_count + b*dim2_count];
        long long int dim1_count;
        long long int dim2_count;
        long long int dim3_count;
        // support for object values, maps from field members pointers to their current value;
        NormalClassDeclaration* class_type;
        map<LocalVariableDeclaration*, Value*> field_members;
        // use in printing 3ac code;
        string getValue();
        Value();
};

class Dims : public Node {
    public:
        int count_dims;
        Dims(string lex, int num);
};

class VariableDeclaratorId : public Node {
    public:
        string identifier;
        int num_of_dims;
        Value* initialized_value;
        string lex_val;
        VariableDeclaratorId(string lex, string identifier, int num, Value* initialized_value);
};

class VariableDeclaratorList : public Node {
    public:
        vector<VariableDeclaratorId*> lists;
        VariableDeclaratorList(string lex, VariableDeclaratorId* single_variable, vector<VariableDeclaratorId*> variables);
};

class FormalParameter : public Node{
    public:
        Type* param_type;
        bool isFinal;
        VariableDeclaratorId* variable_declarator_id;
        FormalParameter(string lex, Type* type, VariableDeclaratorId* variable_dec_id, bool isFinal);
};

class FormalParameterList : public Node{
    public:
        // this lists contains list of parameters, argument types, etc. 
        vector<FormalParameter*> lists;
        FormalParameterList(string lex, FormalParameter* single_parameter, vector<FormalParameter*> parameters);
};

class Modifier : public Node{
    public:
        ModifierType modifier_type;
        Modifier(ModifierType type, string lex);
};

class ModifierList : public Node{
    public:
        vector<Modifier*> lists;
        ModifierList(string lex, Modifier* single_modifier, vector<Modifier*> modifiers);
};

class LocalVariableDeclaration : public Node{
    public:
        Type* type;
        ModifierList* modifiers_lists;
        bool isFieldVariable;
        VariableDeclaratorId* variable_declarator;
        LocalVariableDeclaration(string lex, Type *t, VariableDeclaratorId *variable_decl_id, ModifierList *modif_lists);
};

class MethodDeclaration : public Node {
    public:
        ModifierList* modifiers;
        Type* type;
        FormalParameterList* formal_parameter_list;
        // stores the total size of the function to allocate to the stack
        int local_variables_size;
        bool isConstructor;
        // stores the index of callee saved registors which are used by the compiler for the given function
        vector<int> calleeRegCalled;
        // ReceiverParameter* receiver_parameter;
        // contructor
        MethodDeclaration(string lex);
        // copy constructor
        MethodDeclaration(const MethodDeclaration* obj);
};

// class ClassExtendList : public Node {

// };

class NormalClassDeclaration : public Node {
    public:
        ModifierList* modifiers_list;
        vector<pair<string, int>> field_variables;
        // ClassExtends* class_extends;
        int object_size;
        NormalClassDeclaration(string lex, ModifierList* list, string identifier ); 
};

class Expression : public Node {
    public:
        Value* value;
        // isPrimary is true if the expression is simple variable, object or literal
        bool isPrimary;
        bool isLiteral;
        // temp registor where expression is stored;
        int registor_index;
        // primary_exp_val have variable name or object name or literal value stored as string to use in 3ac generation;
        string primary_exp_val;
        string createString();
        Expression(string lex, Value* val, bool primary, bool literal);
};

class ExpressionList : public Node{
    public:
        vector<Expression*> lists;
        ExpressionList(string lex, Expression* single, vector<Expression*> expression_list);
};

// Helper funtion related to ast.h
bool addVariablesToSymtab(Type* t, VariableDeclaratorList* declarator_list, pair<int,int> curr_level, ModifierList* modif_lists, bool is_field_variable);
Value* createObject(string class_name, ExpressionList* exp_list, pair<int,int> curr_level);
Node* convertToAST(Node* root);
void  writeEdges(Node* root, FILE* file);
void  createDOT(Node* root, char* output_file);
void  createAST(Node* root, char* output_file);
Node* createNode(string str);
Node* cloneRoot(Node* root);
bool typenameErrorChecking(Node* node, pair<int,int> curr_level, int entry_type);
int create3ACCode(Node* root, bool print);
void createAsm(Node* root);
bool checkParams(string name, ExpressionList* exp_list);
int findEmptyCalleeSavedRegistor();
string convertOperator(string op);