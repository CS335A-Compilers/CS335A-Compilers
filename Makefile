name := $(MAKECMDGOALS)

.PHONY: all $(name) clean

$(name):
	bison -d -v parser.y
	flex -+ scanner.l
	g++ lex.yy.cc parser.tab.c -o parser
	./parser < $@

clean:
	rm -f lex.yy.cc parser.tab.c parser.tab.h parser.output parser parser.exe ast.dot