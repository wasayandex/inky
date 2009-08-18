package inky.data.events
{
	import flash.events.Event;
	import inky.binding.events.PropertyChangeEvent;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.18
	 *
	 */
	public class XMLPropertyChangeEvent extends PropertyChangeEvent
	{
		public static const CHANGE:String = "change";


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
	    public function XMLPropertyChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, property:Object = null, oldValue:Object = null, newValue:Object = null, source:Object = null)
	    {
	        super(type, bubbles, cancelable, kind, property, oldValue, newValue, source);
	    }





		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new XMLPropertyChangeEvent(this.type, this.bubbles, this.cancelable, this.kind, this.property, this.oldValue, this.newValue, this.source);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("XMLPropertyChangeEvent", "type", "kind", "property", "oldValue", "newValue");
		}




	}
}