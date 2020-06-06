/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <sstream>
#include <algorithm>
#include <cstring>
#include "cool-parse.h"
#include "stringtab.h"
#include "utilities.h"

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

inline void clear_buf(){
  string_buf_ptr = string_buf;
  *string_buf_ptr = '\0';
}

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

int comment_nested;

char* unescape_string(const char *s)
{
  std::stringstream ss{};
  bool escape{false};
  while (*s) {
    switch (*s) {
      case '\\' :
        if(escape){
          ss << '\\';
          escape = false;
        } else {
          escape = true;
        }
        break;
      case 'n':
        if (!escape){
          ss << 'n';
        } else {
          ss << '\n';
        }
        escape = false;
        break;
      case 't':
        if (!escape){
          ss << 't';
        } else {
          ss << '\t';
        }
        escape = false;
        break;
      case 'f':
        if (!escape){
          ss << 'f';
        } else {
          ss << '\f';
        }
        escape = false;
        break;
      case 'b':
        if (!escape){
          ss << 'b';
        } else {
          ss << '\b';
        }
        escape = false;
        break;
      default:
        escape = false;
        ss << *s;
        break;
    }
    s++;
  }

  std::string str = ss.str();
  return strdup(str.c_str());
}

%}

/*
 * Define names for regular expressions here.
 */

%Start COMMENT
%Start STRING


COMMENT_S \(\*
COMMENT_E \*\)

DARROW    =>
ASSIGN    <-
LE        <=

upper     [A-Z]
lower     [a-z]
digit     [0-9]
alpha     {upper}|{lower}
aldig     {alpha}|{digit}
aldig_    {aldig}|_
space     [ \t]

number    {digit}+
character [^"\0\n\\]

%%

--.* ;

 /*
  *  Nested comments
  */

{COMMENT_S} {
  comment_nested ++;
  BEGIN COMMENT;
}

<COMMENT>.*{COMMENT_E}{space}* {
  comment_nested--;
  if(comment_nested <= 0){
    BEGIN 0;
    comment_nested = 0;
  }
}

<COMMENT>.+ ;

<COMMENT><<EOF>> {
  yylval.error_msg = "‘EOF in comment";
  BEGIN 0;
  return ERROR;
}

{COMMENT_E} {
  yylval.error_msg = "‘Unmatched *)";
  return ERROR;
}

 /*
  *  The multiple-character operators.
  */
{DARROW}    return DARROW;
{ASSIGN}    return ASSIGN;
{LE}        return LE;

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */

(?i:class)       return CLASS;
(?i:if)          return IF;
(?i:fi)          return FI;
(?i:in)          return IN;
(?i:else)        return ELSE;
(?i:inherits)    return INHERITS;
(?i:let)         return LET;
(?i:loop)        return LOOP;
(?i:pool)        return POOL;
(?i:then)        return THEN;
(?i:while)       return WHILE;
(?i:case)        return CASE;
(?i:esac)        return ESAC;
(?i:of)          return OF;
(?i:new)         return NEW;
(?i:isvoid)      return ISVOID;

t(?i:rue) {
  yylval.boolean = true;
  return BOOL_CONST;
}

f(?i:alse) {
  yylval.boolean = false;
  return BOOL_CONST;
}

{number} {
  yylval.symbol = inttable.add_string(yytext);
  return INT_CONST;
}

{upper}{aldig_}* {
  yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}

{lower}{aldig_}* {
  yylval.symbol = idtable.add_string(yytext);
  return OBJECTID;
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for
  *  \n \t \b \f, the result is c.
  *
  */

\'\\?.\' {
  yylval.symbol = stringtable.add_string(unescape_string(yytext));
  return STR_CONST;
}

<STRING>{character}*\" {
  BEGIN 0;

  auto sz = string_buf_ptr - string_buf;
  if(sz + yyleng > MAX_STR_CONST){
    yylval.error_msg = "String constant too long";
    return ERROR;
  }

  char* str = strdup(yytext);
  str[yyleng-1] = '\0';
  strcat(string_buf, str);
  string_buf_ptr += yyleng - 1;
  sz = string_buf_ptr - string_buf;

  yylval.symbol = stringtable.add_string(string_buf);
  clear_buf();
  return STR_CONST;
}

\" {
  BEGIN STRING;
  string_buf_ptr = string_buf;
}

<STRING>\\(.|\n) {
  char* ch = yytext+1;
  char* outp;
  switch(*ch){
    case 'n': outp = "\n"; break;
    case 't': outp = "\t"; break;
    case 'f': outp = "\f"; break;
    case 'b': outp = "\b"; break;
    case '\n':
      curr_lineno++;
      outp = "\n";
      break;
    default:
      outp = ch;
  }
  strcat(string_buf, outp);
  string_buf_ptr++;
}

<STRING>\n {
  curr_lineno++;
  yylval.error_msg = "Unterminated string constant";
  //printf("strbuf %s\n",string_buf);
  BEGIN 0;
  clear_buf();
  return ERROR;
}

<STRING>\0{character}*(\"|\n) {
  yylval.error_msg = "String contains null character";
  BEGIN 0;
  clear_buf();
  return ERROR;
}

<STRING><<EOF>> {
  yylval.error_msg = "EOF in string constant";
  BEGIN 0;
  clear_buf();
  return ERROR;
}

<STRING>{character}+ {
  //printf("text %s\n",yytext);
  strcat(string_buf, yytext);
  string_buf_ptr += yyleng;
}

[(){}<>=:,;@+\-*/~.\[\]] return yytext[0];

\n curr_lineno++;

[ \t\b\f] ;

%%
