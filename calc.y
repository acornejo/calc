%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <map>

#define MM_PI  3.14159265358979323846
#define MM_E   2.7182818284590452354

#define PROMPT ">>"

struct ltstr
{
   bool operator()(const char* s1, const char* s2) const
  {
     return strcmp(s1, s2) < 0;
  }
};

static std::map<const char *, double, ltstr> varlist;
typedef std::map<const char *, double, ltstr>::iterator varlist_iter;

double fact(const double &nv)
{
    if (nv < 0)
    {
        printf("Error: Cannot calculate factorial of %lf\n", nv);
        return -1;
    }

    size_t n=(size_t)nv;
    
    if (n < 13)
    {
        int ires=1;
        for (size_t i=1; i<=n; i++)
            ires*=i;

        return (double)ires;
    }
    else
    {
        double ires=1;
        for (double i=1; i<=nv; i++)
            ires*=i;

        return (double)ires;
    }
}

double binom(const double &n, const double &m)
{
    unsigned long B[(int)n+1];
    int i, j;

    B[0]=1;
    for (i=1; i<=n; i++)
    {
        B[i]=1;
        for (j=i-1; j>0; j--)
            B[j] += B[j-1];
    }
    return (double)B[(int)m];
}

double getVar(const char *name)
{
    if (varlist.find(name) == varlist.end())
    {
        printf("Error: Variable %s is not defined\n", name);
        return 0;
    }
    else
        return varlist[name];
}

void delVar(const char *name)
{
    varlist_iter item=varlist.find(name);

    if (item == varlist.end())
        printf("Error: Variable %s does not exist.\n%s ", name, PROMPT);
    else
        varlist.erase(item);
}

void printVar(const char *name)
{
    printf("\n%s =\n\n    %.12g\n\n%s ", name, varlist[name], PROMPT);
}

void printVars()
{
    varlist_iter first(varlist.begin()), last(varlist.end());

    while (first != last)
    {
        printf("%s = %.12g\n", first->first, first->second);
        ++first;
    }
    printf("\n%s ", PROMPT);
}

int calc_error(char* errstr)
{
	printf("Error: %s\n\n", errstr);
	return EXIT_FAILURE;
}

extern int calc_lex();
%}

%union
{
    double value;
    char *name;
}

%token IDENTIFIER COMMA NUMBER EQUALS LPAREN RPAREN
%token CNST_PI CNST_E
%token EOL

%left PLUS MINUS
%left TIMES DIVIDE MODULO
%left FACT
%right POWER
%right UMINUS
%right KW_EXIT KW_DELETE KW_PRINT KW_WHO KW_CLEAR
%right FN_FLOOR FN_CEIL FN_BINOM FN_SQRT FN_LOG FN_LN FN_ASIN FN_ACOS FN_ATAN FN_SIN FN_COS FN_TAN

%type <value> Expression
%type <value> NUMBER
%type <name>  IDENTIFIER;

%%
Lines: /* empty */
     | Lines Expression EOL  { varlist["ans"]=$2; printVar("ans") }
     | Lines IDENTIFIER EQUALS Expression EOL { varlist[$2] = $4; printVar($2) }
     | Lines KW_CLEAR EOL                  { varlist.clear() }
     | Lines KW_CLEAR IDENTIFIER EOL       { varlist.erase($3) }
     | Lines KW_PRINT IDENTIFIER EOL       { printVar($3) }
     | Lines KW_DELETE IDENTIFIER EOL      { delVar($3) }
     | Lines KW_WHO EOL                    { printVars() }
     | Lines KW_EXIT EOL                   { return EXIT_SUCCESS; }
     | Lines EOL                           { printf("%s ", PROMPT); }
     | error EOL             
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
          | FN_BINOM LPAREN Expression COMMA Expression RPAREN { $$ =
          binom($3,$5)}
          | FN_FLOOR LPAREN Expression RPAREN  { $$ = floor($3) }
          | FN_CEIL LPAREN Expression RPAREN  { $$ = ceil($3) }
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
          | IDENTIFIER                        { $$ = getVar($1) }
          ;

       ;

%%

int main()
{
    printf("%s ", PROMPT);
    return calc_parse();
}

