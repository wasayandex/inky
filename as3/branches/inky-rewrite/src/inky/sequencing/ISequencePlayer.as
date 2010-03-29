package inky.sequencing 
{
	import flash.events.IEventDispatcher;
	
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
	public interface ISequencePlayer extends IEventDispatcher
	{
		/**
		 * 
		 */
		function get variables():Object;

		
	}
	
}