mycompiler: lexer
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl

lexer: parser
	flex mylexer.l

parser: 
	bison -d -v -r all myanalyzer.y

clean:
	rm lex.yy.c\
		myanalyzer.output\
		myanalyzer.tab.c\
		myanalyzer.tab.h\
		mycompiler

tests:
	./mycompiler < correct1.pi > correct1.c
	./mycompiler < correct2.pi > correct2.c
	gcc correct1.c -o correct1 
	gcc correct2.c -o correct2 -lm