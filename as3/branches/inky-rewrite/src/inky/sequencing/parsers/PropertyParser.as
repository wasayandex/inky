package inky.sequencing.parsers 
{
	import inky.binding.utils.BindingUtil;
	
	/**
	 *
	 *  Parses XML attributes into property getters.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.03.29
	 *
	 */
	public class PropertyParser
	{
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function parseProperties(xml:XML, obj:Object):Object
		{
			var propertyGetters:Object = {};

			for each (var prop:XML in xml.attributes())
			{
				var propName:String = prop.name();
				var value:String = prop.toString();
				var match:Object = value.match(/^#(.*)$/);

				if (match)
					propertyGetters[propName] = this.parseGetterString(match[1]);
				else
					obj[propName] = value;
			}
			
			return propertyGetters;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function parseGetterString(getterString:String):Function
		{
			var parts:Array = getterString.split(".");
			return function(host:Object):Object
			{
				return BindingUtil.evaluateBindingChain(host, parts);
			}
		}

	}
	
}