package inky.framework.styles.selectors 
{
	import inky.framework.styles.selectors.ISelector;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.06.15
	 *
	 */
	public class ClassSelector implements ISelector
	{
		private var _className:String;


		/**
		 *	
		 */
		public function ClassSelector(className:String)
		{
			this._className = className;
		}


		/**
		 *	@inheritDoc
		 */
		public function get specificity():uint
		{
			return 10;
		}



		/**
		 * @inheritDoc
		 */
		public function matches(object:Object):Boolean
		{
			var cls:Class = getDefinitionByName(this._className) as Class;
			return cls && (object is cls);
		}


		/**
		 *	@inheritDoc
		 */
		public function toCSSString():String
		{
			return "." + this._className.replace(/\./g, "\\.");
		}



	}
	
}