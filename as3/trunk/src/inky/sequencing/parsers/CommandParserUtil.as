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
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * 
		 */
		public static function formatValue(value:*):*
		{
			if (value == "true")
				value = true;
			else if (value == "false")
				value = false;
			
			return value;
		}
		
		/**
		 * 
		 */
		public static function evaluatePropertyChain(host:Object, properties:Array):*
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