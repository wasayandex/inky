package inky.events
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
		public static const READY:String = 'ready';




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
		 *     SectionEvent.NAVIGATION_COMPLETE, SectionEvent.READY.
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
		public function SectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
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