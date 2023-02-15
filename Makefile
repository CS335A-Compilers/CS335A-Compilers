name := $(MAKECMDGOALS)

.PHONY: all $(name) clean

$(name):
	bison -d -v parser.y
	flex scanner.l
	gcc lex.yy.c parser.tab.c -o parser
	./parser.exe < $@

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h parser