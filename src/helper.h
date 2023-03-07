#include "bits/stdc++.h"

using namespace std;

// enum TokenKind {KEYWORDS, IDENTIFIERS, SEPARATORS, OPERATORS, LITERALS, PRIMITIVE_TYPE_KEYWORDS};
enum ErrorKind {MULTI_LINE_ERROR, LEXICAL_ERROR, EOF_ERROR, ILLEGALCHAR, BADEXCAPESEQ};

static vector<string> LexicalErrors = {"Multilines not allowed.", "Lexical Error present.", "EOF File reached but there is unbalanced seperator", "Illegal character present.", "Bad excape sequence character present."};

extern string string_buffer;

void   init();
void   showError(string temp, enum ErrorKind errorCode);
void   pushBuffer(char* temp);
void   initBuffer(char* temp);
void   endBuffer(char* temp);
char*  convertExcapeChar(char x);
string convertCurrState(int state);
