package inky.components.transitioningObject
{
	import inky.async.actions.IAction;
	import inky.utils.IDisplayObject;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import inky.commands.IAsyncToken;


    /**
     * 
     * Dispatched when a transition finishes.
     *
     * @eventType inky.components.transitioningObject.events.TransitionEvent.TRANSITION_FINISH
     *
     */
	[Event(name="transitionFinish", type="inky.components.transitioningObject.events.TransitionEvent")]


    /**
     * 
     * Dispatched when a transition starts.
     *
     * @eventType inky.components.transitioningObject.events.TransitionEvent.TRANSITION_START
     *
     */
	[Event(name="transitionStart", type="inky.components.transitioningObject.events.TransitionEvent")]




	/**
	 *
	 * An object that automatically plays an intro and outro. While the intro
	 * is played automatically when the object is added to the stage using the
	 * normal method (parent.addChild), you must use the object's remove method
	 * in order to trigger the outro.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2008.01.10
	 *
	 */
	public interface ITransitioningObject extends IDisplayObject
	{
		//
		// accessors
		//


		/**
		 *
		 * The action that will be run when the DisplayObject is added to the
		 * stage. This action will be started automatically when the object
		 * is added to the stage.
		 * 
		 * 
		 */
		function get intro():IAction;
		/**
		 * @private
		 */
		function set intro(intro:IAction):void;


		/**
		 *
		 * The action that will be run when the DisplayObject is removed from
		 * the stage. This action will be started automatically when the
		 * <code>remove()</code> method is called.
		 * 
		 * @see inky.async.actions.PlayFrameLabelAction
		 * @see #remove();
		 * 
		 */
		function get outro():IAction;
		/**
		 * @private
		 */
		function set outro(outro:IAction):void;


		/**
		 *
		 * Identifies the state of the clip. Possible values are in
		 * TransitioningObjectState.
		 * 
		 */
		function get state():String;




		//
		// public methods
		//


		/**
		 *
		 * Removes this object from the display list. Unlike calling the
		 * parent's <code>removeChild()</code> method, calling this method does
		 * not immediately result in the object being removed from the display
		 * list. Instead, the outro action will be started. When the action
		 * finishes, the object will be removed from the stage via a call to
		 * its parent's <code>removeChild()</code> method.
		 *	
		 * @see #outro
		 * @see flash.display.DisplayObjectContainer#removeChild()
		 * 	
		 */
		function remove():IAsyncToken;




	}
}