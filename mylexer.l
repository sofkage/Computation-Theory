%{
	#include <stdio.h>
	#include <string.h>
	#include "cgen.h"
	#include <math.h>
	#include "myanalyzer.tab.h"

	int line_num = 1;

%}



ID      	[a-zA-Z][0-9a-zA-Z_]*
DIGIT   	[0-9]
NUMBER  	{DIGIT}{DIGIT}*
DECIMAL 	("."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL   		{DECIMAL}([eE][+-]?{NUMBER})?
CHARACTER   [., a-zA-Z0-9\-+\*\/:_$!#@&~^()]|[\\n]|[\\t]|[\\r]|[\\\\]
STRING 		\"{CHARACTER}*\"


%x comment

%%

int         return KW_INT;
real        return KW_REAL;
string      return KW_STRING;
char		return KW_CHAR;
bool        return KW_BOOL;
true        return KW_TRUE; 
false       return KW_FALSE; 
var         return KW_VAR;
const       return KW_CONST;
if          return KW_IF;
else        return KW_ELSE;
for         return KW_FOR;
while       return KW_WHILE;
break       return KW_BREAK;
continue    return KW_CONTINUE;
func        return KW_FUNC;
nil         return KW_NIL;
and         return KW_AND;
or          return KW_OR;
not         return KW_NOT;
return      return KW_RETURN;
begin       return KW_BEGIN;

{ID}        { yylval.crepr = strdup(yytext); return IDENT; }
{STRING}    { yylval.crepr = strdup(yytext); return STRING; }
{NUMBER}    { yylval.crepr = strdup(yytext); return NUMBER; }
{REAL}      { yylval.crepr = strdup(yytext); return REAL; }

";" return ';';
")"	return ')';
"("	return '(';
"["	return '[';
"]"	return ']';
"{"	return '{';
"}"	return '}';
","	return ',';


"+" 	return '+';
"="		return '=';
"-"		return '-';
"/"		return '/';
"%"		return '%';
"*"		return '*';
"**"	return TK_OP_POW;
"=="	return TK_OP_EQUAL;
"!="	return TK_OP_NOTEQ;
"<"	  	return TK_OP_SMALLER;
">"	  	return TK_OP_BIGGER;
"<="	return TK_OP_SMALLEQ;
">="	return TK_OP_BIGEQ;




"//"[^\n]*  	/* eat line comments */

"/*"		BEGIN(comment);

<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);

[ \r\t]		/* skip whitespace */
\n 		++line_num;

<<EOF>> 	return EOF;

.           {yyerror("lexical error: unrecognized literal '%s in line %d' \n", yytext,line_num); }


%%

