package cup.example;
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


input 			= [^\r\n]
lineBreak		= \r|\n|\r\n
lineComment		= "//"{input}* {lineBreak}?
standardComment	= "/*" ~"/*"
comment 		= {lineComment} | {standardComment}
letter			= [A-Za-z]
digit			= [0-9]
integer			= {digit}+
floatingPoint	= {integer}"."{integer}(E([+-]?){integer})?
alphanumeric	= {letter}|{digit}
identifier		= ("_"|{letter})({alphanumeric}|"_")*
whitespace		= [ \n\t\r]

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {
    "class"         		{ return symbolFactory.newSymbol ("class", CLASS); }
    "public"        		{ return symbolFactory.newSymbol ("public", PUBLIC); }
    "extends"       		{ return symbolFactory.newSymbol ("extends", EXTENDS); }
    "static"        		{ return symbolFactory.newSymbol ("static", STATIC); }
    "void"          		{ return symbolFactory.newSymbol ("void", VOID);}
    "int"           		{ return symbolFactory.newSymbol ("int", INT);}
    "boolean"       		{ return symbolFactory.newSymbol ("boolean", BOOLEAN);}
    "String"       			{ return symbolFactory.newSymbol ("string", STRING);}
    "while"         		{ return symbolFactory.newSymbol ("while", WHILE);}
    "if"            		{ return symbolFactory.newSymbol ("if", IF);}
    "else"          		{ return symbolFactory.newSymbol ("else", ELSE);}
    "return"        		{ return symbolFactory.newSymbol ("return", RETURN);}
    "false"         		{ return symbolFactory.newSymbol ("false", FALSE);}
    "true"          		{ return symbolFactory.newSymbol ("true", TRUE);}
    "this"          		{ return symbolFactory.newSymbol ("this", THIS);}
    "new"           		{ return symbolFactory.newSymbol ("new", NEW);}
    "System.out.println"	{ return symbolFactory.newSymbol ("SysOut", SYSO);}
    "main"           		{ return symbolFactory.newSymbol ("main", MAIN);}
    "length"           		{ return symbolFactory.newSymbol ("length", LENGTH);}
    //Operadores
    "&&"            { return symbolFactory.newSymbol ("&&", AND);}
    "<"             { return symbolFactory.newSymbol ("<", LT);}
    "+"             { return symbolFactory.newSymbol ("+", PLUS);}
    "-"             { return symbolFactory.newSymbol ("-", MINUS);}
    "*"             { return symbolFactory.newSymbol ("*", MULT);}
    "!"             { return symbolFactory.newSymbol ("!", NOT);}
    "="             { return symbolFactory.newSymbol ("=", ASSIGN);}
    ";"             { return symbolFactory.newSymbol (";", SEMICOLON);}
    "."             { return symbolFactory.newSymbol (".", DOT);}
    ","             { return symbolFactory.newSymbol (",", COMMA);}

    //Delmitadores
    "("             { return symbolFactory.newSymbol ("(", PARENTHLEFT);}
    "["             { return symbolFactory.newSymbol ("[", BRACKETSLEFT);}
    "{"             { return symbolFactory.newSymbol ("{", CURLBRACKETSLEFT);}

    ")"             { return symbolFactory.newSymbol (")", PARENTHRIGHT);}
    "]"             { return symbolFactory.newSymbol ("]", BRACKETSRIGHT);}
    "}"             { return symbolFactory.newSymbol ("}", CURLBRACKETSRIGHT);}

    //Identificadores
    {identifier}    { return symbolFactory.newSymbol ("IDENTIFIER " + yytext(), IDENTIFIER, yytext()); }
    {integer}       { return symbolFactory.newSymbol ("INT LITERAL" , NUMBER_LIT, Integer.parseInt(yytext())); }
	{whitespace}	{}
	{comment}		{}
}



// error fallback
    .               { System.out.println("Illegal char, '" + yytext() +
                        "' line: " + yyline + ", column: " + yycolumn); }
