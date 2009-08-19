package inky.xml.events
{
	import flash.events.Event;

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
	public class XMLChangeEvent extends Event
	{
		public var changeEvent:Event;
		public var source:Object;
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
	    public function XMLChangeEvent(type:String, source:Object, changeEvent:Event)
	    {
	        super(type, false, false);
			this.changeEvent = changeEvent;
			this.source = source;
	    }





		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new XMLChangeEvent(this.type, this.source, this.changeEvent);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("XMLChangeEvent", "changeEvent");
		}




	}
}