CC = g++ -O3

LEX = flex
YACC = bison


all: calc

calc: calc_parser.cpp calc_lexer.cpp
	$(CC) -o calc calc_parser.cpp calc_lexer.cpp -lm -lreadline

calc_lexer.cpp: calc.l calc_parser.hpp
	$(LEX)  -Pcalc_ -ocalc_lexer.cpp calc.l

calc_parser.cpp calc_parser.hpp: calc.y
	$(YACC) -pcalc_ -ocalc_parser.cpp -d calc.y

small:
	strip -x calc
	upx calc

clean:
	rm calc_lexer.*
	rm calc_parser.*
	rm calc

