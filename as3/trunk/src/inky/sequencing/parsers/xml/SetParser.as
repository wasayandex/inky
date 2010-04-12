package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.SetPropertiesCommand;
	import inky.sequencing.parsers.xml.IXMLCommandParser;
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
	public class SetParser implements IXMLCommandParser
	{
		private static const TARGET_VALUE:RegExp = /^(.*)\.to$/;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function createCommand(xml:XML):Object
		{
			return new SetPropertiesCommand();
		}

		/**
		 * 
		 */
		public static function install(name:Object = null):void
		{
			XMLCommandParserRegistry.globalRegistry.registerParser(name || "set", SetParser);
		}

		/**
		 * @inheritDoc
		 */
		public function setCommandProperties(command:Object, properties:Object):void
		{
			var formattedPropertyName:String;
			var host:Object;
			var value:*;
			var match:Object;
			
			for (var propertyName:String in properties)
			{
				value = properties[propertyName];
				host = command;
				
				if (propertyName == "on")
				{
					formattedPropertyName = "target";
				}
				else if ((match = propertyName.match(TARGET_VALUE)))
				{
					formattedPropertyName = match[1];
					host = command.propertyValues;
				}
				else
				{
					throw new Error("Property \"" + propertyName + "\" is not supported.");
				}

				host[formattedPropertyName] = value;
			}
		}
		
	}
	
}