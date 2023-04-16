all:
	bison -d -v parser.y
	flex scanner.l
	g++ lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp expression.cpp 3ac.cpp -o milestone3

asm: $(ASMFILE)
	gcc -c $(word 2, $(MAKECMDGOALS)) -o test.o
	gcc test.o -o test

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output milestone3 *.svg *.dot output/*.csv *.txt *.3ac

# g++ -fno-asynchronous-unwind-tables -fno-exceptions -fno-rtti -S test.cpp