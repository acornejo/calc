CC = gcc -O3

LEX = flex
YACC = bison


all: calc

calc: calc_parser.c calc_lexer.c
	$(CC) -lm -lreadline -o calc calc_parser.c calc_lexer.c

calc_lexer.c: calc.l calc_parser.h
	$(LEX)  -Pcalc_ -ocalc_lexer.c calc.l

calc_parser.c calc_parser.h: calc.y
	$(YACC) -pcalc_ -ocalc_parser.c -d calc.y
	
clean:
	rm calc_lexer.*
	rm calc_parser.*
	rm calc

