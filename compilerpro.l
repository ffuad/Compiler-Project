%{
	#include "compilerpro.tab.h"
	#include <string.h>
	extern int yydebug;
	int yyparse();
%}

%%
"main"											{return MAIN;}
"{"												{return START;}
"}"												{return END;}

"int"											{return T_INT;}
"double"										{return T_DOUBLE;}
"string"										{return T_CHAR;}

"if"											{return IF;}
"else"											{return ELSE;}
"while"											{return WHILE;}
"inc"											{return INC;}

"switch"										{return SWITCH;}
"case"											{return CASE;}
"default"										{return DEFAULT;}
"break"											{return BREAK;}


"from"											{return FROM;}
"to"											{return TO;}

[#].*											printf("\nSingle line comment. \n");

"++"											{return INCREMENT;}
"--"											{return DECREMENT;}
"=="											{return EQUAL;}
"!="											{return N_EQUAL;}
">="											{return G_EQUAL;}
"<="											{return L_EQUAL;}

"print"											{return PRINT;}


SIN												{return SIN;}
COS												{return COS;}
TAN												{return TAN;}
LOG												{return LOG;}
LOG10 											{return LOG10;}

MAX												{return MAX;}
MIN												{return MIN;}
PRIME											{return PRIME;}
FACT											{return FACT;}


[0-9]+															{yylval.integer = atoi(yytext);return INT;}
[-+]?[0-9]*[.][0-9]+([eE][+-]?[0-9]+)?							{yylval.floating = atof(yytext);return DOUBLE;}
[A-Za-z0-9]+													{yylval.string = strdup(yytext);return VAR;}
\"(\\.|[^"\\])*\"												{yylval.string = strdup(yytext);return STRING;}
[-+/*<>=,();%^]													{return yytext[0];}
[\t]															{}
[\n]															{}
.																{}
%%

int yywrap(){
	return 1;
}

int main(int argc, char **argv){
	yyin = fopen("input.txt","r");
	yyparse();
	return 0;
}

int yyerror(char *s){
	fprintf(stderr,"error: %s\n", s);
}