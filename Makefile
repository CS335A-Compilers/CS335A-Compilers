all:
	bison -d -v parser.y
	flex scanner.l
	g++ -std=c++17 lex.yy.c parser.tab.c -o parser

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output parser parser.exe