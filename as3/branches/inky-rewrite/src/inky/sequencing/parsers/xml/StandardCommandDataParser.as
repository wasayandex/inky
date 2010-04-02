package inky.sequencing.parsers.xml
{
	import inky.sequencing.CommandData;
	import inky.sequencing.parsers.xml.IXMLCommandDataParser;
	import inky.utils.getClass;
	import inky.sequencing.parsers.CommandParserUtil;
	
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
	public class StandardCommandDataParser implements IXMLCommandDataParser
	{

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
			var injectors:Array = CommandParserUtil.createInjectors(xml);
			return new CommandData(command, injectors);
		}

	}
	
}