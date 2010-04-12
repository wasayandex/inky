package inky.components.menu.events
{
	import flash.events.Event;

	/**
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Ryan Sprake
	 *	@since  2010.02.04
	 *
	 */
	public class MenuEvent extends Event
	{
		public static const CHANGE:String = "menuChange";

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
		public function MenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
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
			return new MenuEvent(this.type, this.bubbles, this.cancelable);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("MenuEvent", "type", "bubbles", "cancelable");
		}




	}
}

