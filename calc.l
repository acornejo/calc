
%{
#include "calc_parser.hpp"
#include "yy_readline.h"

%}

%option noyywrap

blank       [ \t]+
comma       ","
digit		[0-9]
integer     {digit}+
exponent    [eE][+-]?{integer}
real        ({integer}("."{integer})?|"."{integer}){exponent}?
letter      [a-zA-Z]
identifier  {letter}+({digit}|{letter})*

%%

{blank}      { /* Skip blanks. */ }
{comma}      { return COMMA; }
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

"who"        { return KW_WHO; }
"print"      { return KW_PRINT; }
"del"        { return KW_DELETE; }
"clear"      { return KW_CLEAR; }
"exit"		 { return KW_EXIT; }

"abs"        { return FN_ABS; }
"round"      { return FN_ROUND; }
"trunc"      { return FN_TRUNC; }
"floor"      { return FN_FLOOR; }
"ceil"       { return FN_CEIL; }

"sqrt"       { return FN_SQRT; }
"cbrt"       { return FN_CBRT; }
"hypot"      { return FN_HYPOT; }
"exp"        { return FN_EXP; }
"expm1"      { return FN_EXPM1; }
"ldexp"      { return FN_LDEXP; }
"log"        { return FN_LOG; }
"log2"       { return FN_LOG2; }
"log10"      { return FN_LOG10; }
"log1p"      { return FN_LOG1P; }
"logb"       { return FN_LOGB; }
"erf"        { return FN_ERF; }
"erfc"       { return FN_ERFC; }
"gamma"      { return FN_GAMMA; }
"lgamma"     { return FN_LGAMMA; }

"fact"       { return FN_FACT;  }
"binom"      { return FN_BINOM; }

"asinh"      { return FN_ASINH; }
"acosh"      { return FN_ACOSH; }
"atanh"      { return FN_ATANH; }
"sinh"       { return FN_SINH; }
"cosh"       { return FN_COSH; }
"tanh"       { return FN_TANH; }
"asind"      { return FN_ASIND; }
"acosd"      { return FN_ACOSD; }
"atand"      { return FN_ATAND; }
"sind"       { return FN_SIND; }
"cosd"       { return FN_COSD; }
"tand"       { return FN_TAND; }
"asin"       { return FN_ASIN; }
"acos"       { return FN_ACOS; }
"atan2"      { return FN_ATAN2; }
"atan"       { return FN_ATAN; }
"sin"        { return FN_SIN; }
"cos"        { return FN_COS; }
"tan"        { return FN_TAN; }

"pi"         { return CNST_PI; }
"e"          { return CNST_E; }

{identifier} { calc_lval.name=strdup(calc_text);
               return IDENTIFIER; }
\n           { return EOL; }

%%

