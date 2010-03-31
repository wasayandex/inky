package inky.sequencing.parsers 
{
import inky.binding.utils.BindingUtil;
	
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
/*trace("getting formatted\t\t" + parts + " from " + host);*/
						return formatter(BindingUtil.evaluateBindingChain(host, parts));
					}
				}
				else
				{
					getter = function(host:Object):*
					{
/*trace("getting unformatted\t\t" + parts + " from " + host);*/
						return BindingUtil.evaluateBindingChain(host, parts);
					}
				}
			}
			else if (formatter != null)
			{
				getter = function(host:Object):*
				{
/*trace("getting simple formatted\t\t" + formatter(getterString));*/
					return formatter(getterString);
				}
			}
			else
			{
				getter = function(host:Object):*
				{
/*trace("getting simple unformatted\t\t" + getterString);*/
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
/*trace("setting " + propertyToSet + " to " + value);*/
				host[propertyToSet] = value;
			}
		}

	}
	
}