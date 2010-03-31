package inky.sequencing.parsers 
{
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.parsers.ICommandDataParser;
	import inky.sequencing.parsers.PropertyParser;
	import inky.sequencing.commands.GTweenCommand;
	import inky.sequencing.parsers.TimeUnit;
	import inky.sequencing.CommandData;
	import inky.utils.describeObject;
	
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
	public class GTweenParser implements ICommandDataParser
	{
		private static var propertyParser:PropertyParser;
		
		/**
		 *
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			if (!GTweenParser.propertyParser)
				GTweenParser.propertyParser = new PropertyParser();

			var prop:String;
			var unformattedProperties:Object = {};
			var unformattedGetters:Object = GTweenParser.propertyParser.parseProperties(xml, unformattedProperties);
			
			var command:GTweenCommand = new GTweenCommand();

// FIXME: Variable (getter) not allowed for "for" property.
			// Parse the duration from the "for" property.
			var rawDuration:String = unformattedProperties["for"];
			delete unformattedProperties["for"];
			var time:ParsedTime = new TimeParser().parse(rawDuration);
			if (time.units == TimeUnit.FRAMES)
			{
				command.tweenProperties.useFrames = true;
				command.tweenProperties.duration = time.time;
			}
			else
			{
				command.tweenProperties.useFrames = false;
				command.tweenProperties.duration = time.time / 1000;
			}

			this.mapProperty(unformattedProperties, "on", "target");
			this.mapProperty(unformattedGetters, "on", "target");
// FIXME: Variables (getters) not allowed in to.* attributes.
			for (prop in unformattedProperties.to)
			{
				command.targetValues[prop] = unformattedProperties.to[prop];
			}
			delete unformattedProperties.to;
			
			for (prop in unformattedProperties)
			{
				command.tweenProperties[prop] = unformattedProperties[prop];
			}
			
			var formattedGetters:Object = {
				tweenProperties: function(host:Object):Object
				{
					var properties:Object = command.tweenProperties;
					for (prop in unformattedGetters)
					{
						var fn:Function = unformattedGetters[prop];
						properties[prop] = fn(host);
					}
					return properties;
				}
			};
			
			return new CommandData(command, formattedGetters);
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