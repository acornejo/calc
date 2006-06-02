
%{
#include "calc_parser.hpp"
#include "yy_readline.h"

%}

%option noyywrap

digit		[0-9]
integer     {digit}+
exponent    [eE][+-]?{integer}
real        {integer}("."{integer})?{exponent}?
letter      [a-zA-Z]
identifier  {letter}+{integer}?

%%

[ \t]+       { /* Skip blanks. */ }
{real}	     { calc_lval.value=atof(calc_text);
			   return NUMBER; }
"="          { return EQUALS; }
"("          { return LPAREN; }
")"          { return RPAREN; }
"*"          { return TIMES; }
"/"          { return DIVIDE; }
"%"          { return MODULO; }
"^"          { return POWER; }
"+"          { return PLUS; }
"-"          { return MINUS; }
"!"          { return FACT; }
"sqrt"       { return FN_SQRT; }
"log"        { return FN_LOG; }
"ln"         { return FN_LN; }
"asin"       { return FN_ASIN; }
"acos"       { return FN_ACOS; }
"atan"       { return FN_ATAN; }
"sin"        { return FN_SIN; }
"cos"        { return FN_COS; }
"tan"        { return FN_TAN; }
"pi"         { return CNST_PI; }
"e"          { return CNST_E; }
"exit"		 { return EXIT; }
"ans"        { return PREVIOUS_ANSWER; }
{identifier} { calc_lval.name=strdup(calc_text);
               return IDENTIFIER; }
\n           { return EOL; }

%%

