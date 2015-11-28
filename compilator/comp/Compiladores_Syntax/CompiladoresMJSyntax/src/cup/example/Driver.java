package cup.example;

import ast.Program;
import visitor.PrettyPrintVisitor;

class Driver {

	public static String[] args;
	
	public static void main(String[] args) throws Exception {
		Driver.args = args;
		Parser parser = new Parser();
		parser.parse();
		parser.debug_parse();
		//programa na forma de AST
		Program prog = (Program)parser.parse().value;
		//chama o visitor de pretty print
		prog.accept(new PrettyPrintVisitor());
		
	}
	
}