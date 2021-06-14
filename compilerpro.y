%{
	#include<stdio.h>
	#include<conio.h>
	#include<string.h>
	#include<math.h>
	
	int yylex();
	int yyparse();
	int yyerror(char *s);
	
	#define YYDEBUG 1
	#define mx 1024
	
	char vars[mx][mx];
	int type_Var[mx];
	int value_Int[mx];
	double value_Double[mx];
	char* value_String[mx];

	int varCnt = 0;

	int check(char *s){
		for(int i=0;i<varCnt;i++){
			if(strcmp(s,vars[i])==0){
				return i;
			}
		}
		return -1;
	}
%}

%union{
	int integer;
	double floating;
	char* string;
}

%error-verbose
%debug

%token INT DOUBLE STRING MAIN END START VAR T_INT T_DOUBLE T_CHAR INCREMENT DECREMENT FACT
%token WHILE FROM TO INC PRINT SWITCH CASE DEFAULT BREAK SIN COS TAN LOG10 LOG MAX MIN PRIME


%type <integer> INT MAIN END START program begin statement INTID INT_ID DOUBLEID DOUBLE_ID CHAR_ID CHARID 
%type <string> VAR T_INT T_DOUBLE T_CHAR STRING
%type <floating> expres DOUBLE

%nonassoc IF then
%nonassoc ELSE

%left '<' '>' EQUAL N_EQUAL L_EQUAL G_EQUAL
%left INCREMENT DECREMENT
%left  '+' '-'
%left  '*' '/' '%'
%right  '^'
%%


program:		MAIN START begin END			{printf("\nprogram end\n\n");}
		;

begin:											{printf("program beagan.\n");}	
		|		begin statement
		;

statement:		';'								{}
		|		expres	';'						{}

		|		declaration ';'					{printf("variable declared.\n");}
		
		|		PRINT '(' VAR ')' ';'				{
													int chk = check($3);
													if(chk==-1){
														printf("Unavailabe");
													}
													else{
														if(type_Var[chk]==0){
															printf("%s is an Integer.Value of %s is: %d\n",$3,$3,value_Int[chk]);
														}
														else if(type_Var[chk]==1){
															printf("%s is a Double.Value of %s is: %.4lf\n",$3,$3,value_Double[chk]);
														}
														else{
															printf("%s is a String.Value of %s is: %s\n",$3,$3,value_String[chk]);
														}
													}
												}

		|		FROM INT TO INT INC INT START expres END{
													for(int i=$2; i<=$4;i+=$6){
														printf("expression in %dth : %.4lf\n",i,$8);
													}
												}

		|		IF '(' expres ')' START expres ';' END	%prec then		{
														if($3){
															printf("Value of expression in if block is %.4lf\n",$5);
														}
														else{
															printf("Could not enter if block\n");
														}
													}

		|		IF expres START expres ';' END ELSE START expres ';' END	{
														if($2){
															printf("Value of expression in if block is %.4lf\n",$4);
														}
														else{
															printf("Value of expression in else block is %.4lf\n",$9);
														}
													}
		
		|		WHILE VAR INCREMENT '<' INT START expres END {
													int ix = check($2);
													if(ix==-1 || type_Var[ix]>0){
															printf("Error in incrementing: non integer value.\n");
														}
													else{
														int val = value_Int[ix];
														while(val++<$5){
															printf("Inside while loop.\nValue of expression: %.4lf\n",$7);
														}
													}
												}
		
		|		WHILE VAR DECREMENT '>' INT START expres END		{
														int ix = check($2);
														if(ix==-1 || type_Var[ix]>0){
															printf("Can't increment non integer value");
														}
														else{
															int val = value_Int[ix];
															while(val-->$5){
																printf("Inside while loop.\nValue of expression:%.4lf\n",$7);
															}
														}
													}

		|		SWITCH '(' expres ')' START B  END		{}
		
		;

B   : C
	| C D
    ;

C   : C '+' C
	| CASE INT ':' expres ';' BREAK ';' {}
	;

D   : DEFAULT ':' expres ';' BREAK ';' {}


declaration:
			  T_INT INTID
			
			| T_DOUBLE DOUBLEID
			
			| T_CHAR CHARID
			;

INTID	:
			  INTID ',' INT_ID
			| INT_ID

INT_ID: 
			 VAR '=' expres				{
											int ix = check($1);
											if(ix==-1){
												ix = varCnt;
												strcpy(vars[ix],$1);
												varCnt++;
												value_Int[ix] = (int)$3;
												type_Var[ix] = 0;
												printf("%s is stored at index :%d: with value :%d\n",$1,ix,value_Int[ix]);
											}
											else{
												printf("%s is already Declared\n",$1);
											}
											
										}
										
			| VAR 						{
											int ix = check($1);
											if(ix==-1){
												ix = varCnt;
												strcpy(vars[ix],$1);
												varCnt++;
												value_Int[ix] = 0;
												type_Var[ix] = 0;
												printf("%s is stored at index :%d: with value :%d\n",$1,ix,value_Int[ix]);
											}
											else{
												printf("%s is already Declared\n",$1);
											}
											
										}			
			;

DOUBLEID:
			  DOUBLEID ',' DOUBLE_ID
			| DOUBLE_ID

DOUBLE_ID: 
			  VAR '=' expres			{
											int ix = check($1);
											if(ix==-1){
												ix = varCnt;
												strcpy(vars[ix],$1);
												varCnt++;
												value_Double[ix] = $3;
												type_Var[ix] = 1;
												printf("%s is stored at index :%d: with value :%.6lf\n",$1,ix,value_Double[ix]);
											}
											else{
												printf("%s is already Declared\n",$1);
											}
											
										}

			| VAR 						{
											int ix = check($1);
											if(ix==-1){
												ix = varCnt;
												strcpy(vars[ix],$1);
												varCnt++;
												value_Double[ix] = 0;
												type_Var[ix] = 1;
												printf("%s is stored at index :%d: with value :%.6lf\n",$1,ix,value_Double[ix]);
											}
											else{
												printf("%s is already Declared\n",$1);
											}
											
										}			
			;

CHARID:
		  	  CHARID ',' CHAR_ID
			
			| CHAR_ID
			;
CHAR_ID: 
			  VAR '=' STRING			{
											int ix = check($1);
											if(ix==-1){
												ix = varCnt;
												strcpy(vars[ix],$1);
												varCnt++;
												value_String[ix] = $3;
												type_Var[ix] = 2;
												printf("%s is stored at index :%d: with value :%s\n",$1,ix,value_String[ix]);
											}
											else{
												printf("%s is already Declared\n",$1);
											}
											
										}

			| VAR 						{
											int ix = check($1);
											if(ix==-1){
												ix = varCnt;
												strcpy(vars[ix],$1);
												varCnt++;
												value_String[ix] = "";
												type_Var[ix] = 2;
												printf("%s is stored at index :%d: with value :%s\n",$1,ix,value_String[ix]);
											}
											else{
												printf("%s is already Declared\n",$1);
											}
											
										}			
			;


expres:		 INT 	{$$ = $1;}
			
			| DOUBLE {$$ = $1;}

			| VAR 						{
											int ix = check($1);
											if(ix==-1){
												printf("No such variable\n");
											}
											else{
												if(type_Var[ix]==0)
													$$ = value_Int[ix];
												else if(type_Var[ix]==1){
													$$ = value_Double[ix];
												}
												else{
													printf("Can't assign string to numeric values\n");
												}
											}
										}

			| expres '+' expres {$$ = $1 + $3;}

			| expres '-' expres {$$ = $1 - $3;}
			
			| expres '*' expres {$$ = $1 * $3;}
			
			| expres '/' expres {$$ = $1 / $3;}
			
			| expres '^' expres {$$ = powl($1,$3);}
			
			| expres '%' expres {
								int x1 = ceil($1);
								int x2 = floor($1);
								int y1 = ceil($3);
								int y2 = floor($3);
								if(x1==x2 && y1==y2){
									$$ = (int) $1 % (int) $3;
								}
							}
			
			| expres '>' expres {$$ = ($1 > $3);}
			
			| expres '<' expres {$$ = ($1 < $3);}
			
			| expres EQUAL expres {$$ = ($1 ==$3);}
			
			| expres N_EQUAL expres {$$ = ($1!=$3);}
			
			| expres L_EQUAL expres {$$ = ($1<=$3);}
			
			| expres G_EQUAL expres {$$ = ($1<=$3);}

			| SIN '(' expres ')' 					{
														float x = sin($3*3.1416/180);
														printf("Value of Sin is %f.\n",x); $$=sin($3*3.1416/180);
													}

			| COS '(' expres ')' 					{
														float x = cos($3*3.1416/180);
														printf("Value of Cos is %f.\n",x); $$=cos($3*3.1416/180);
													}

			| TAN '(' expres ')' 					{
														float x = tan($3*3.1416/180);
														printf("Value of Tan is %f.\n",x); $$=tan($3*3.1416/180);
													}

			| LOG10 '(' expres ')' 					{
														float x = (log($3*1.0)/log(10.0));
														printf("Value of Log10 is %f.\n",x); $$=(log($3*1.0)/log(10.0));
													}

			| LOG '(' expres ')'					{
														float x = (log($3));
														printf("Value of Log is %f.\n",x); $$=(log($3));
													}

			| MAX '(' expres ',' expres ')'			{
														int a = $3;
														int b = $5;
														if(a>b){
															printf("%d is greater.\n",a);
														}
														else{
															printf("%d is greater.\n",b);
														}
													}
			| MIN '(' expres ',' expres ')'			{
														int a = $3;
														int b = $5;
														if(a<b){
															printf("%d is smaller.\n",a);
														}
														else{
															printf("%d is smaller.\n",b);
														}
													}

			| PRIME '(' expres ')'					{
														int i = 2;
														int x = $3;
														int chk = 0;
														for(i=2;i<=x/2;i++)
														{
															if(x%i==0)
															{
																printf("%d is not prime.\n",x);
																chk = 1;
																break;
															}
														}
														if(!chk) printf("%d is prime.\n",x);
														
													}

			| FACT '(' expres ')'					{
														int x = $3;
														if(x==0) printf("\nFactorial of %d is 1.\n",x);
														else{
															int ans=1,i;
															for(i=2;i<=x;i++)
																ans*=i;
															printf("\nFactorial of %d is %d.\n",x,ans);
														}
													}
			;

%%


