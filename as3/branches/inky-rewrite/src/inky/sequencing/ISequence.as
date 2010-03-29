package inky.sequencing 
{
	import inky.collections.IList;
	import inky.sequencing.CommandData;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public interface ISequence
	{
		/**
		 * 
		 */
		function get length():int;
		
		/**
		 * 
		 */
		function getCommandAt(index:int):Object;
		
		/**
		 * 
		 */
		function getCommandDataAt(index:int):CommandData;

		
	}
	
}