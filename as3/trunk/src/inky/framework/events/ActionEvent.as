package inky.framework.events
{
	import flash.events.Event;


	/**
	 *
	 * The ActionEvent class defines events that are associated with the Action
	 * class.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter (matthew@exanimo.com)
	 * @since  2008.02.12
	 *
	 */
	public class ActionEvent extends Event
	{
		/**
		 * Defines the value of the <code>type</code> property for an <code>actionFinish</code> 
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
         * @eventType actionFinish
         * 
		 */
		public static const ACTION_FINISH:String = 'actionFinish';


		/**
		 * Defines the value of the <code>type</code> property for an <code>actionStart</code> 
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
	     * @eventType actionStart
	     * @see #ACTION_STOP
	     * 
		 */
		public static const ACTION_START:String = 'actionStart';

		
		/**
		 * Defines the value of the <code>type</code> property for an <code>actionStop</code> 
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
	     * @eventType actionStop
	     * @see #ACTION_START
	     * 
		 */
		public static const ACTION_STOP:String = 'actionStop';




		/**
		 *
		 * Creates a new ActionEvent object that contains information about an
		 * action event. An ActionEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. An
		 *     ActionEvent can have the following types of events:
		 *     ActionEvent.ACTION_FINISH, ActionEvent.ACTION_START,
		 *     ActionEvent.ACTION_STOP.
		 * @param bubbles
		 *     Determines whether the ActionEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the ActionEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
		public function ActionEvent(type:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type, bubbles, cancelable);
		}




		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the ActionEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new ActionEvent object with property values that match those of
		 *     the original.
		 * 
		 */
		override public function clone():Event
		{
			return new ActionEvent(this.type, this.bubbles, this.cancelable);
		}
		
		
		/**
		 *
		 * Returns a string that contains all the properties of the ActionEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[ActionEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the ActionEvent object.
		 * 
		 */
		override public function toString():String
		{
			return this.formatToString('ActionEvent', 'type', 'bubbles', 'cancelable');
		}




	}
}
