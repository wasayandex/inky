package inky.framework.styles 
{
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;
	import inky.framework.styles.selectors.ISelector;


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
	public class StyleSheetRule
	{
		private var _declarations:IList;
		private var _selector:ISelector;


		public function StyleSheetRule()
		{
		}


		/**
		 *	
		 */
		public function get declarations():IList
		{
			if (!this._declarations)
				this._declarations = new ArrayList();
			return this._declarations;
		}


		/**
		 *
		 */
		public function get selector():ISelector
		{
			return this._selector;
		}
		/**
		 * @private
		 */
		public function set selector(value:ISelector):void
		{
			this._selector = value;
		}




	}
}