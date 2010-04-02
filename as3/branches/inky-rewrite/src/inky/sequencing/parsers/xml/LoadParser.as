package inky.sequencing.parsers.xml
{
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.LoadCommand;
	
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
	public class LoadParser implements IXMLCommandDataParser
	{
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			xml = xml.copy();
			if (xml["@as"].length())
				xml["@as"].setLocalName("contentType");
			
			return new CommandData(
				new LoadCommand(),
				CommandParserUtil.createInjectors(xml)
			);
		}
		
	}
	
}