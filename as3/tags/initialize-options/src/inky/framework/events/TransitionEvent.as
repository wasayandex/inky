package inky.framework.events
{
	import flash.events.Event;


	/**
	 *
	 * The AssetLoaderEvent class defines events that are associated
	 * with the ITransitioningObject interface.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.02
	 *
	 */
	public class TransitionEvent extends Event
	{
		/**
		 * Defines the value of the <code>type</code> property for a <code>transitionStart</code> 
		 * event object.
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 * 	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>	
		 *    <tr><td><code>currentTarget</code></td><td>The object that is actively processing the event object with an event listener.</td></tr>
	     *     <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType transitionStart
         * 
		 */
		public static const TRANSITION_START:String = 'transitionStart';


		/**
		 * Defines the value of the <code>type</code> property for an <code>transitionFinish</code> 
		 * event object.
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 * 	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>	
		 *    <tr><td><code>currentTarget</code></td><td>The object that is actively processing the event object with an event listener.</td></tr>
	     *     <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
	     *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
	     *
	     * @eventType transitionFinish
	     * 
		 */
		public static const TRANSITION_FINISH:String = 'transitionFinish';



		
		private var _transition:Object;




		/**
		 *
		 * Creates a new TransitionEvent object that contains information about an
		 * action event. An TransitionEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     TransitionEvent can have the following types of events:
		 *     TransitionEvent.START, TransitionEvent.FINISH.
		 * @param bubbles
		 *     Determines whether the TransitionEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the TransitionEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
		public function TransitionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, transition:Object = null)
		{
			this._transition = transition;
			super(type, bubbles, cancelable);
		}




		//
		// accessors
		//
		
		
		/**
		 *
		 * 
		 * 
		 */
		public function get transition():Object
		{
			return this._transition;
		}




		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the TransitionEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new TransitionEvent object with property values that match those of
		 *     the original.
		 * 
		 */
		public override function clone():Event
		{
			return new TransitionEvent(this.type, this.bubbles, this.cancelable, this.transition);
		}
		
		
		/**
		 *
		 * Returns a string that contains all the properties of the TransitionEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[TransitionEvent type=value bubbles=value cancelable=value transition=value]</code>
		 *
		 * @return
		 *     A string representation of the TransitionEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('TransitionEvent', 'type', 'bubbles', 'cancelable', 'transition');
		}
		
		
		
		
	}
}
