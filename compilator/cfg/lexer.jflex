package main;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%
%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

/*-*
 * PADROES NOMEADOS:
 */
WHITESPACE      = [ \n\t\r]           
COMMENT         = ("/*"+([^]|[\r\n])+"*/") |("//"~\n)
ID              = ([A-Za-z_][A-Za-z_0-9]*)
LITINTEGER      = ([1-9][0-9]*)|0
LITFLOAT        = (({LITINTEGER})+"."+([0-9]*+[1-9]))|("E"+("+"|"-")+({LITINTEGER}))

%%

";"
{return symbolFactory.newSymbol("SEMICOLON",SEMICOLON);}
"."
{return symbolFactory.newSymbol("DOT",DOT);}
","
{return symbolFactory.newSymbol("COMMA",COMMA);}
"="
{return symbolFactory.newSymbol("ASSIGN",ASSIGN);}
"("
{return symbolFactory.newSymbol("PARENTHLEFT",PARENTHLEFT);}
")"
{return symbolFactory.newSymbol("PARENTHRIGHT",PARENTHRIGHT);}
"{"
{return symbolFactory.newSymbol("CURLBRACKETSLEFT",CURLBRACKETSLEFT);}
"}"
{return symbolFactory.newSymbol("CURLBRACKETSRIGHT",CURLBRACKETSRIGHT);}
"["
{return symbolFactory.newSymbol("BRACKETSLEFT",BRACKETSLEFT);}
"]"
{return symbolFactory.newSymbol("BRACKETSRIGHT",BRACKETSRIGHT);} 
"class"
{return symbolFactory.newSymbol("CLASS",CLASS);} 
"public"
{return symbolFactory.newSymbol("PUBLIC",PUBLIC);} 
"extends"
{return symbolFactory.newSymbol("EXTENDS",EXTENDS);} 
"static"
{return symbolFactory.newSymbol("STATIC",STATIC);} 
"void"
{return symbolFactory.newSymbol("VOID",VOID);} 
"int"
{return symbolFactory.newSymbol("INT",INT);} 
"String"
{return symbolFactory.newSymbol("STRING",STRING);} 
"main"
{return symbolFactory.newSymbol("MAIN",MAIN);}
"length"
{return symbolFactory.newSymbol("LENGTH",LENGTH);}
"System.out.println"
{return symbolFactory.newSymbol("SYSO",SYSO);}
"boolean"
{return symbolFactory.newSymbol("BOOLEAN",BOOLEAN);} 
"while"
{return symbolFactory.newSymbol("WHILE",WHILE);} 
"if"
{return symbolFactory.newSymbol("IF",IF);} 
"else"
{return symbolFactory.newSymbol("ELSE",ELSE);} 
"return"
{return symbolFactory.newSymbol("RETURN",RETURN);} 
"false"
{return symbolFactory.newSymbol("FALSE",FALSE);} 
"true"
{return symbolFactory.newSymbol("TRUE",TRUE);} 
"this"
{return symbolFactory.newSymbol("THIS",THIS);} 
"new"
{return symbolFactory.newSymbol("NEW",NEW);} 
"||"
{return symbolFactory.newSymbol("OR",OR);} 
"&&"
{return symbolFactory.newSymbol("AND",AND);} 
"=="
{return symbolFactory.newSymbol("EQ",EQ);} 
"!="
{return symbolFactory.newSymbol("DIF",DIF);} 
"<"
{return symbolFactory.newSymbol("LT",LT);} 
"<="
{return symbolFactory.newSymbol("LET",LET);} 
">"
{return symbolFactory.newSymbol("GT",GT);} 
">="
{return symbolFactory.newSymbol("GET",GET);} 
"+"
{return symbolFactory.newSymbol("PLUS",PLUS);} 
"-"
{return symbolFactory.newSymbol("MINUS",MINUS);} 
"*"
{return symbolFactory.newSymbol("MULT",MULT);} 
"/"
{return symbolFactory.newSymbol("DIV",DIV);} 
"%"
{return symbolFactory.newSymbol("MOD",MOD);} 
"!"
{return symbolFactory.newSymbol("NOT",NOT);} 

{LITINTEGER}    
{ return symbolFactory.newSymbol("LITERAL_INTEGER",LITERAL_INTEGER,yytext());}	
{LITFLOAT}      
{ return symbolFactory.newSymbol("LITERAL_FLOAT",LITERAL_FLOAT,yytext());}
{ID}       
{ return symbolFactory.newSymbol("IDENTIFIER",IDENTIFIER,yytext());}
{COMMENT}       
{}
{WHITESPACE}    
{ /*Ignored*/ }
.				
{ System.out.println("\nERROR:"++yytext() );}