name := $(MAKECMDGOALS)

.PHONY: all $(name)

$(name):
	flex la.l
	gcc ./lex.yy.c
	./a.exe < $@

clean : 
	rm -f ./lex.yy.c output.csv ./a.exe