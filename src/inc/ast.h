#include "bits/stdc++.h"
// #include "symtab.h"

using namespace std;

class Node {

    public:
        Node() = default;
        string lexeme;      //used for ast
        string name;        //used for symbol tables
        static int node_id;
        vector<Node*> children;
        bool isTerminal; 
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

class ListNode : public Node{
    public:
        // this lists contains list of parameters, argument types, etc. 
        vector<Node*> lists;
        ListNode(string lex, Node* single_parameter, vector<Node*> parameters);
};

class FormalParameter : public Node{
    public:
        Type* param_type;
        bool isFinal;
        FormalParameter(string lex, Type* type, Node* identifier, bool isFinal);
};

class MethodDeclaration : public Node {
    public:
        ListNode* modifiers;
        Type* type;
        ListNode* formal_parameter_list;
        // ReceiverParameter* receiver_parameter;
        bool is_throw;
        MethodDeclaration(string lex);
};
