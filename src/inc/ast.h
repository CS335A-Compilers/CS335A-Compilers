#include <bits/stdc++.h>

using namespace std;

enum ModifierType {PUBLIC, PROTECTED, PRIVATE, ABSTRACT, STATIC, SEALED, NONSEALED, STRICTFP, TRANSITIVE, FINAL, VOLATILE, SYNCHRONIZED, TRANSIENT, NATIVE, };
enum Types {BYTE, SHORT, INT, LONG, CHAR, FLOAT, DOUBLE, BOOLEAN, VOID, };
// symbol table entry is added whenever one of these declaration is done
enum DeclarationType {VARIABLE_DECLARATION, CLASS_DECLARATION, METHOD_DECLARATION, PACKAGE_DECLARATION, IMPORT_DECLARATION, };

class Node {

    public:
        Node() = default;
        string lexeme;      //used for ast
        string name;        //used for symbol tables
        static int node_id;
        vector<Node*> children;
        bool isTerminal;
        DeclarationType entry_type;
        int line_no;
        long long int id;
        Node(string lex);
        void addChildren(vector<Node*> childrens);
};

class Type : public Node{
    public :
        // typeIndex gives primitive type index if type is primitve else gives -1;
        Type() = default;
        int primitivetypeIndex;
        Type(string lex, int primitivetype);
};

class VariableDeclaratorId : public Node {
    public:
        string identifier;
        int num_of_dims;    // currently assuming num of dims to 0;
        
        VariableDeclaratorId(string lex, string identifier, int num);
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

class MethodDeclaration : public Node {
    public:
        ModifierList* modifiers;
        Type* type;
        FormalParameterList* formal_parameter_list;
        // ReceiverParameter* receiver_parameter;
        // contructor
        MethodDeclaration(string lex);
        // copy constructor
        MethodDeclaration(const MethodDeclaration* obj);
};

// class TypeParamater : public Node {
//     public :

// };

// class TypeParameterList : public Node {
//     public:
//         vector<TypeParamter*> type_paramter_list;
//         TypeParameterList(string lex, TypeParameter* single_parameter, vector<TypeParameter*> parameters);
// };

// class ClassExtendList : public Node {

// };



class NormalClassDeclaration : public Node {
    public:
        ModifierList* modifiers_list;
        // TypeParameterList* type_parameters_list;
        // ClassExtends* class_extends;
        // ClassImplementList* class_implements_list;
        // ClassPermitList* class_permits_list;
        NormalClassDeclaration(string lex, ModifierList* list, string identifier ); 
};

// Helper funtion related to ast.h

Node* convertToAST(Node* root);
void  writeEdges(Node* root, FILE* file);
void  createDOT(Node* root, char* output_file);
void  createAST(Node* root, char* output_file);
Node* createNode(string str);
Node* cloneRoot(Node* root);