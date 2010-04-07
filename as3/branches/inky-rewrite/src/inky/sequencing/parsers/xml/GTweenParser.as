package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.GTweenCommand;
	import inky.sequencing.CommandData;
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.parsers.TimeParser;
	import inky.sequencing.parsers.TimeUnit;
	import inky.sequencing.parsers.ParsedTime;
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
	public class GTweenParser implements IXMLCommandDataParser
	{
		private static const TARGET_VALUE:RegExp = /^(.*)\.to$/;
		private static var timeParser:TimeParser;
		private static const propertyMap:Object = {
			"for": "duration",
			"on": "target"
		};
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 *
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			xml = xml.copy();
			
			var match:Object;
			var prop:String;
			var value:String;

			for each (var attr:XML in xml.@*)
			{
				if ((match = attr.localName().toString().match(TARGET_VALUE)))
				{
					// Format the "to" properties.
					prop = match[1];
					attr.setLocalName("targetValues." + prop);
				}
				else if (attr.localName() == "using")
				{
					attr.setLocalName("tween");
				}
				else
				{
					prop = attr.localName();
					prop = GTweenParser.propertyMap[prop] || prop;
					attr.setLocalName("tweenProperties." + prop);
				}
			}

			if (xml["@tweenProperties.duration"].length())
				xml["@tweenProperties.useFrames"] = xml["@tweenProperties.duration"];

			var command:Object = new GTweenCommand();
			var injectors:Array = CommandParserUtil.createInjectors(xml, {"tweenProperties.duration": this.formatDuration, "tweenProperties.useFrames": this.formatUseFrames});
			return new CommandData(command, injectors);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function formatDuration(time:String):Number
		{
			var timeParser:TimeParser = GTweenParser.timeParser || (GTweenParser.timeParser = new TimeParser());
			var parseResult:ParsedTime = timeParser.parse(time);
			return parseResult.units == TimeUnit.MILLISECONDS ? parseResult.time / 1000 : parseResult.time;
		}
		
		/**
		 * 
		 */
		private function formatUseFrames(time:String):Boolean
		{
			var timeParser:TimeParser = GTweenParser.timeParser || (GTweenParser.timeParser = new TimeParser());
			return timeParser.parse(time).units == TimeUnit.FRAMES;
		}

	}
	
}