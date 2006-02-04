/* A Bison parser, made by GNU Bison 2.0.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     LPAREN = 259,
     RPAREN = 260,
     CNST_PI = 261,
     CNST_E = 262,
     EXIT = 263,
     EOL = 264,
     MINUS = 265,
     PLUS = 266,
     UMINUS = 267,
     POWER = 268,
     DIVIDE = 269,
     TIMES = 270,
     FN_TAN = 271,
     FN_COS = 272,
     FN_SIN = 273,
     FN_ATAN = 274,
     FN_ACOS = 275,
     FN_ASIN = 276,
     FN_LOG = 277,
     FN_SQRT = 278,
     XOR = 279,
     OR = 280,
     AND = 281
   };
#endif
#define NUMBER 258
#define LPAREN 259
#define RPAREN 260
#define CNST_PI 261
#define CNST_E 262
#define EXIT 263
#define EOL 264
#define MINUS 265
#define PLUS 266
#define UMINUS 267
#define POWER 268
#define DIVIDE 269
#define TIMES 270
#define FN_TAN 271
#define FN_COS 272
#define FN_SIN 273
#define FN_ATAN 274
#define FN_ACOS 275
#define FN_ASIN 276
#define FN_LOG 277
#define FN_SQRT 278
#define XOR 279
#define OR 280
#define AND 281




#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 11 "calc.y"
typedef union YYSTYPE {
    double value;
} YYSTYPE;
/* Line 1318 of yacc.c.  */
#line 93 "calc_parser.h"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE calc_lval;



