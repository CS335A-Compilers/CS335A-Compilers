all:
	bison -d -v parser.y
	flex scanner.l
	g++ -std=c++17 lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp expression.cpp 3ac.cpp -o ASTGenerator

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output ASTGenerator *.svg *.dot output/*.csv *.txt