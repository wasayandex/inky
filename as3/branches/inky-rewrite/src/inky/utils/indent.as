package inky.utils 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.09
	 *
	 */
	public function indent(str:String, indentLevel:int = 1, indentChar:String = "\t"):String
	{
		var indentString:String = "";
		for (var i:int = 0; i < indentLevel; i++)
			indentString += indentChar;
		return indentString + str.replace(/\n/g, "\n" + indentString);
	}
	
}
