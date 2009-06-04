package inky.framework.events
{
	import flash.events.Event;
	import inky.framework.core.SPath;


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.09.19
	 *
	 */
	public class NavigationEvent extends Event
	{
		public static const GOTO_SECTION:String = 'gotoSection';
		public var options:Object;
		public var relatedOptions:Object;
		public var relatedSPath:SPath;
		public var sPath:SPath;




		/**
		 *
		 * Creates a new NavigationEvent object that contains information about a
		 * navigation event. An NavigationEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     NavigationEvent can have the following types of events:
		 *     NavigationEvent.GOTO_SECTION
		 * @param bubbles
		 *     Determines whether the NavigationEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the NavigationEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
		public function NavigationEvent(type:String, bubbles:Boolean, cancelable:Boolean, sPath:SPath, options:Object, relatedSPath:SPath, relatedOptions:Object)
		{
			super(type, bubbles, cancelable);
			this.sPath = sPath;
			this.relatedSPath = relatedSPath;
			this.options = options;
			this.relatedOptions = relatedOptions;
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the NavigationEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new NavigationEvent object with property values that match those of
		 *     the original.
		 * 
		 */
		public override function clone():Event
		{
			return new NavigationEvent(this.type, this.bubbles, this.cancelable, this.sPath, this.options, this.relatedSPath, this.relatedOptions);
		}
		
		
		/**
		 *
		 * Returns a string that contains all the properties of the NavigationEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[NavigationEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the NavigationEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('NavigationEvent', 'type', 'bubbles', 'cancelable', 'sPath', 'options', 'relatedSPath', 'relatedOptions');
		}



		
	}
}
