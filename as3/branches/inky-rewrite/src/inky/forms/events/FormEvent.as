package inky.forms.events
{
	import flash.events.Event;


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2008.11.12
	 *
	 */
	public class FormEvent extends Event
	{
		public static const COMPLETE:String= "complete";
		public static const SUBMISSION_ERROR:String = 'submissionError';
		public static const SUBMIT:String = 'submit';
		public static const SUBMIT_CANCELLED:String = 'submitCancelled';
		public static const VALIDATION_ERROR:String = 'validationError';




		/**
		 *
		 * Creates a new FormEvent object that contains information about a
		 * navigation event. An FormEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     FormEvent can have the following types of events:
		 *     FormEvent.SUBMIT, Event.COMPLETE
		 * @param bubbles
		 *     Determines whether the FormEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the FormEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
		public function FormEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the FormEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new FormEvent object with property values that match those of
		 *     the original.
		 * 
		 */
		public override function clone():Event
		{
			return new FormEvent(this.type, this.bubbles, this.cancelable);
		}
		
		
		/**
		 *
		 * Returns a string that contains all the properties of the FormEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[FormEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the FormEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('FormEvent', 'type', 'bubbles', 'cancelable');
		}



		
	}
}
