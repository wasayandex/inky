package inky.media.events
{
	import flash.events.Event;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *  @author     matthew at exanimo dot com
	 *  @author     Ryan Sprake (<http://eightdotthree.net>)
	 *  @version    2007.06.25
	 *
	 */
	public class MediaEvent extends Event
	{
		public static const AUTO_REWOUND:String = 'autoRewound';
		public static const BUFFERING_STATE_ENTERED:String = 'bufferingStateEntered';
		public static const CLOSE:String = 'close';
		public static const COMPLETE:String = 'complete';
		public static const PAUSED_STATE_ENTERED:String = 'pausedStateEntered';
		public static const PLAYHEAD_UPDATE:String = 'playheadUpdate';
		public static const PLAYING_STATE_ENTERED:String = 'playingStateEntered';
		public static const READY:String = 'ready';
		public static const SEEKED:String = 'seeked';
		public static const STATE_CHANGE:String = 'stateChange';
		public static const STOPPED_STATE_ENTERED:String = 'stoppedStateEntered';
		
		public static const METADATA_RECEIVED:String = 'metadataReceived';

		public static const FAST_FORWARD:String = 'fastForward';
		public static const REWIND:String = 'rewind';
		public static const SCRUB_FINISH:String = 'scrubFinish';
		public static const SCRUB_START:String = 'scrubStart';
		public static const SKIN_LOADED:String = 'skinLoaded';

		
		public var state:String;
		public var playheadTime:Number;
		public var playerIndex:uint;
		
		
		public function MediaEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, state:String = null, playheadTime:Number = NaN, playerIndex:uint = 0)
		{
			super(type, bubbles, cancelable);
			this.state = state;
			this.playheadTime = playheadTime;
			this.playerIndex = playerIndex;
		}


		public override function clone():Event
		{
			return new MediaEvent(this.type, this.bubbles, this.cancelable, this.state, this.playheadTime, this.playerIndex);
		}




	}
}