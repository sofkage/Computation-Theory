%{
  #include <stdio.h>
  #include "cgen.h"
 #include <math.h>

  extern int yylex(void);
  extern int line_num;


%}


%union  // our memory 
{
	char* crepr;
}


%define parse.error verbose

%token <crepr> STRING
%token <crepr> IDENT
%token <crepr> NUMBER
%token <crepr> REAL 

%token KW_INT  
%token KW_REAL  
%token KW_STRING  
%token KW_BOOL 
%token KW_CHAR 
%token KW_TRUE 
%token KW_FALSE 
%token KW_VAR  
%token KW_CONST  
%token KW_IF  
%token KW_ELSE  
%token KW_ELSE_LOW_PRIOR  
%token KW_FOR  
%token KW_WHILE  
%token KW_BREAK  
%token KW_CONTINUE  
%token KW_FUNC  
%token KW_NIL  
%token KW_AND 
%token KW_OR  
%token KW_NOT
%token KW_RETURN  
%token KW_BEGIN  

%token TK_OP_NOTEQ
%token TK_OP_EQUAL
%token TK_OP_SMALLER
%token TK_OP_BIGGER
%token TK_OP_SMALLEQ
%token TK_OP_BIGEQ
%token TK_OP_POW

%type <crepr> body func_decl func_input
%type <crepr> func_body func_call begin_func
%type <crepr> identifier identifier_init var const
%type <crepr> expr stmt parameters
%type <crepr> data_type
%type <crepr> instr_list instr assign_instr complex_instr


%start program



/* PRIORITIES  */
 
%right KW_NOT
%right SIGN_OP //override gia telestes proshmou 
%right TK_OP_POW
%left '*' '/' '%'
%left '+' '-'
%left TK_OP_EQUAL TK_OP_NOTEQ TK_OP_BIGGER TK_OP_BIGEQ TK_OP_SMALLER TK_OP_SMALLEQ 
%left KW_AND
%left KW_OR
%nonassoc KW_ELSE_LOW_PRIOR
%nonassoc KW_ELSE



%%
  program: body
  {
  /* We have a successful parse! 
      Check for any errors and generate output. 
    */
    
    if (yyerror_count == 0) {
      puts("#include <math.h>\n");
      puts(c_prologue); 
      printf("/* program */ \n\n");
      printf("%s\n\n", $1);
      
    }
  };

  //anagnwristika - den sympiptoyn me tis lekseis kleidia 
  identifier:
              IDENT                   {$$ = $1;}
            | IDENT '=' expr          {$$ = template("%s = %s", $1, $3);}
            | IDENT ',' identifier    {$$ = template("%s , %s", $1, $3);}
            | IDENT '=' expr ',' identifier   {$$ = template("%s = %s , %s", $1, $3, $5);}
            ;

 // prepei opwsdhpote na exw expr, dhladh anathesi timhs
  identifier_init:
                  IDENT '=' expr          {$$ = template("%s = %s", $1, $3);}
                | IDENT '=' expr ',' identifier_init   {$$ = template("%s = %s , %s", $1, $3, $5);}


  var:
        KW_VAR identifier  data_type ';'  {$$ = template("%s %s;\n", $3, $2);}
      | KW_VAR IDENT'['NUMBER']' data_type ';'  {$$ = template("%s %s[%s];\n", $6, $2, $4);}
      | KW_VAR IDENT'['']' data_type ';'  {$$ = template("%s %s[];\n", $5, $2);}

      ;

  const:
    KW_CONST identifier_init data_type ';' {$$ = template("const %s %s;\n", $3, $2);}
    ;

  expr:
        KW_NOT expr                 {$$ = template("NOT %s", $2);}
      | '+' expr %prec SIGN_OP      {$$ = template("+%s", $2);}
      | '-' expr %prec SIGN_OP      {$$ = template("-%s", $2);}
      | expr TK_OP_POW expr         {$$ = template("pow(%s, %s)", $1, $3);}
      | expr '*' expr               {$$ = template("%s * %s", $1, $3);}
      | expr '/' expr               {$$ = template("%s / %s", $1, $3);}
      | expr '%' expr               {$$ = template("%s %% %s", $1, $3);}
      | expr '+' expr               {$$ = template("%s + %s", $1, $3);}
      | expr '-' expr               {$$ = template("%s - %s", $1, $3);}
      | expr TK_OP_EQUAL expr       {$$ = template("%s == %s", $1, $3);}
      | expr TK_OP_NOTEQ expr       {$$ = template("%s != %s", $1, $3);}
      | expr TK_OP_SMALLER expr     {$$ = template("%s < %s", $1, $3);}
      | expr TK_OP_BIGGER expr      {$$ = template("%s > %s", $1, $3);}
      | expr TK_OP_SMALLEQ expr     {$$ = template("%s <= %s", $1, $3);}
      | expr TK_OP_BIGEQ expr       {$$ = template("%s >= %s", $1, $3);}
      | expr KW_AND expr            {$$ = template("%s && %s", $1, $3);}
      | expr KW_OR expr             {$$ = template("%s | %s", $1, $3);}
      | '('expr')'                  {$$ = template("(%s)", $2);} 
      | func_call                   {$$ = $1;}
      | IDENT                       {$$ = $1;}
      | IDENT'['expr']'           {$$ = template("%s[%s]", $1, $3);}
      | STRING                      {$$ = $1;}
      | REAL                        {$$ = $1;}
      | NUMBER                      {$$ = $1;}
      | KW_TRUE                     {$$ = template("1");}
      | KW_FALSE                    {$$ = template("0");}
      | KW_NIL                      {$$ = template("NULL");}
      ;

  func_body: 
            %empty                 {$$ = template("");}    
          | var func_body          {$$ = template("\t%s%s", $1, $2);}
          | const func_body        {$$ = template("\t%s%s", $1, $2);}
          | instr func_body        {$$ = template("\t%s%s", $1, $2);}
          ;


  func_decl:
            KW_FUNC IDENT '('parameters')' data_type '{' func_body '}'           {$$ = template("%s %s (%s) {\n%s}\n\n", $6, $2, $4, $8);}
          | KW_FUNC IDENT '('parameters')' '[' ']' data_type '{' func_body '}'   {$$ = template("%s* %s (%s) {\n%s}\n\n", $8, $2, $4, $10);}
          | KW_FUNC IDENT '('parameters')' '{' func_body '}'                          {$$ = template("void %s (%s) {\n%s}\n\n", $2, $4, $7);}
          ;

 func_call:
          IDENT'('func_input ')' {$$ = template("%s(%s)", $1, $3);}
          ;

 func_input:
          %empty                {$$ = template("");}
          |expr ',' func_input  {$$ = template("%s , %s", $1, $3);}
          |expr                 {$$ = $1;}
          ;

  parameters:
              %empty                                 {$$ = template("\n");}
            | IDENT data_type                       {$$ = template("%s %s", $2, $1);}
            | IDENT '['']' data_type                {$$ = template("%s* %s", $4, $1);}
            | IDENT data_type ',' parameters        {$$ = template("%s %s, %s", $2, $1, $4);}
            | IDENT '['']' data_type ',' parameters {$$ = template("%s* %s, %s", $4, $1, $6);}
            ;
            
  begin_func:
             KW_FUNC KW_BEGIN '(' ')' '{' func_body '}' {$$ = template("int main() {\n%s}\n", $6);}
             ;

  body: 
        %empty            {$$ = template("\n");}
      | body const        {$$ = template("%s%s", $1, $2);}
      | body var          {$$ = template("%s%s", $1, $2);}
      | body func_decl         {$$ = template("%s%s", $1, $2);}
      | body begin_func   {$$ = template("%s%s", $1, $2);}
      ;


        

  instr: 
          assign_instr ';'                                            {$$ = template("%s;\n", $1);}
        | KW_IF '('expr')' stmt %prec KW_ELSE_LOW_PRIOR               {$$ = template("if (%s) %s\n", $3, $5);}
        | KW_IF '('expr')' stmt KW_ELSE  stmt                         {$$ = template("if (%s) %s else %s\n", $3, $5, $7);}
        | KW_FOR '('assign_instr ';' assign_instr ')' stmt            {$$ = template("for (%s ; %s ; %s) %s\n", $3, $5, $7);}
        | KW_FOR '('assign_instr ';' expr ';' assign_instr ')' stmt   {$$ = template("for (%s ; %s ; %s) %s\n", $3, $5, $7, $9);}
        | KW_WHILE '(' expr ')' stmt                                  {$$ = template("while ( %s ) %s\n", $3, $5);}
        | KW_BREAK ';'                                                {$$ = template("break;\n");}
        | KW_CONTINUE ';'                                             {$$ = template("continue;\n");}
        | KW_RETURN ';'                                               {$$ = template("return;\n");}
        | KW_RETURN expr ';'                                          {$$ = template("return %s;\n", $2);}
        | func_call ';'                                               {$$ = template("%s;\n", $1);}
        ;

  instr_list:
              instr              {$$ = $1;}
            | instr instr_list   {$$ = template("%s %s", $1, $2);}
            ;

  complex_instr: 
                '{' instr_list '}'  {$$ = template("{\n%s\n}", $2);}
                ;

  assign_instr:
                IDENT '=' expr  {$$ = template("%s = %s", $1, $3);}
              | IDENT '[' expr ']' '=' expr {$$ = template("%s[%s] = %s", $1, $3, $6);}
              ;

  stmt:
            complex_instr {$$ = $1;}
          | instr {$$ = template("{\n%s\n}", $1);}
          ;

  data_type:  
               KW_BOOL {$$ = template("int");}
              |KW_INT  {$$ = template("int");}
              |KW_STRING  {$$ = template("char*");}
              |KW_REAL    {$$ = template("double");} 
              ;




%%
int main() {

  if ( yyparse() != 0 )
      printf("/* Rejected! */\n");
 else {
    printf("/* Accepted! */\n");
 } 

}



