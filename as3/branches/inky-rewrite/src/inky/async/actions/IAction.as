package inky.async.actions
{
	import flash.events.IEventDispatcher;
	import inky.commands.IAsyncToken;


    /**
     * 
     * Dispatched when an action finishes.
     *
     * @eventType inky.async.actions.events.ActionEvent.ACTION_FINISH
     *
     */
	[Event(name="actionFinish", type="inky.async.actions.events.ActionEvent")]


    /**
     * 
     * Dispatched when an action starts.
     *
     * @eventType inky.async.actions.events.ActionEvent.ACTION_START
     *
     */
	[Event(name="actionStart", type="inky.async.actions.events.ActionEvent")]


    /**
     * 
     * Dispatched when an action stops.
     *
     * @eventType inky.async.actions.events.ActionEvent.ACTION_STOP
     *
     */
	[Event(name="actionStop", type="inky.async.actions.events.ActionEvent")]




	/**
	 *
	 *  Defines the interface for an action object. IActions are a way of
	 * modularizing actions for reuse.
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter (matthew@exanimo.com)
	 * @since  2008.02.12
	 *
	 */
	public interface IAction extends IEventDispatcher
	{

		//
		// public methods
		//


		/**
		 *
		 * Begin the action.	
		 * 
		 */
		function startAction():IAsyncToken;




	}
}