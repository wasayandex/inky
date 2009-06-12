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
	public class StyleSheetRule
	{
		private var _declarations:IList;
		private var _selectors:IList;


		public function StyleSheetRule(selectorText:String)
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
		public function get selectors():IList
		{
			if (!this._selectors)
				this._selectors = new ArrayList();
			return this._selectors;
		}



		/**
		 * Determines whether the rule apply to the specified object
		 */
		public function matches(obj:Object):Boolean
		{
// TODO: Implement selector matching.
return true;
		}




	}
}