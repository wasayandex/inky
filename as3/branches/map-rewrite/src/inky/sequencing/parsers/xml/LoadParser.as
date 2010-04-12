package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.LoadCommand;
	import inky.sequencing.parsers.xml.AbstractXMLCommandParser;
	import inky.sequencing.parsers.xml.XMLCommandParserRegistry;
	
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
	public class LoadParser extends AbstractXMLCommandParser
	{
		/**
		 *
		 */
		public function LoadParser()
		{
			this.propertyMap = {
				"as": "contentType",
				using: "loader"
			};
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function createCommand(xml:XML):Object
		{
			return new LoadCommand();
		}

		/**
		 * 
		 */
		public static function install(name:Object = null):void
		{
			XMLCommandParserRegistry.globalRegistry.registerParser(name || "load", LoadParser);
		}
	}
	
}