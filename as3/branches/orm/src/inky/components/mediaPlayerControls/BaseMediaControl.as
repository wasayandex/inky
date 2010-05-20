package inky.components.mediaPlayerControls
{
	import flash.utils.Dictionary;
	import flash.events.Event;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.07
	 *
	 */
	public class BaseMediaControl
	{
		private var _registeredMediaPlayers:Dictionary;

		/**
		 *
		 */
		public function BaseMediaControl()
		{
			this._registeredMediaPlayers = new Dictionary(true);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		protected function get registeredMediaPlayers():Array
		{
			var registeredMediaPlayers:Array = [];
			for (var mediaPlayer:Object in this._registeredMediaPlayers)
				registeredMediaPlayers.push(mediaPlayer);
			return registeredMediaPlayers;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *	Register a media player with this instance. This control will respond to the registered media player and interacting with it will affect the registered player.
		 */
		public function registerMediaPlayer(mediaPlayer:Object, playerChangeEvents:Array = null):void
		{
			this.unregisterMediaPlayer(mediaPlayer);
			this._registeredMediaPlayers[mediaPlayer] = playerChangeEvents;
			
			for each (var eventType:String in playerChangeEvents)
			{
				mediaPlayer.addEventListener(eventType, this.mediaPlayerChangeHandler, false, 0, true);
			}
			this.onMediaPlayerRegistered(mediaPlayer);
		}

		/**
		 *	Unregisters a media player with this instance. This control will no longer affect (or be effected by) the specified player.
		 */
		public function unregisterMediaPlayer(mediaPlayer:Object):void
		{
			if (this._registeredMediaPlayers[mediaPlayer] !== undefined)
			{
				var playerChangeEvents:Array = this._registeredMediaPlayers[mediaPlayer];
				for each (var eventType:String in playerChangeEvents)
				{
					mediaPlayer.removeEventListener(eventType, this.mediaPlayerChangeHandler);
				}

				delete this._registeredMediaPlayers[mediaPlayer];
				this.onMediaPlayerUnregistered(mediaPlayer);
			}
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * 
		 */
		protected function mediaPlayerChangeHandler(event:Event):void
		{
		}

		/**
		 *	Callback for when a media player is registered.
		 */
		protected function onMediaPlayerRegistered(mediaPlayer:Object):void
		{
		}

		/**
		 * Callback for when a media player is unregistered.	
		 */
		protected function onMediaPlayerUnregistered(mediaPlayer:Object):void
		{
		}

	}
}