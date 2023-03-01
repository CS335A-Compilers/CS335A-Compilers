name := $(MAKECMDGOALS)

.PHONY: all $(name) clean

$(name):
	bison -d -v parser.y
	flex scanner.l
	g++ -std=c++11 lex.yy.c parser.tab.c -o parser
	./parser < $@

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser.output parser parser.exe