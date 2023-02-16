
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ABSTRACT_KEYWORD = 258,
     CONTINUE_KEYWORD = 259,
     FOR_KEYWORD = 260,
     NEW_KEYWORD = 261,
     SWITCH_KEYWORD = 262,
     ASSERT_KEYWORD = 263,
     DEFAULT_KEYWORD = 264,
     IF_KEYWORD = 265,
     PACKAGE_KEYWORD = 266,
     SYNCHRONIZED_KEYWORD = 267,
     BOOLEAN_KEYWORD = 268,
     DO_KEYWORD = 269,
     GOTO_KEYWORD = 270,
     PRIVATE_KEYWORD = 271,
     THIS_KEYWORD = 272,
     BREAK_KEYWORD = 273,
     DOUBLE_KEYWORD = 274,
     IMPLEMENTS_KEYWORD = 275,
     PROTECTED_KEYWORD = 276,
     THROW_KEYWORD = 277,
     BYTE_KEYWORD = 278,
     ELSE_KEYWORD = 279,
     IMPORT_KEYWORD = 280,
     PUBLIC_KEYWORD = 281,
     THROWS_KEYWORD = 282,
     CASE_KEYWORD = 283,
     ENUM_KEYWORD = 284,
     INSTANCEOF_KEYWORD = 285,
     RETURN_KEYWORD = 286,
     TRANSIENT_KEYWORD = 287,
     CATCH_KEYWORD = 288,
     EXTENDS_KEYWORD = 289,
     INT_KEYWORD = 290,
     SHORT_KEYWORD = 291,
     TRY_KEYWORD = 292,
     CHAR_KEYWORD = 293,
     FINAL_KEYWORD = 294,
     INTERFACE_KEYWORD = 295,
     STATIC_KEYWORD = 296,
     VOID_KEYWORD = 297,
     CLASS_KEYWORD = 298,
     FINALLY_KEYWORD = 299,
     LONG_KEYWORD = 300,
     STRICTFP_KEYWORD = 301,
     VOLATILE_KEYWORD = 302,
     CONST_KEYWORD = 303,
     FLOAT_KEYWORD = 304,
     NATIVE_KEYWORD = 305,
     SUPER_KEYWORD = 306,
     WHILE_KEYWORD = 307,
     __KEYWORD = 308,
     IDENTIFIERS = 309,
     LITERALS = 310,
     PRIMITIVE_TYPE_KEYWORDS = 311,
     PTR_OP = 312,
     EQ_OP = 313,
     GE_OP = 314,
     LE_OP = 315,
     NE_OP = 316,
     AND_OP = 317,
     OR_OP = 318,
     INC_OP = 319,
     DEC_OP = 320,
     LEFT_OP = 321,
     RIGHT_OP = 322,
     BIT_RIGHT_SHFT_OP = 323,
     ADD_ASSIGN = 324,
     SUB_ASSIGN = 325,
     MUL_ASSIGN = 326,
     DIV_ASSIGN = 327,
     AND_ASSIGN = 328,
     OR_ASSIGN = 329,
     XOR_ASSIGN = 330,
     MOD_ASSIGN = 331,
     LEFT_ASSIGN = 332,
     RIGHT_ASSIGN = 333,
     BIT_RIGHT_SHFT_ASSIGN = 334,
     ELLIPSIS = 335,
     DOUBLE_COLON = 336
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 10 "parser.y"

    int integer;
    float floating;
    char* string;
    char character;



/* Line 1676 of yacc.c  */
#line 142 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif

extern YYLTYPE yylloc;

