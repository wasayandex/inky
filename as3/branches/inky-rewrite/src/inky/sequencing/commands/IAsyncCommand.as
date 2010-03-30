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
		 * Indicates whether the command has completed. This value must be
		 * reset to false every time execute() is called, and set to true
		 * when the command completes. This accounds for IAsyncCommands that
		 * execute synchronously.
		 */
		function get isComplete():Boolean;
		
		/**
		 * 
		 */
		function execute():void;
		
	}
	
}