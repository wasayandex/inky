package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.DelayCommand;
	import inky.sequencing.commands.EventListenerCommand;
	import inky.sequencing.parsers.TimeParser;
	import inky.sequencing.parsers.ParsedTime;
	import inky.sequencing.parsers.xml.AbstractXMLCommandParser;
	import inky.sequencing.parsers.xml.XMLCommandParserRegistry;
	
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
	public class WaitParser extends AbstractXMLCommandParser
	{
		private static var timeParser:TimeParser;

		private static const requiredEventListenerCommandProperties:Array = ["for"];
		private static const requiredDelayCommandProperties:Array = ["for"];
		private static const eventListenerCommandPropertyMap:Object = {
			"on": "target",
			"with.class": "eventClass",
			"for": "eventType"
		}
		private static const delayCommandPropertyMap:Object = {
			"for": "duration"
		}
		private static const eventListenerCommandFormatters:Object = null;
		private static var delayCommandFormatters:Object = {
			duration: formatDuration,
			units: formatUnits
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function createCommand(xml:XML):Object
		{
			var command:Object;
			if (xml.@on.length())
				command = new EventListenerCommand();
			else
				command = new DelayCommand();
			return command;
		}

		/**
		 * 
		 */
		public static function install(name:Object = null):void
		{
			XMLCommandParserRegistry.globalRegistry.registerParser(name || "wait", WaitParser);
		}

		/**
		 * @inheritDoc
		 */
		override public function setCommandProperties(command:Object, properties:Object):void
		{
			if (command is EventListenerCommand)
			{
				this.requiredProperties = WaitParser.requiredEventListenerCommandProperties;
				this.propertyMap = WaitParser.eventListenerCommandPropertyMap;
				this.formatters = WaitParser.eventListenerCommandFormatters;
			}
			else if (command is DelayCommand)
			{
				properties.units = properties["for"];
				this.requiredProperties = WaitParser.requiredDelayCommandProperties;
				this.propertyMap = WaitParser.delayCommandPropertyMap;
				this.formatters = WaitParser.delayCommandFormatters;
			}
			else
			{
				throw new Error();
			}
			
			super.setCommandProperties(command, properties);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private static function formatDuration(time:String):Number
		{
			return WaitParser.getTimeParser().parse(time).time;
		}
		
		/**
		 * 
		 */
		private static function formatUnits(time:String):String
		{
			return WaitParser.getTimeParser().parse(time).units;
		}
		
		/**
		 * 
		 */
		private static function getTimeParser():TimeParser
		{
			return WaitParser.timeParser || (WaitParser.timeParser = new TimeParser());
		}

	}
	
}