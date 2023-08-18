all:
	bison -d -v parser.y
	flex scanner.l
	g++ -std=c++11 lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp expression.cpp 3ac.cpp -o java-assembler

asm: $(ASMFILE)
	gcc -c $(word 2, $(MAKECMDGOALS)) -o test.o
	gcc test.o -o test

compile %.java:
	./java-assembler --input=$(word 2,$(MAKECMDGOALS)) --output=./test.s
	gcc -c ./test.s -o test.o
	gcc test.o -o test
	@echo './test'
	@./test || true
	@echo

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output java-assembler *.svg *.dot output/*.csv *.txt *.3ac *.o *.s *.exe

# To execute all the test cases inside ../tests/ directory
# for file in ../tests/*.java; do make compile $file; done
 
# To convert cpp file to assembly code, execute the following command
# g++ -fno-asynchronous-unwind-tables -fno-exceptions -S test.cpp