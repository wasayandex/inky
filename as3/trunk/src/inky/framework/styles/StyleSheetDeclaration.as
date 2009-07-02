package inky.framework.styles 
{
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;


	/**
	 *
	 *  Represents a css declaration (property: value)
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2009.06.11
	 *
	 */
	public class StyleSheetDeclaration
	{
		private var _property:String;
		public var cssProperty:String;
		public var value:Object;
		private static var _propertyNameRegExp:RegExp = /-(\w)/g;


		/**
		 *	
		 */
		public function StyleSheetDeclaration(cssProperty:String = null, value:String = null)
		{
			this.cssProperty = cssProperty;
			this.value = value;
			this._property = cssProperty.replace(StyleSheetDeclaration._propertyNameRegExp, StyleSheetDeclaration._replaceFn);
		}
		

		/**
		 *	Gets the property in its ActionScipt form (camelCaps instead of hyphenated)
		 */
		public function get property():String
		{
			return this._property;
		}




		//
		// private methods
		//


		/**
		 *	Function used to convert css-property-names to actionScriptPropertyNames
		 */
		private static function _replaceFn(match:String, ...rest:Array):String
		{
			return rest[0].toUpperCase();
		}




	}
}