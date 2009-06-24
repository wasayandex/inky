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
	public class UniversalSelector implements ISelector
	{


		/**
		 *	@inheritDoc
		 */
		public function get specificity():uint
		{
			return 0;
		}



		/**
		 * @inheritDoc
		 */
		public function matches(object:Object):Boolean
		{
			return true;
		}


		/**
		 *	@inheritDoc
		 */
		public function toCSSString():String
		{
			return "*";
		}



	}
}