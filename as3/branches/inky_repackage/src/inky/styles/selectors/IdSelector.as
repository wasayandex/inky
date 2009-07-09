package inky.styles.selectors 
{
	import inky.styles.selectors.ISelector;
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
	public class IdSelector implements ISelector
	{
		private var _id:String;


		/**
		 *	
		 */
		public function IdSelector(id:String)
		{
			this._id = id;
		}


		/**
		 *	@inheritDoc
		 */
		public function get specificity():uint
		{
			return 100;
		}


		/**
		 * @inheritDoc
		 */
		public function matches(object:Object):Boolean
		{
			var matches:Boolean = false;

			if (object is HTMLElement)
			{
				matches = this._id == HTMLElement(object).id;
			}

			return matches;
		}



		/**
		 *	@inheritDoc
		 */
		public function toCSSString():String

		{
			return "#" + this._id;
		}

		
	}
	
}