package inky.sequencing.parsers 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.31
	 *
	 */
	public class CommandParserUtil
	{
		private static const VARIABLE_REFERENCE:RegExp = /^#(.*)$/;
		
		/**
		 * 
		 */
		public static function isVariableReference(value:String):Boolean
		{
			return !!value.match(VARIABLE_REFERENCE);
		}

		/**
		 * @param	formatters	 A map of formatter functions to use.
		 */
		public static function createInjectors(xml:XML, formatters:Object = null):Array
		{
			var injectors:Array = [];
			for each (var attr:XML in xml.@*)
			{
				var prop:String = attr.localName();
				var value:String = attr.toString();
				var formatter:Function = formatters ? formatters[prop] : null;
				var injector:Function = CommandParserUtil.createInjectorFunction(prop, value, formatter);
				injectors.push(injector);
			}
			return injectors;
		}

		/**
		 * @param	formatter	 A function that formats the value.
		 */
		public static function createGetter(getterString:String, formatter:Function = null):Function
		{
			var match:Object;
			var getter:Function;
			
			if ((match = getterString.match(VARIABLE_REFERENCE)))
			{
				var parts:Array = match[1].split(".");
				if (formatter != null)
				{
					getter = function(host:Object):*
					{
						return formatter(CommandParserUtil.evaluatePropertyChain(host, parts));
					}
				}
				else
				{
					getter = function(host:Object):*
					{
						return CommandParserUtil.evaluatePropertyChain(host, parts);
					}
				}
			}
			else if (formatter != null)
			{
				getter = function(host:Object):*
				{
					return formatter(getterString);
				}
			}
			else
			{
				getter = function(host:Object):*
				{
					return getterString;
				}
			}
			
			return getter;
		}
		
		/**
		 * 
		 */
		public static function createInjectorFunction(prop:String, value:String, formatter:Function = null):Function
		{
			var hostPath:Array = prop.split(".");
			var getter:Function = CommandParserUtil.createGetter(value, formatter);

			return function(host:Object, variables:Object):void
			{
				for (var i:int = 0; i < hostPath.length - 1; i++)
				{
					host = host[hostPath[i]];
				}
				var propertyToSet:String = hostPath[hostPath.length - 1];
				var value:* = getter(variables);
				host[propertyToSet] = value;
			}
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private static function evaluatePropertyChain(host:Object, properties:Array):*
		{
			var value:* = host;
			var lastProperty:String;
			for (var i:int = 0; i < properties.length; i++)
			{
				var property:String = properties[i];
				value = value[property];

				if ((value == null) && (i < properties.length - 1))
					throw new Error("Could not evaluate property chain " + properties.join(".") + " on " + host + ": " + properties.slice(0, i + 1).join(".") + " is null.");
			}
			return value;
		}

	}
	
}