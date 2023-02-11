name := $(MAKECMDGOALS)

.PHONY: all $(name) clean

$(name):
	bison -d q4.y
	flex q4.l
	gcc lex.yy.c q4.tab.c -o parser
	./parser.exe < $@

clean:
	rm -f lex.yy.c q4.tab.c q4.tab.h parser