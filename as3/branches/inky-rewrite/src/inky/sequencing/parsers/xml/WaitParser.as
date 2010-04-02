package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.DelayCommand;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.EventListenerCommand;
	import inky.sequencing.parsers.TimeParser;
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.parsers.ParsedTime;
	import inky.sequencing.parsers.TimeUnit;
	import inky.sequencing.parsers.xml.IXMLCommandDataParser;
	
	/**
	 *
	 *  Parses a wait command.
	 *  <listing version="3.0">
	 *      &lt;wait for="#target" to={Event.COMPLETE} />
	 *      &lt;wait for="12ms" />
	 *      &lt;wait for="0:12" />
	 *      &lt;wait for="12 seconds" />
	 *      &lt;wait for="12 frames" />
	 *  </listing>
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.30
	 *
	 */
	public class WaitParser implements IXMLCommandDataParser
	{
		private static var timeParser:TimeParser;
		private static const propertyMap:Object = {
			"for": "duration"
		};

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			if (!xml["@for"].length())
				throw new Error("The wait command requires a \"for\" attribute.");

			xml = xml.copy();
			
			var command:Object;
			var formatters:Object;

			if (xml.@on.length())
			{
				command = new EventListenerCommand();
				xml.@on.setLocalName("target");
				xml["@for"].setLocalName("eventType");

				if (xml.@withClass.length())
					xml.@withClass.setLocalName("eventClass");
			}
			else
			{
				command = new DelayCommand();
				xml["@for"].setLocalName("duration");
				xml.@units = xml.@duration;

				formatters = {
					duration: this.formatDuration,
					units: this.formatUnits
				};
			}

			var injectors:Array = CommandParserUtil.createInjectors(xml, formatters);
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
			var timeParser:TimeParser = WaitParser.timeParser || (WaitParser.timeParser = new TimeParser());
			var parseResult:ParsedTime = timeParser.parse(time);
			return parseResult.units == TimeUnit.MILLISECONDS ? parseResult.time / 1000 : parseResult.time;
		}
		
		/**
		 * 
		 */
		private function formatUnits(time:String):String
		{
			return timeParser.parse(time).units;
		}

	}
	
}