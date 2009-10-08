package inky.media.events
{
	import flash.events.Event;
	
	
	/**
	 *
	 * 
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author     Matthew Tretter (matthew@exanimo.com)
	 *
	 */
	public class MediaProgressEvent extends Event
	{
		public static const PROGRESS:String = 'progress';
		
		public var bytesLoaded:uint;
		public var bytesTotal:uint;
		public var playerIndex:uint;
		
		
		public function MediaProgressEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, bytesLoaded:uint = 0, bytesTotal:uint = 0, playerIndex:uint = 0)
		{
			super(type, bubbles, cancelable);
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
			this.playerIndex = playerIndex;
		}


	}
}