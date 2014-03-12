%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <map>

const double DEG=M_PI/180.0;

/***
TODO:
    
Add csc, sec, cot variants.

Add div, fld, rem, mod, gcd, lcm

Add support for integer types (maybe bigintegers?).

Bit shifting operations.
*/

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
        printf("Error: Variable %s does not exist.\n", name);
    else
        varlist.erase(item);
}

void printVar(const char *name)
{
    printf("\n%s =\n\n    %.12g\n\n", name, varlist[name]);
}

void printVars()
{
    varlist_iter first(varlist.begin()), last(varlist.end());

    while (first != last)
    {
        printf("%s = %.12g\n", first->first, first->second);
        ++first;
    }
    printf("\n");
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
%right UPLUS
%right KW_EXIT KW_DELETE KW_PRINT KW_WHO KW_CLEAR
%right FN_ABS FN_TRUNC FN_ROUND FN_FLOOR FN_CEIL FN_BINOM FN_SQRT FN_CBRT FN_HYPOT FN_EXPM1 FN_LDEXP FN_LOG2 FN_LOG10 FN_LOG1P FN_LOGB FN_ERF FN_ERFC FN_GAMMA FN_LGAMMA FN_LOG FN_EXP FN_ASINH FN_ACOSH FN_ATANH FN_SINH FN_COSH FN_TANH FN_ASIND FN_ACOSD FN_ATAND FN_SIND FN_COSD FN_TAND FN_ASIN FN_ACOS FN_ATAN2 FN_ATAN FN_SIN FN_COS FN_TAN FN_FACT

%type <value> Expression
%type <value> NUMBER
%type <name>  IDENTIFIER;

%%
Lines: /* empty */
     | Lines Expression EOL  { varlist["ans"]=$2; printVar("ans"); }
     | Lines IDENTIFIER EQUALS Expression EOL { varlist[$2] = $4; printVar($2); }
     | Lines KW_CLEAR EOL                  { varlist.clear(); }
     | Lines KW_CLEAR IDENTIFIER EOL       { varlist.erase($3); }
     | Lines KW_PRINT IDENTIFIER EOL       { printVar($3); }
     | Lines KW_DELETE IDENTIFIER EOL      { delVar($3); }
     | Lines KW_WHO EOL                    { printVars(); }
     | Lines KW_EXIT EOL                   { return EXIT_SUCCESS; }
     | Lines EOL
     | error EOL             
     ;

Expression: Expression FACT                   { $$ = fact($1); }
          | Expression POWER Expression	      { $$ = pow($1,$3); }
          | Expression DIVIDE Expression      { $$ = $1 / $3; }
          | Expression MODULO Expression      { $$ = ((int)$1) % ((int)$3); }
          | Expression TIMES Expression       { $$ = $1 * $3; }
          | Expression MINUS Expression	      { $$ = $1 - $3; }
          | Expression PLUS Expression	      { $$ = $1 + $3; }
          | LPAREN Expression RPAREN          { $$ = $2; }
          | MINUS Expression %prec UMINUS     { $$ = -$2; }
          | PLUS Expression %prec UPLUS       { $$ = $2; }
          | FN_BINOM LPAREN Expression COMMA Expression RPAREN { $$ = binom($3,$5); }
          | FN_FACT LPAREN Expression RPAREN  { $$ = fact($3); }
          | FN_ABS LPAREN Expression RPAREN { $$ = fabs($3); }
          | FN_TRUNC LPAREN Expression RPAREN { $$ = trunc($3); }
          | FN_ROUND LPAREN Expression RPAREN { $$ = round($3); }
          | FN_FLOOR LPAREN Expression RPAREN { $$ = floor($3); }
          | FN_CEIL LPAREN Expression RPAREN  { $$ = ceil($3); }
          | FN_SQRT LPAREN Expression RPAREN  { $$ = sqrt($3); }
          | FN_CBRT LPAREN Expression RPAREN  { $$ = cbrt($3); }
          | FN_HYPOT LPAREN Expression COMMA Expression RPAREN { $$ = hypot($3, $5); }
          | FN_EXP LPAREN Expression RPAREN   { $$ = exp($3); }
          | FN_EXPM1 LPAREN Expression RPAREN   { $$ = expm1($3); }
          | FN_LDEXP LPAREN Expression COMMA Expression RPAREN   { $$ = ldexp($3, $5); }
          | FN_LOG LPAREN Expression RPAREN   { $$ = log($3); }
          | FN_LOG2 LPAREN Expression RPAREN  { $$ = log2($3); }
          | FN_LOG10 LPAREN Expression RPAREN { $$ = log10($3); }
          | FN_LOG1P LPAREN Expression RPAREN { $$ = log1p($3); }
          | FN_LOGB LPAREN Expression RPAREN  { $$ = logb($3); }
          | FN_ERF LPAREN Expression RPAREN   { $$ = erf($3); }
          | FN_ERFC LPAREN Expression RPAREN  { $$ = erfc($3); }
          | FN_GAMMA LPAREN Expression RPAREN { $$ = gamma($3); }
          | FN_LGAMMA LPAREN Expression RPAREN { $$ = lgamma($3); }
          | FN_ASINH LPAREN Expression RPAREN { $$ = asinh($3); }
          | FN_ACOSH LPAREN Expression RPAREN { $$ = acosh($3); }
          | FN_ATANH LPAREN Expression RPAREN { $$ = atanh($3); }
          | FN_SINH LPAREN Expression RPAREN  { $$ = sinh($3); }
          | FN_COSH LPAREN Expression RPAREN  { $$ = cosh($3); }
          | FN_TANH LPAREN Expression RPAREN  { $$ = tanh($3); }
          | FN_ASIND LPAREN Expression RPAREN  { $$ = asin($3*DEG); }
          | FN_ACOSD LPAREN Expression RPAREN  { $$ = acos($3*DEG); }
          | FN_ATAND LPAREN Expression RPAREN  { $$ = atan($3*DEG); }
          | FN_SIND LPAREN Expression RPAREN   { $$ = sin($3*DEG); }
          | FN_COSD LPAREN Expression RPAREN   { $$ = cos($3*DEG); }
          | FN_TAND LPAREN Expression RPAREN   { $$ = tan($3*DEG); }
          | FN_ASIN LPAREN Expression RPAREN  { $$ = asin($3); }
          | FN_ACOS LPAREN Expression RPAREN  { $$ = acos($3); }
          | FN_ATAN2 LPAREN Expression COMMA Expression RPAREN  { $$ = atan2($3, $5); }
          | FN_ATAN LPAREN Expression RPAREN  { $$ = atan($3); }
          | FN_SIN LPAREN Expression RPAREN   { $$ = sin($3); }
          | FN_COS LPAREN Expression RPAREN   { $$ = cos($3); }
          | FN_TAN LPAREN Expression RPAREN   { $$ = tan($3); }
          | CNST_PI                           { $$ = M_PI; }
          | CNST_E                            { $$ = M_E; }
          | NUMBER                            { $$ = $1; }
          | IDENTIFIER                        { $$ = getVar($1); }
          ;

       ;

%%

int main()
{
    return calc_parse();
}

