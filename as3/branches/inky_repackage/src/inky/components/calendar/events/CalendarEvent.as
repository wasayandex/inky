package inky.components.calendar.events
{
	import flash.events.Event;

	
	/**
	 *
	 *  ..
	 *
	 *  @langversion ActionScript 3.0
	 *  @playerversion Flash 9.0
	 *
	 *  @author Eric Eldredge
	 *  @since  2009.03.18
	 *
	 */
	public class CalendarEvent extends Event
	{
		public static const SELECTED_DATE_CHANGE:String = 'selectedDateChange';


		/**
		 *
		 */
		public function CalendarEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
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
			return new CalendarEvent(this.type, this.bubbles, this.cancelable);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString('CalendarEvent', 'type', 'bubbles', 'cancelable');
		}




	}
}

