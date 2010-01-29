package inky.components.progressBar.views

{
	import inky.components.progressBar.views.IProgressBar;
	import inky.components.progressBar.ProgressBarMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	
	
	/**
	 *
	 *  The base class for a ProgressBar
	 *
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author     Matthew Tretter (matthew@exanimo.com)
	 *	@author 	Eric Eldredge
	 *	@version    2007.10.02
	 *
	 */
	public class BaseProgressBar extends MovieClip implements IProgressBar
	{
		private static const POLLING_RATE:uint = 100;
		
		private var _maximum:Number;
		private var _minimum:Number;
		private var _mode:String;
		private var _source:Object;
		private var _timer:Timer;
		private var _value:Number;
		
		public function BaseProgressBar()
		{
			//
			// Prevent class from being instantialized.
			//
			if (getDefinitionByName(getQualifiedClassName(this)) == BaseProgressBar)
			{
				throw new ArgumentError('Error #2012: BaseProgressBar$ class cannot be instantiated.');
			}
			
			this.mode = ProgressBarMode.EVENT;
			this._value = 0;
			this._maximum = 0;
			this._minimum = 0;
		}
		
		
		
		//
		// accessors
		//


		/**
		 *
		 * Gets or sets the maximum value for the progress bar
		 *
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}
		public function set maximum(maximum:Number):void
		{
			this._maximum = maximum;
			this.update();
		}


		/**
		 *
		 * Gets or sets the minimum value for the progress bar
		 *
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}
		public function set minimum(minimum:Number):void
		{
			this._minimum = minimum;
			this.update();
		}


		/**
		 *
		 * Gets or sets the method to be used to update the progress bar.
		 *
		 */
		public function get mode():String
		{
			return this._mode;
		}
		public function set mode(mode:String):void
		{
			// Stop monitoring using the old method
			this._unregister();
			
			this._mode = mode;
			switch (mode)
			{
				case ProgressBarMode.EVENT:
				case ProgressBarMode.MANUAL:
				case ProgressBarMode.POLLED:
					this._init();
					break;
				default:
					throw new ArgumentError('Invalid value for ProgressBar.mode');
			}
		}


		/**
		 *
		 * [read-only] Gets a number between 0 and 100 that indicates the
		 * percentage of the content has already loaded.
		 *
		 */
		public function get percentComplete():Number
		{
			var value:Number = this.value - this.minimum;
			var maximum:Number = this.maximum - this.minimum;
			return value && maximum ? value / maximum * 100 : 0;
		}


		/**
		 *
		 * Gets or sets a reference to the content that is being loaded and for
		 * which the ProgressBar is measuring the progress of the load
		 * operation.
		 *
		 */
		public function get source():Object
		{
			return this._source;
		}
		public function set source(source:Object):void
		{
			// Stop monitoring the old source.
			this._unregister();

			// Reset the progress bar.
			this.reset();

			this._source = source;
			this._init();
		}


		/**
		 *
		 * Gets or sets a value that indicates the amount of progress that has
		 * been made in the load operation.
		 *
		 */
		public function get value():Number
		{
			return this._value;
		}
		public function set value(value:Number):void
		{
			this._value = value;
			this.update();
		}




		//
		// public methods
		//


		/**
		 *
		 * Resets the progress bar for a new load operation.
		 *
		 */
		public function reset():void
		{
			this.value = 0;
		}


		/**
		 *
		 * Sets the state of the bar to reflect the amount of progress made
		 * when using manual mode.
		 *
		 * @param value:Number
		 *     A value describing the progress that has been made.
		 * @param maximum:Number
		 *     The maximum progress value of the progress bar.
		 *
		 */
		public function setProgress(value:Number, maximum:Number):void
		{
			this.maximum = maximum;
			this.value = value;
		}

		
		/**
		 *
		 *	Called when value, maximum, or minimum are set.  
		 *	Override this method to update progressBar graphics.
		 *	
		 */
		public function update():void
		{
			var bar:DisplayObject = this.getChildByName('_bar');
			if (bar)
				bar.scaleX = this.percentComplete / 100;
		}


		//
		// private methods
		//
		
		
		/**
		 *
		 * Initializes the BaseProgressBar.
		 *
		 */
		private function _init():void
		{
			switch (this.mode)
			{
				case ProgressBarMode.EVENT:
					if (!this.source) return;
					
					var source:Object = this.source is Loader ? this.source.contentLoaderInfo : this.source;
					source.addEventListener(ProgressEvent.PROGRESS, this._progressHandler);
					source.addEventListener(Event.COMPLETE, this._completeHandler);
					
					this.minimum = 0;
					this.maximum = source.bytesTotal;
					this.value = source.bytesLoaded;

					if (this.maximum && this.value == this.maximum)
						this._completeHandler(null);

					
					break;
				case ProgressBarMode.MANUAL:
					break;
				case ProgressBarMode.POLLED:
					if (!this.source) return;
					
					this._timer = new Timer(BaseProgressBar.POLLING_RATE);
					this._timer.addEventListener(TimerEvent.TIMER, this._timerHandler);
					this._timer.start();
					
					break;		
			}
		}


		/**
		 *
		 * Called when process is completed.
		 *
		 * @param e:Event
		 *     (optional) the Event that triggered the handler
		 *
		 */
		private function _completeHandler(e:Event = null):void
		{
			// If the source is changed while the event is bubbling, you may
			// get extra COMPLETE events, so check the source against
			// the event's currentTarget.
//			if (e.currentTarget != this.source) return;

			this.dispatchEvent(new Event(Event.COMPLETE));
		}


		/**
		 *
		 * Checks the progress of the source. Called on the source's PROGRESSS
		 * Event.
		 *
		 * @param e:Event
		 *     the Event that triggered the handler
		 *
		 */
		private function _progressHandler(e:ProgressEvent):void
		{
			this.minimum = 0;
			this.maximum = e.bytesTotal;
			this.value = e.bytesLoaded;

			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, this.value, this.maximum));
		}


		/**
		 *
		 * Checks the progress of the source. Called when the timer ticks.
		 *
		 * @param e:Event
		 *     the Event that triggered the handler
		 *
		 */
		private function _timerHandler(e:TimerEvent):void
		{
			if ((this.maximum != this.source.bytesTotal) || (this.value != this.source.bytesLoaded))
			{
				this.minimum = 0;
				this.maximum = this.source.bytesTotal;
				this.value = this.source.bytesLoaded;
				this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, this.value, this.maximum));

				if (this.value && (this.value == this.maximum))
				{
					this._completeHandler();
				}
			}
		}


		/**
		 *
		 * Cleans up listeners, etc. when you want to stop monitoring the
		 * progress of something.
		 *
		 */
		private function _unregister():void
		{
			switch (this.mode)
			{
				case ProgressBarMode.EVENT:
					if (this.source)
					{
						this.source.removeEventListener(ProgressEvent.PROGRESS, this._progressHandler);
						this.source.removeEventListener(Event.COMPLETE, this._completeHandler);
					}
					break;
				case ProgressBarMode.MANUAL:
					break;
				case ProgressBarMode.POLLED:
					this._timer.stop();
					this._timer.removeEventListener(TimerEvent.TIMER, this._timerHandler);
					break;
			}
		}




	}
}