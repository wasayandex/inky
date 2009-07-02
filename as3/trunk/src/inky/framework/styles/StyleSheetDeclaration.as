package inky.framework.styles 
{
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;


	/**
	 *
	 *  ..
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
		private var _actionScriptProperty:String;
		public var property:String;
		public var value:Object;
		private static var _propertyNameRegExp:RegExp = /-(\w)/g;

		private static function _replaceFn(match:String, ...rest:Array):String
		{
			return rest[0].toUpperCase();
		}
		
		
		/**
		 *	
		 */
		public function StyleSheetDeclaration(property:String = null, value:String = null)
		{
			this.property = property;
			this.value = value;
			this._actionScriptProperty = property.replace(StyleSheetDeclaration._propertyNameRegExp, StyleSheetDeclaration._replaceFn);
		}
		

		/**
		 *	Gets the property in its ActionScipt form (camelCaps instead of hyphenated)
		 */
// TODO: Rename this to not be AS-specific?
		public function get actionScriptProperty():String
		{
			return this._actionScriptProperty;
		}




	}
}