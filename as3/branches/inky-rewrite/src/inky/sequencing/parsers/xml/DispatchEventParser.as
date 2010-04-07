package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.CommandData;
	import inky.sequencing.parsers.xml.IXMLCommandDataParser;
	
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
	public class DispatchEventParser implements IXMLCommandDataParser
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
			
			if (!xml.@on.length())
				throw new Error("The DispatchEventParser requires an \"on\" attribute.");
			else if (!xml["@with.type"].length())
				throw new Error("The DispatchEventParser requires a \"with.type\" attribute.");
			
			if (xml["@with.class"].length())
				xml["@with.class"].setLocalName("eventClass");

			xml.@on.setLocalName("target");
			xml["@with.type"].setLocalName("type");
			
			return new CommandData(
				new DispatchEventCommand(),
				CommandParserUtil.createInjectors(xml)
			);
		}
		
	}
	
}