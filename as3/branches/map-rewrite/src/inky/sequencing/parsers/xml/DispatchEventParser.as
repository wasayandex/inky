package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.DispatchEventCommand;
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
	public class DispatchEventParser extends AbstractXMLCommandParser
	{
		/**
		 *
		 */
		public function DispatchEventParser()
		{
			this.requiredProperties = [
				"with.type",
				"on"
			];
			this.propertyMap = {
				"with.class": "eventClass",
				"with.type": "type",
				"on": "target"
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function createCommand(xml:XML):Object
		{
			return new DispatchEventCommand();
		}

		/**
		 * 
		 */
		public static function install(name:Object = null):void
		{
			XMLCommandParserRegistry.globalRegistry.registerParser(name || "dispatchEvent", DispatchEventParser);
		}

	}
	
}