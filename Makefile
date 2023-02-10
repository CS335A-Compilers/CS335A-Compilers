all: q4.l q4.y
	bison -d q4.y
	flex q4.l
	gcc lex.yy.c q4.tab.c -o parser
	./parser.exe < test.txt