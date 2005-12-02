%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MM_PI  3.14159265358979323846
#define MM_E   2.7182818284590452354
%}

%union
{
    double value;
}

%token NUMBER LPAREN RPAREN
%token CNST_PI CNST_E
%token EXIT EOL

%left  PLUS MINUS
%right POWER UMINUS
%left  TIMES DIVIDE
%right FN_SQRT FN_LOG FN_ASIN FN_ACOS FN_ATAN FN_SIN FN_COS FN_TAN

%type <value> Expression
%type <value> NUMBER

%%
Lines: /* empty */
     | Lines Expression EOL  { printf("%.12g\n", $2) }
     | Lines EXIT EOL		 { return EXIT_SUCCESS; }
     | Lines EOL
     | error EOL             { printf("Please re-enter last line: "); }
     ;

Expression: Expression TIMES Expression	      { $$ = $1 * $3 }
          | Expression DIVIDE Expression      { $$ = $1 / $3 }
          | Expression POWER Expression       { $$ = pow($1, $3) }
          | Expression MINUS Expression	      { $$ = $1 - $3 }
          | Expression PLUS Expression	      { $$ = $1 + $3 }
          | LPAREN Expression RPAREN          { $$ = $2 }
          | MINUS Expression %prec UMINUS     { $$ = -$2 }
          | FN_SQRT LPAREN Expression RPAREN  { $$ = sqrt($3) }
          | FN_LOG  LPAREN Expression RPAREN  { $$ = log($3) }
          | FN_ASIN LPAREN Expression RPAREN  { $$ = asin($3) }
          | FN_ACOS LPAREN Expression RPAREN  { $$ = acos($3) }
          | FN_ATAN LPAREN Expression RPAREN  { $$ = atan($3) }
          | FN_SIN LPAREN Expression RPAREN   { $$ = sin($3) }
          | FN_COS LPAREN Expression RPAREN   { $$ = cos($3) }
          | FN_TAN LPAREN Expression RPAREN   { $$ = tan($3) }
          | CNST_PI                       { $$ = MM_PI }
          | CNST_E                        { $$ = MM_E }
          | NUMBER
          ;
%%

int main()
{
    return yyparse();
}

int yyerror(char* errstr)
{
	printf("Error: %s\n", errstr);
	return EXIT_FAILURE;
}

