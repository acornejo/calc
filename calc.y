%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <map>

#define MM_PI  3.14159265358979323846
#define MM_E   2.7182818284590452354

struct ltstr
{
   bool operator()(const char* s1, const char* s2) const
  {
     return strcmp(s1, s2) < 0;
  }
};

static std::map<const char *, double, ltstr> varlist;

double fact(const double &nv)
{
    if (nv < 0)
    {
        printf("Error: Cannot calculate factorial of %lf\n", nv);
        return -1;
    }

    size_t n=(size_t)nv, res=1;
    for (size_t i=1; i<=n; i++)
        res*=i;

    return (double)res;
}

int calc_error(char* errstr)
{
	printf("Error: %s\n", errstr);
	return EXIT_FAILURE;
}

extern int calc_lex();
%}

%union
{
    double value;
    char *name;
}

%token IDENTIFIER NUMBER EQUALS LPAREN RPAREN
%token CNST_PI CNST_E
%token EXIT EOL

%left PLUS MINUS
%left TIMES DIVIDE MODULO
%left FACT
%right POWER
%right UMINUS
%right FN_SQRT FN_LOG FN_LN FN_ASIN FN_ACOS FN_ATAN FN_SIN FN_COS FN_TAN

%type <value> Expression
%type <value> NUMBER
%type <value> Assignment
%type <name>  IDENTIFIER;

%%
Lines: /* empty */
     | Lines Expression EOL  { varlist["ans"]=$2;printf("%.12g\n", $2) }
     | Lines Assignment EOL  { printf("%.12g\n", $2) }
     | Lines EXIT EOL		 { return EXIT_SUCCESS; }
     | Lines EOL
     | error EOL             { printf("Please re-enter last line: "); }
     ;

Expression: Expression FACT                   { $$ = fact($1) }
          | Expression POWER Expression	      { $$ = pow($1,$3) }
          | Expression DIVIDE Expression      { $$ = $1 / $3 }
          | Expression MODULO Expression      { $$ = ((int)$1) % ((int)$3) }
          | Expression TIMES Expression       { $$ = $1 * $3 }
          | Expression MINUS Expression	      { $$ = $1 - $3 }
          | Expression PLUS Expression	      { $$ = $1 + $3 }
          | LPAREN Expression RPAREN          { $$ = $2 }
          | MINUS Expression %prec UMINUS     { $$ = -$2 }
          | FN_SQRT LPAREN Expression RPAREN  { $$ = sqrt($3) }
          | FN_LOG  LPAREN Expression RPAREN  { $$ = log($3)/log(10) }
          | FN_LN   LPAREN Expression RPAREN  { $$ = log($3) }
          | FN_ASIN LPAREN Expression RPAREN  { $$ = asin($3) }
          | FN_ACOS LPAREN Expression RPAREN  { $$ = acos($3) }
          | FN_ATAN LPAREN Expression RPAREN  { $$ = atan($3) }
          | FN_SIN LPAREN Expression RPAREN   { $$ = sin($3) }
          | FN_COS LPAREN Expression RPAREN   { $$ = cos($3) }
          | FN_TAN LPAREN Expression RPAREN   { $$ = tan($3) }
          | CNST_PI                           { $$ = MM_PI }
          | CNST_E                            { $$ = MM_E }
          | NUMBER                            { $$ = $1 }
          | IDENTIFIER                        { $$ = varlist[$1] }
          ;

Assignment: IDENTIFIER EQUALS Expression      { $$ = $3; varlist[$1] = $3 }
          ;
%%

int main()
{
    return calc_parse();
}

