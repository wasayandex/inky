package inky.app.events
{
	import flash.events.Event;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.25
	 *
	 */
	public class NavEvent extends Event
	{
		public var options:Object;


		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 * 	@param options
		 * 		The options object; used to configure params on the resulting IRequest.  Options typically correspond to dynamic portions of a route.
		 *  @param bubbles
		 *      Specifies whether the event can bubble up the display list hierarchy.
		 *  @param cancelable
		 *      Specifies whether the behavior associated with the event can be prevented.
		 *
		 */
		public function NavEvent(type:String, options:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.options = options;
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new NavEvent(this.type, this.options, this.bubbles, this.cancelable);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("NavEvent", "type", "options", "bubbles", "cancelable");
		}




	}
}

