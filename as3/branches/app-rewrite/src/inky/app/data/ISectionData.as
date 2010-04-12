package inky.app.data 
{
	import inky.collections.IIterable;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.03
	 *
	 */
	public interface ISectionData
	{
		/**
		 * 
		 */
		function get id():String;


		/**
		 * 
		 */
		function get owner():ISectionData;


		/**
		 * 
		 */
		function get subsections():IIterable;
		

		/**
		 * 
		 */
		function get viewClassStack():Array;
		
	}
	
}