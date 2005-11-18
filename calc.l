
%{
#include "calc_parser.h"
#include "yy_readline.h"

%}

%option noyywrap

digit		[0-9]
integer     {digit}+
exponent    [eE][+-]?{integer}
real        {integer}("."{integer})?{exponent}?

%%

[ \t]+       { /* Skip blanks. */ }
{real}	     { calc_lval.value=atof(calc_text);
			   return NUMBER; }
"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return TIMES; }
"/"          { return DIVIDE; }
"^"          { return POWER; }
"("          { return LPAREN; }
")"          { return RPAREN; }
"sqrt"       { return FN_SQRT; }
"log"        { return FN_LOG; }
"asin"       { return FN_ASIN; }
"acos"       { return FN_ACOS; }
"atan"       { return FN_ATAN; }
"sin"        { return FN_SIN; }
"cos"        { return FN_COS; }
"tan"        { return FN_TAN; }
"pi"         { return CNST_PI; }
"e"          { return CNST_E; }
"exit"		 { return EXIT; }
\n           { return EOL; }

%%

