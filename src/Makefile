all:
	bison -d -v parser.y
	flex scanner.l
	g++ lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp expression.cpp 3ac.cpp -o java-assembler

asm: $(ASMFILE)
	gcc -c $(word 2, $(MAKECMDGOALS)) -o test.o
	gcc test.o -o test

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output java-assembler *.svg *.dot output/*.csv *.txt *.3ac