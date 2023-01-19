temp : la.l lex.yy.c a.exe 
	flex la.l
	gcc ./lex.yy.c
	./a.exe < ./tc.txt