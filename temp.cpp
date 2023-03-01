#include "bits/stdc++.h"
#include <stack>
#include <vector>
#include <iostream>
#include <unordered_set>
#include <utility>
#include <iterator>
#include <algorithm>
#include <numeric>

using namespace std;

#define f first
#define pb push_back
#define s second 

using ll = long long;
using vi = vector<int>;
using vc = vector<char>;
using vl = vector<long long int>;

#define rep(i,a,b) for (int i = (a); i < (b); i++)

int main(){
    // vector<string> temp = {"EQ_OP","GT_OP", "LT_OP", "EX_OP", "TL_OP", "QN_OP", "COLON_OP", "PLUS_OP", "MINUS_OP", "STAR_OP", "DIV_OP", "ND_OP", "BAR_OP", "RAISE_OP", "PCNT_OP", "COMMA_OP", "DOT_OP", "SEMICOLON_OP", "OP_BRCKT", "CLOSE_BRCKT", "OP_SQR_BRCKT", "CLOSE_SQR_BRCKT", "OP_CURLY_BRCKT", "CLOSE_CURLY_BRCKT", "AT_OP"};
    // vector<char> op = {'=', '>', '<', '!', '~', '?', ':', '+', '-', '*', '/', '&', '|', '^', '%', ',', '.', ';', '(', ')', '[', ']', '{', '}', '@'};
    // int n = temp.size(), m = op.size();
    // if(n!=m) cout<<"FUCK";
    // for(int i=0;i<n;i++){
    //     cout<<temp[i]<<"\n\t"<<": "<<"\t"<<"\'"<<op[i]<<"\'"<<"\t\t\t\t\t\t\t{Node* temp = createNode($1); $$ = temp;}\n";
    // }

    string str = "PTR_OP EQ_OP GE_OP  LE_OP  NE_OP  AND_OP  OR_OP  INC_OP  DEC_OP  LEFT_OP  RIGHT_OP  BIT_RIGHT_SHFT_OP ADD_ASSIGN  SUB_ASSIGN  MUL_ASSIGN  DIV_ASSIGN  AND_ASSIGN  OR_ASSIGN  XOR_ASSIGN  MOD_ASSIGN  LEFT_ASSIGN  RIGHT_ASSIGN  BIT_RIGHT_SHFT_ASSIGN  ELLIPSIS  DOUBLE_COLON DIAMOND";
    istringstream ss(str);
    string word;
    while (ss >> word){
        // string s2 = word;
        // transform(s2.begin(), s2.end(), s2.begin(), ::tolower);
        cout<<word<<"\n\t:\t"<<word<<"_TERMINAL\t\t\t\t\t\t\t{Node* temp = createNode($1); temp->isTerminal = true; $$ = temp;}\n\n";
        // cout<<word<<"_TERMINAL ";
    }
    return 0;
}