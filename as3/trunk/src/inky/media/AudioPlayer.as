package inky.media
{
	import inky.media.IMediaPlayer;
	import inky.media.events.MediaEvent;
	import inky.media.events.MediaProgressEvent;
	import inky.media.MediaState;
	import inky.media.events.AudioEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;



	/**
	 *
	 * Defines an AudioPlayer object which simplifies sound interaction.
	 *	
	 * @author     Matthew Tretter (http://exanimo.com)
	 * @author     Ryan Sprake (http://eightdotthree.net)
	 *
	 */
	public class AudioPlayer extends EventDispatcher implements IMediaPlayer
	{
// TODO: Adhere more closely to dictates of IMediaPlayer, especially in regards to queuing
// TODO: add SEEKED event
// TODO: add error handling, more robust streaming capabilities.
// TODO: add READY event

		private var _autoRewind:Boolean;
		private var _bufferTime:Number;
		private var _bufferingTimer:Timer;
		private var _pan:Number = 0;
		private var _position:Number;
		private var _playheadUpdateTimer:Timer;
		private var _progressTimer:Timer;
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _source:String;
		private var sp:Number;
		private var _state:String;
		private var _totalTime:Number;
		private var _volume:Number;


		/**
		 *
		 * Constructs!
		 *
		 */
		public function AudioPlayer()
		{
			this._autoRewind = false;
			this._bufferTime = 0.1;
			this._volume = 1;
			this.sp = NaN;
		}
	
	
	
	
		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return this._autoRewind;
		}
		public function set autoRewind(autoRewind:Boolean):void
		{
			this._autoRewind = autoRewind;
		}


		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return this._bufferTime;
		}
		public function set bufferTime(bufferTime:Number):void
		{
			this._bufferTime = bufferTime;
		}

	
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return this._sound.bytesLoaded;
		}


		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return this._sound.bytesTotal;
		}


		/**
		 * @inheritDoc
		 */
		public function get metadata():Object
		{
			return this._sound.id3;
		}
		
	
		/**
		 * @inheritDoc
		 */
		public function get pan():Number
		{
			return this.soundTransform.pan;
		}
		/**
		 * @private
		 */
		public function set pan(pan:Number):void
		{
			var oldPan:Number = this._soundTransform.pan;
			this._soundTransform = new SoundTransform(this.volume, pan);
			this._updateSoundTransform();

			if (oldPan != pan)
			{
				this._dispatchSoundUpdateEvent();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get playheadTime():Number
		{
			return this._soundChannel ? this._soundChannel.position / 1000 : 0;
		}
		/**
		 * @private
		 */
		public function set playheadTime(playheadTime:Number):void
		{
			this.seek(playheadTime);
		}
		

		/**
		 * @inheritDoc
		 */
		public function get playheadUpdateInterval():Number
		{
			return this._playheadUpdateTimer.delay;
		}
		/**
		 * @private
		 */
		public function set playheadUpdateInterval(playheadUpdateInterval:Number):void
		{
			if (this._playheadUpdateTimer)
			{
				this._playheadUpdateTimer.stop();
				this._playheadUpdateTimer.removeEventListener(TimerEvent.TIMER, this._dispatchPlayheadUpdateEvent);
			}

			this._playheadUpdateTimer = new Timer(playheadUpdateInterval);
			this._playheadUpdateTimer.addEventListener(TimerEvent.TIMER, this._dispatchPlayheadUpdateEvent, false, 0, true);
			
			if (this.state == MediaState.PLAYING)
			{
				this._playheadUpdateTimer.start();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get progressInterval():Number
		{
			return this._progressTimer.delay;
		}
		/**
		 * @private	
		 */
		public function set progressInterval(progressInterval:Number):void
		{
			var running:Boolean = this._progressTimer && this._progressTimer.running;
			
			if (this._progressTimer)
			{
				this._progressTimer.stop();
				this._progressTimer.removeEventListener(TimerEvent.TIMER, this._dispatchProgressEvent);
			}

			this._progressTimer = new Timer(progressInterval);
			this._progressTimer.addEventListener(TimerEvent.TIMER, this._dispatchProgressEvent, false, 0, true);
			
			if (running)
			{
				this._progressTimer.start();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get soundTransform():SoundTransform
		{
			return this._soundTransform;
		}
		/**
		 * @private	
		 */
		public function set soundTransform(soundTransform:SoundTransform):void
		{
			var oldSoundTransform:SoundTransform = this._soundTransform;
			this._soundTransform = soundTransform;
			this._updateSoundTransform();
			
			if (oldSoundTransform != soundTransform)
			{
				this._dispatchSoundUpdateEvent();
			}
		}


		/**
		 * @inheritDoc
		 */	
		public function get source():String
		{
			return this._source;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get state():String
		{
			return this._state;
		}


		/**
		 * @inheritDoc
		 */
		public function get totalTime():Number
		{
// TODO: How do we want this to work? Should it really estimate like it does? Or should that be another prop?
			return this._totalTime;
		}

	
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return this.soundTransform.volume;
		}
		/**
		 * @private	
		 */
		public function set volume(volume:Number):void
		{
			var oldVolume:Number;
			
			if (this._soundTransform != null)
			{
				oldVolume = this._soundTransform.volume;
				this._soundTransform = new SoundTransform(volume, this.pan);
				this._updateSoundTransform();
			}
			
			if (oldVolume != volume)
			{
				this._dispatchSoundUpdateEvent();
			}
		}
	
	
	
	
		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			this._stop();
			if (this._sound)
				this._sound.close();
			this._dispatchMediaEvent(MediaEvent.CLOSE);
		}

		
		/**
		 * @inheritDoc
		 */
		public function load(url:String):void
		{
			this._load(url);
			if (this._soundChannel)
			{
				this.pause();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			this._stop();
			this._position = this.playheadTime;
			this._setAndDispatchState(MediaState.PAUSED);

		}
		
		
		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			this._play(this._position || 0);
			this._playheadUpdateTimer.start();
		}


		/**
		 * @inheritDoc
		 */
		public function seek(time:Number):void
		{
			this._play(time);
			
			if (this.state != MediaState.PLAYING)
			{
				this.pause();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			if (this._state == MediaState.STOPPED) return;
			this._stop();
			this._position = this.autoRewind ? 0 : this.playheadTime;
			this._setAndDispatchState(MediaState.STOPPED);
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _bufferingTimerHandler(e:TimerEvent = null):void
		{
			if (this._sound && !this._sound.isBuffering)
			{
				// When the sound has finished buffering, dispatch a playing event.
				if (this._state == MediaState.BUFFERING)
				{
					this._setAndDispatchState(MediaState.PLAYING);
				}
			}
			else if (this._state == MediaState.PLAYING)
			{
				// TODO: Pause until the buffer is complete again.
			}
		}


		/**
		 *
		 *
		 *
		 */
		private function _dispatchMediaEvent(type:String):void
		{
			this.dispatchEvent(new MediaEvent(type, false, false, this.state, this.playheadTime, this.sp));
		}


		/**
		 *
		 *
		 *
		 */
		private function _dispatchPlayheadUpdateEvent(e:TimerEvent = null):void
		{
			this._dispatchMediaEvent(MediaEvent.PLAYHEAD_UPDATE);
		}


		/**
		 *
		 *
		 *
		 */
		private function _dispatchProgressEvent(e:TimerEvent = null):void
		{
			this.dispatchEvent(new MediaProgressEvent(MediaProgressEvent.PROGRESS, false, false, this.bytesLoaded, this.bytesTotal, this.sp));
			
			if (this.bytesLoaded == this.bytesTotal)
			{
				this._progressTimer.stop()
			}
		}


		/**
		 *
		 *
		 *
		 */
		private function _dispatchSoundUpdateEvent():void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.SOUND_UPDATE, false, false, this._soundTransform));
		}


		/**
		 *
		 *
		 *
		 */
		private function _getDuration():void
		{
			this._getDurationHelper();
			this._sound.addEventListener(ProgressEvent.PROGRESS, this._getDurationHelper, false, 0, true);
		}


		/**
		 *
		 *	
		 */
		private function _getDurationHelper(e:ProgressEvent = null):void
		{
			if (this._sound)
			{
				var isComplete:Boolean = this._sound.bytesTotal && (this._sound.bytesLoaded == this._sound.bytesTotal);
				var removeListener:Boolean = isComplete;
		
				if (!isNaN(this._sound.id3.TLEN))
				{
					this._totalTime = this._sound.id3.TLEN;
					removeListener = true;
				}
				else if (isComplete && this._sound.length)
				{
					this._totalTime = this._sound.length / 1000;
					removeListener = true;
				}
				else
				{
					this._totalTime = this._sound.length * this.bytesTotal / this.bytesLoaded / 1000;
				}
		
				if (removeListener)
				{
					this._sound.removeEventListener(ProgressEvent.PROGRESS, this._getDurationHelper);
				}
			}
		}


		/**
		 *
		 *
		 *
		 */
		private function _load(url:String):void
		{
			if (this._sound)
			{
				this.stop();
				this._sound.removeEventListener(Event.ID3, this._relayID3Event);
				this._sound.removeEventListener(ProgressEvent.PROGRESS, this._progressHandler);
				
				// Do this without a try/catch
				try
				{
					this._sound.close();
				}
				catch(error:Error)
				{
				}
			}

			this._sound = new Sound();
			this._soundTransform = this._soundTransform || new SoundTransform();
			this._updateSoundTransform();
			this._totalTime = NaN;
			this._position = 0;
			this.playheadUpdateInterval = this._playheadUpdateTimer ? this.playheadUpdateInterval : 250;
			this.progressInterval = this._progressTimer ? this.playheadUpdateInterval : 250;
			this._sound.addEventListener(Event.ID3, this._relayID3Event, false, 0, true);
			this._sound.addEventListener(Event.COMPLETE, this._loadCompleteHandler, false, 0, true);
			this._sound.addEventListener(ProgressEvent.PROGRESS, this._progressHandler, false, 0, true);
			this._getDuration();
			this._source = url;
			this._setAndDispatchState(MediaState.LOADING);
// TODO: Don't always set checkPolicyFile to true.
			this._sound.load(new URLRequest(url), new SoundLoaderContext(this.bufferTime * 1000, true));
		}


		/**
		 * Called when the sound is finished loading if its an MP3.
		 */
		private function _loadCompleteHandler(e:Event):void
		{
			this._sound.removeEventListener(Event.COMPLETE, this._loadCompleteHandler);
			this._stopBufferingTimer();
			this._getDuration();
			this.dispatchEvent(new Event(Event.COMPLETE, false, false));
		}


		/**
		 *
		 *
		 *
		 */
		private function _play(time:Number):void
		{
			if (this._soundChannel)
			{
				this._soundChannel.stop();
			}
			this._setAndDispatchState(MediaState.BUFFERING);
			this._startBufferingTimer();
			this._soundChannel = this._sound.play(time * 1000, 0, this.soundTransform);
			this.soundTransform = this._soundChannel.soundTransform;
			this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this._soundCompleteHandler, false, 0, true);
		}


		/**
		 *
		 *
		 *
		 */
		private function _progressHandler(e:ProgressEvent):void
		{
			// Dispatch the first progress event immediately.
			this._dispatchProgressEvent();
			
			// Dispatch subsequent events every this.progressInterval ms.
			this._progressTimer.start();
			this._sound.removeEventListener(ProgressEvent.PROGRESS, this._progressHandler);
		}


		/**
		 *
		 *
		 *
		 */
		private function _relayID3Event(e:Event):void
		{
			this._getDuration();
			this._dispatchMediaEvent(MediaEvent.METADATA_RECEIVED);
		}


		/**
		 * Sets the state of the application and dispatches the appropriate event.
		 */
		private function _setAndDispatchState(state:String):void
		{
			this._state = state;
			this._dispatchMediaEvent(MediaEvent.STATE_CHANGE);
			var stateEnteredEventType:String;
			
			switch(state)
			{
				case MediaState.BUFFERING:
					stateEnteredEventType = MediaEvent.BUFFERING_STATE_ENTERED;
					break;
				case MediaState.STOPPED:
					stateEnteredEventType = MediaEvent.STOPPED_STATE_ENTERED;
					break;
				case MediaState.PLAYING:
					stateEnteredEventType = MediaEvent.PLAYING_STATE_ENTERED;
					break;
				case MediaState.PAUSED:
					stateEnteredEventType = MediaEvent.PAUSED_STATE_ENTERED;
					break;
			}
			
			if (stateEnteredEventType)
			{
				this._dispatchMediaEvent(stateEnteredEventType);
			}
		}


		/**
		 *
		 *	
		 */
		private function _startBufferingTimer():void
		{
			this._stopBufferingTimer();
			this._bufferingTimer = new Timer(10);
			this._bufferingTimer.addEventListener(TimerEvent.TIMER, this._bufferingTimerHandler, false, 0, true);
			this._bufferingTimer.start();
			this._bufferingTimerHandler();
		}


		/**
		 *
		 * Called when player is paused or stopped.
		 *	
		 */
		private function _stop():void
		{
			this._stopBufferingTimer();
			if (this._soundChannel)
				this._soundChannel.stop();
			if (this._playheadUpdateTimer)
				this._playheadUpdateTimer.stop();
		}


		/**
		 *
		 *	
		 */
		private function _stopBufferingTimer():void
		{
			this._bufferingTimerHandler(null);
			if (this._bufferingTimer)
			{
				this._bufferingTimer.stop();
			}
			this._bufferingTimer = null;
		}


		/**
		 *
		 *
		 *
		 */
		private function _soundCompleteHandler(e:Event):void
		{
			this._dispatchPlayheadUpdateEvent();

			// Autorewind
			if (this.autoRewind)
				this.seek(0);
				
			this.stop();
			
			if (this.autoRewind)
				this._dispatchMediaEvent(MediaEvent.AUTO_REWOUND);
		}


		/**
		 *
		 *	
		 */
		private function _updateSoundTransform():void
		{
			if (this._soundChannel)
			{
				this._soundChannel.soundTransform = this._soundTransform;
			}
		}




	}
}