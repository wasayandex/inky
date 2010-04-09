package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.GTweenCommand;
	import inky.sequencing.parsers.TimeParser;
	import inky.sequencing.parsers.TimeUnit;
	import inky.sequencing.parsers.ParsedTime;
	import inky.sequencing.parsers.xml.IXMLCommandParser;
	
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
	public class GTweenParser implements IXMLCommandParser
	{
		private static const TARGET_VALUE:RegExp = /^(.*)\.to$/;
		private static const TWEEN_VALUE:RegExp = /^with\.(.*)$/;
		private static var timeParser:TimeParser;
		private static const propertyMap:Object = {
			"for": "duration",
			"on": "target",
			using: "tween"
		};
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function createCommand(xml:XML):Object
		{
			return new GTweenCommand();
		}

		/**
		 * @inheritDoc
		 */
		public function setCommandProperties(command:Object, properties:Object):void
		{
			var match:Object;
			var prop:String;
			var value:*;
			var formattedProp:String;
			var host:Object;

			for (var propertyName:String in properties)
			{
				value = properties[propertyName];
				host = command;

				if (GTweenParser.propertyMap[propertyName])
				{
					formattedProp = GTweenParser.propertyMap[propertyName];
					
					if (propertyName != "using")
						host = command.tweenProperties;

					if (formattedProp == "duration")
					{
						var timeParser:TimeParser = GTweenParser.timeParser || (GTweenParser.timeParser = new TimeParser());
						var parseResult:ParsedTime = timeParser.parse(value);
						value = parseResult.units == TimeUnit.MILLISECONDS ? parseResult.time / 1000 : parseResult.time;
						command.tweenProperties.useFrames = parseResult.units == TimeUnit.FRAMES;
					}
				}
				else if ((match = propertyName.match(TARGET_VALUE)))
				{
					formattedProp = match[1];
					host = command.targetValues;
				}
				else if ((match = propertyName.match(TWEEN_VALUE)))
				{
					formattedProp = match[1];
					host = command.tweenProperties;
				}
				else
				{
					throw new Error("The attribute \"" + propertyName + "\" is not supported.");
				}

				host[formattedProp] = value;
			}
		}

	}
	
}