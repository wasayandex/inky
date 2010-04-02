package inky.sequencing.events
{
	import flash.events.Event;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.03.29
	 *
	 */
	public class SequenceEvent extends Event
	{
		/**
		 *  The <code>SequenceEvent.COMPLETE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>complete</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType complete
		 */
		public static const COMPLETE:String = "complete";

		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param bubbles
		 *      Specifies whether the event can bubble up the display list hierarchy.
		 *  @param cancelable
		 *      Specifies whether the behavior associated with the event can be prevented.
		 *
		 */
		public function SequenceEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);		
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SequenceEvent(this.type, this.bubbles, this.cancelable);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("SequenceEvent", "type", "bubbles", "cancelable");
		}




	}
}

