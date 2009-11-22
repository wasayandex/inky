package inky.collections 
{
	import inky.collections.ICollection;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.27
	 *
	 */
	public interface IQueue extends ICollection
	{
		
		/**
		 *	
		 */
		function getHeadItem():Object;
		
		
		/**
		 *	
		 */
		function offerItem(item:Object):Boolean;


		/**
		 *	
		 */
		function removeHeadItem():Object;


	}
}