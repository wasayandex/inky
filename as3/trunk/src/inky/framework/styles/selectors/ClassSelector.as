package inky.styles.selectors 
{
	import inky.styles.selectors.ISelector;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import inky.styles.HTMLElement;


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
			var matches:Boolean;

			if (object is HTMLElement)
			{
// TODO: Make this work when multiple class names are specified. i.e. class="a b c"
				matches = this._className == HTMLElement(object).className;
			}
			else
			{
				var cls:Class;
				try
				{
					cls = getDefinitionByName(this._className) as Class;
				}
				catch (error:Error)
				{
				}
				matches = cls && (object is cls);
			}
			return matches;
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