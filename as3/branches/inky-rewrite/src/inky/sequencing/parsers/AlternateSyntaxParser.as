package inky.sequencing.parsers 
{
	import inky.sequencing.parsers.ICommandDataParser;
	import inky.sequencing.CommandData;
	import inky.utils.getClass;
	import inky.sequencing.parsers.PropertyParser;
	
	/**
	 *
	 *  Allows you to quickly and easily create alternate XML syntaxes for
	 *  already-existing commands by mapping properties.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.03.29
	 *
	 */
	public class AlternateSyntaxParser implements ICommandDataParser
	{
		private var commandClass:Object;
		private var propertyMap:Object;
		private static var propertyParser:PropertyParser;
		
		/**
		 *
		 */
		public function AlternateSyntaxParser(commandClass:Object, propertyMap:Object)
		{
			this.commandClass = commandClass;
			this.propertyMap = propertyMap;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			var commandClass:Class;
			if (cls)
			{
// TODO: Maybe we shouldn't do this. Sometimes we want a parser to return different types. (i.e. wait returns delay and waitforevent)
			 	commandClass = getClass(cls);
				var realCommandClass:Class = getClass(this.commandClass);
				if (commandClass != realCommandClass)
					throw new Error("ConfigError. This parser can only be used with the command class " + realCommandClass + ", not " + commandClass);
			}
			else
			{
				commandClass = getClass(this.commandClass);
			}

			var command:Object = new commandClass();
			var unformattedProperties:Object = {};
			
			if (!AlternateSyntaxParser.propertyParser)
				AlternateSyntaxParser.propertyParser = new PropertyParser();
			
			var unformattedGetters:Object = AlternateSyntaxParser.propertyParser.parseProperties(xml, unformattedProperties);
			var getters:Object = {};
			var property:String;
			var formattedProperty:String;

			for (property in unformattedGetters)
			{
				formattedProperty = this.propertyMap[property];
				getters[formattedProperty] = unformattedGetters[property];
			}
			
			for (property in unformattedProperties)
			{
				formattedProperty = this.propertyMap[property];
				command[formattedProperty] = unformattedProperties[property];
			}

			return new CommandData(command, getters);
		}
		

	}
	
}