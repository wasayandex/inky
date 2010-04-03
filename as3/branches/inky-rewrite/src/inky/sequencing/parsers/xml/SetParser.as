package inky.sequencing.parsers.xml
{
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.SetPropertiesCommand;
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
	public class SetParser implements IXMLCommandDataParser
	{
		private static const TARGET_VALUE:RegExp = /^(.*)\.to$/;
		
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
				throw new Error("The \"set\" command requires an \"on\" attribute.");
			xml.@on.setLocalName("target");

			var match:Object;
			var prop:String;
			for each (var attr:XML in xml.@*)
			{
				if ((match = attr.localName().toString().match(TARGET_VALUE)))
				{
					// Format the "to" properties.
					prop = match[1];
					attr.setLocalName("propertyValues." + prop);
				}
			}
			
			return new CommandData(
				new SetPropertiesCommand(),
				CommandParserUtil.createInjectors(xml)
			);
		}
		
	}
	
}