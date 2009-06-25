package inky.framework.styles.selectors 
{
	import inky.framework.styles.selectors.ISelector;


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
			return false;
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