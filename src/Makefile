all:
	bison -d parser.y
	flex scanner.l
	g++ -std=c++11 lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp -o ASTGenerator

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output ASTGenerator *.svg *.dot