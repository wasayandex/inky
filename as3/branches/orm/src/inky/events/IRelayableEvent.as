package inky.events 
{
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 *  An event that can be relayed from one target to another. This system
	 *  is a replacement for event bubbling on non-DisplayObjects, and allows
	 *  an event to be rebroadcast up a tree-structure.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.23
	 *
	 */
	public interface IRelayableEvent
	{
// TODO: Add all of the other Event methods here.
		/**
		 *	
		 */
		function prepare(currentTarget:Object, target:Object):void;
		
	}
}