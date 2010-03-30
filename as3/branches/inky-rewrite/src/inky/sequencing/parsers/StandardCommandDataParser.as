package inky.sequencing.parsers 
{
	import inky.sequencing.CommandData;
	import inky.sequencing.parsers.ICommandDataParser;
	import inky.utils.getClass;
	import inky.sequencing.parsers.PropertyParser;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.03.29
	 *
	 */
	public class StandardCommandDataParser implements ICommandDataParser
	{
		private static var propertyParser:PropertyParser;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			var commandClass:Class = getClass(cls);
			if (!commandClass)
				throw new Error("Could not find the class " + cls);

			var command:Object = new commandClass();
			
			if (!StandardCommandDataParser.propertyParser)
				StandardCommandDataParser.propertyParser = new PropertyParser();
			
			var propertyGetters:Object = StandardCommandDataParser.propertyParser.parseProperties(xml, command);
			return new CommandData(command, propertyGetters);
		}

	}
	
}