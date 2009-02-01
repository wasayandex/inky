package inky.framework.events
{
	import flash.events.Event;

	/**
	 *
	 * The AssetLoaderEvent class defines events that are associated
	 * with the Section class.
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
	public class SectionEvent extends Event
	{
		public static const NAVIGATION_COMPLETE:String = 'navigationComplete';
		
        /**
         * The <code>SectionEvent.SUBSECTION_INITIALIZE</code> constant defines the value of the <code>type</code> property
         * of an <code>subsectionInitialize</code> event object. 
         * 
         * <p>This event has the following properties:</p>
         *  <table class="innertable" width="100%">
         *     <tr><th>Property</th><th>Value</th></tr>
         *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
         *     <tr><td><code>cancelable</code></td><td><code>false</code>; there is no default
         *          behavior to cancel.</td></tr>
         *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener. </td></tr>
		 *     <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
         *  </table>
         *
         * @eventType initialize
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static const SUBSECTION_INITIALIZE:String = 'subsectionInitialize';




		/**
		 *
		 * Creates a new SectionEvent object that contains information about an
		 * action event. An SectionEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     SectionEvent can have the following types of events:
		 *     SectionEvent.NAVIGATION_COMPLETE, SectionEvent.INITIALIZE
		 * @param bubbles
		 *     Determines whether the SectionEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the SectionEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
		public function SectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the SectionEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new SectionEvent object with property values that match those of
		 *     the original.
		 * 
		 */
		public override function clone():Event
		{
			return new SectionEvent(this.type, this.bubbles, this.cancelable);
		}
		
		
		/**
		 *
		 * Returns a string that contains all the properties of the SectionEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[SectionEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the SectionEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('SectionEvent', 'type', 'bubbles', 'cancelable');
		}



		
	}
}
