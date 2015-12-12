package main;

import main.ParserCup;
import java_cup.runtime.*;
import ast.*;
import visitor.*;

class Driver {

	public static void main(String[] args) throws Exception {
		ParserCup parser = new ParserCup();
		Symbol x = parser.parse();
		//programa na forma de AST
		Program prog = (Program) parser.parse().value;
		BuildSymbolTableVisitor stVis = new BuildSymbolTableVisitor();
		prog.accept(stVis); 
		//chama o visitor de pretty print
		prog.accept(new TypeCheckVisitor(stVis.getSymbolTable()));
		int a = 0;
	}
}