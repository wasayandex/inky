package inky.utils
{
	import flash.events.IEventDispatcher;


    /**
     * 
     * Dispatched when an action finishes.
     *
     * @eventType inky.events.ActionEvent.ACTION_FINISH
     *
     */
	[Event(name="actionFinish", type="inky.events.ActionEvent")]


    /**
     * 
     * Dispatched when an action starts.
     *
     * @eventType inky.events.ActionEvent.ACTION_START
     *
     */
	[Event(name="actionStart", type="inky.events.ActionEvent")]


    /**
     * 
     * Dispatched when an action stops.
     *
     * @eventType inky.events.ActionEvent.ACTION_STOP
     *
     */
	[Event(name="actionStop", type="inky.events.ActionEvent")]




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
		// accessors
		//


		/**
		 *
		 * The target upon which the action acts.
		 *
		 * @default null	
		 * 
		 */
		function get target():Object;
		/**
		 * @private	
		 */
		function set target(target:Object):void;




		//
		// public methods
		//


		/**
		 *
		 * Begin the action.	
		 * 
		 */
		function start():void;




	}
}