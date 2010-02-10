package inky.media.events
{
	import flash.events.Event;
	import flash.events.ProgressEvent;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.02.10
	 *
	 */
	public class MediaProgressEvent extends ProgressEvent
	{
		public var playerIndex:uint;


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
		public function MediaProgressEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, bytesLoaded:uint = 0, bytesTotal:uint = 0, playerIndex:uint = 0)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
			this.playerIndex = playerIndex;
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new MediaProgressEvent(this.type, this.bubbles, this.cancelable, this.bytesLoaded, this.bytesTotal, this.playerIndex);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("MediaProgressEvent", "type", "bubbles", "cancelable", "bytesLoaded", "bytesTotal", "playerIndex");
		}




	}
}