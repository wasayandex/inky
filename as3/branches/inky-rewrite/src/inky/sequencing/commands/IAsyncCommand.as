package inky.sequencing.commands 
{
	import flash.events.IEventDispatcher;

	/**
	 *
	 *  This is a marker interface that guarantees the implementor will
	 *  dispatch an Event.COMPLETE event when the command is finished. It is
	 *  not necessary (or even encouraged) that custom asynchronous commands
	 *  implement this interface. Instead, use WaitCommand to pause the
	 *  the sequence until your custom command completes.
	 * 
	 *  @see	inky.sequencing.commands.WaitCommand
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public interface IAsyncCommand extends IEventDispatcher
	{
		/**
		 * 
		 */
		function execute():void;
		
	}
	
}