package inky.sequencing.parsers.xml 
{
	import inky.sequencing.parsers.xml.IXMLCommandParser;
	import inky.utils.getClass;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.09
	 *
	 */
	public class XMLCommandParserRegistry
	{
		private static var _globalRegistry:XMLCommandParserRegistry;
		private var parsers:Object = {};
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
		 */
		public static function get globalRegistry():XMLCommandParserRegistry
		{
			if (!XMLCommandParserRegistry._globalRegistry)
				XMLCommandParserRegistry._globalRegistry = new XMLCommandParserRegistry();
			return XMLCommandParserRegistry._globalRegistry;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function getParser(name:Object):IXMLCommandParser
		{
			var registeredValue:Object = this.parsers[name];
			var cls:Class;
			var parser:Object;

			if (!registeredValue)
			{
				parser = null;
			}
			else
			{
				if (registeredValue is IXMLCommandParser)
				{
					parser = registeredValue as IXMLCommandParser;
				}
				else if (registeredValue is String)
				{
					cls = getClass(String(registeredValue));
					if (!cls)
						throw new Error("Could not find definition for " + registeredValue);
					parser = new cls();
					if (!(parser is IXMLCommandParser))
						throw new Error(registeredValue + " does not implement IXMLCommandParser");
				}
				else if (registeredValue is Class)
				{
					cls = registeredValue as Class;
					parser = new cls();
					if (!(parser is IXMLCommandParser))
						throw new Error(registeredValue + " does not implement IXMLCommandParser");
				}
				else
				{
					throw new Error();
				}
			}
			
			return IXMLCommandParser(parser);
		}
		
		/**
		 * 
		 */
		public function registerParser(name:Object, parser:Object):void
		{
			this.parsers[name] = parser;
		}
		
		/**
		 * 
		 */
		public function registerParsers(map:Object):void
		{
			for (var name:Object in map)
				this.registerParser(name, map[name]);
		}

		
	}
	
}