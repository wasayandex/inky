package inky.sequencing.parsers 
{
	import inky.sequencing.parsers.WaitParser;
	import inky.sequencing.parsers.AlternateSyntaxParser;
	import inky.sequencing.commands.DelayCommand;
	import inky.sequencing.parsers.ICommandDataParser;
	import inky.sequencing.parsers.PropertyParser;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.EventListenerCommand;
	
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
	public class WaitParser implements ICommandDataParser
	{
		private static var propertyParser:PropertyParser;
		
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
			if (!WaitParser.propertyParser)
				WaitParser.propertyParser = new PropertyParser();

			var unformattedProperties:Object = {};
			var unformattedGetters:Object = WaitParser.propertyParser.parseProperties(xml, unformattedProperties);
			
			var command:Object;
			var commandData:CommandData;
			
			if (unformattedProperties.on || unformattedGetters.on)
			{
				command = new EventListenerCommand();
				this.mapProperty(unformattedProperties, "on", "target");
				this.mapProperty(unformattedGetters, "on", "target");
				this.mapProperty(unformattedProperties, "for", "eventType");
				this.mapProperty(unformattedGetters, "for", "eventType");
				this.mapProperty(unformattedProperties, "ofClass", "eventClass");
				this.mapProperty(unformattedGetters, "ofClass", "eventClass");
				
				for (var property:String in unformattedProperties)
				{
					command[property] = unformattedProperties[property];
				}
				
				commandData = new CommandData(command, unformattedGetters);
			}
			else if (!unformattedProperties["for"])
			{
				throw new Error("The wait command requires a \"for\" attribute.");
			}
			else
			{
				command = new DelayCommand()
				var rawDuration:String = unformattedProperties["for"];
				
				// Parse the duration from the "for" property.
				var time:ParsedTime = new TimeParser().parse(rawDuration);
				command.duration = time.time;
				command.units = time.units;
				
				commandData = new CommandData(command, unformattedGetters);
			}
			
			return commandData;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function mapProperty(host:Object, sourceProperty:String, targetProperty:String):void
		{
			if (host.hasOwnProperty(sourceProperty))
			{
				var value:* = host[sourceProperty];
				delete host[sourceProperty];
				host[targetProperty] = value;
			}
		}
	}
	
}