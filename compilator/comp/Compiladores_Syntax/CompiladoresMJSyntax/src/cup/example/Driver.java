package cup.example;


class Driver {

	public static String[] args;
	
	public static void main(String[] args) throws Exception {
		Driver.args = args;
		Parser parser = new Parser();
		parser.parse();
		parser.debug_parse();
	}
	
}