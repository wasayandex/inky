package inky.framework.layout.events
{
	import flash.events.Event;


	/**
	 *
	 * Defines a LayoutEvent.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2009.03.23
	 *
	 */
	public class LayoutEvent extends Event
	{


		/**
		 *
		 * Defines the value of the <code>type</code> property for an <code>invalidate</code> 
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
         * @eventType invalidate
         * 
		 */
		public static const INVALIDATE:String = 'invalidate';




		/**
		 *
		 * Creates a new LayoutEvent object that contains information
		 * about a property change event. A LayoutEvent object is
		 * passed as a parameter to an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     LayoutEvent can have the following types of events:
		 *     LayoutEvent.INVALIDATE.
		 * @param bubbles
		 *     Determines whether the LayoutEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the LayoutEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
	    public function LayoutEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
	    {
	        super(type, bubbles, cancelable);
	    }




		//
		// public methods
		//


		/**
		 *
		 * Creates a copy of the LayoutEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new LayoutEvent object with property values that match those of
		 *     the original.
		 * 
		 */
	    override public function clone():Event
	    {
	        return new LayoutEvent(type, bubbles, cancelable);
	    }

		/**
		 *
		 * Returns a string that contains all the properties of the LayoutEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[LayoutEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the LayoutEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('LayoutEvent', 'type', 'bubbles', 'cancelable');
		}




	}
}
