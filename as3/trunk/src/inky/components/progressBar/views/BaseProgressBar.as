package inky.components.progressBar.views
{
	import inky.components.progressBar.views.IProgressBar;
	import inky.components.progressBar.ProgressBarMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
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
		protected var _loaded:Number;
		private var _maximum:Number;
		private var _minimum:Number;
		private var _mode:String;
		private var _source:Object;
		private var _value:Number;
		
		/**
		 * 
		 */
		public function BaseProgressBar()
		{
			//
			// Prevent class from being instantialized.
			//
			if (getDefinitionByName(getQualifiedClassName(this)) == BaseProgressBar)
				throw new ArgumentError('Error #2012: BaseProgressBar$ class cannot be instantiated.');
			
			this.mode = ProgressBarMode.EVENT;
			this._value = 0;
			this._maximum = 0;
			this._minimum = 0;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * Gets or sets the maximum value for the progress bar
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}
		public function set maximum(value:Number):void
		{
			this.setProgress(this._value, value);
		}

		/**
		 * Gets or sets the minimum value for the progress bar
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}
		public function set minimum(value:Number):void
		{
			if (value != this._minimum)
			{
				this._minimum = value;
				this.invalidate();
			}
		}

		/**
		 * Gets or sets the method to be used to update the progress bar.
		 */
		public function get mode():String
		{
			return this._mode;
		}
		public function set mode(mode:String):void
		{
			// Stop monitoring using the old method
			this.unregister();
			
			this._mode = mode;
			switch (mode)
			{
				case ProgressBarMode.EVENT:
				case ProgressBarMode.MANUAL:
				case ProgressBarMode.POLLED:
					this.init();
					break;
				default:
					throw new ArgumentError("Invalid value for ProgressBar.mode");
			}
		}

		/**
		 * Gets a number between 0 and 100 that indicates the
		 * percentage of the content has already loaded.
		 */
		public function get percentComplete():Number
		{
			var value:Number = this.value - this.minimum;
			var maximum:Number = this.maximum - this.minimum;
			return value > 0 && maximum > 0 ? Math.max(0, Math.min(1, value / maximum)) * 100 : 0;
		}

		/**
		 * Gets or sets a reference to the content that is being loaded and for
		 * which the ProgressBar is measuring the progress of the load
		 * operation.
		 */
		public function get source():Object
		{
			return this._source;
		}
		public function set source(value:Object):void
		{
			if (value != this._source)
			{
				this._source = value;

				// Reset the progress bar.
				this.reset();
			}
		}

		/**
		 * Gets or sets a value that indicates the amount of progress that has
		 * been made in the load operation.
		 */
		public function get value():Number
		{
			return this._value;
		}
		public function set value(value:Number):void
		{
			this.setProgress(value, this._maximum);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * Resets the progress bar for a new load operation.
		 */
		public function reset():void
		{
			this._setProgress(0, 0);
			this.unregister();
			this.init();
		}

		/**
		 * Sets the state of the bar to reflect the amount of progress made
		 * when using manual mode.
		 *
		 * @param value:Number
		 *     A value describing the progress that has been made.
		 * @param maximum:Number
		 *     The maximum progress value of the progress bar.
		 */
		public function setProgress(value:Number, maximum:Number):void
		{
			this._setProgress(value, maximum);
		}
		
		/**
		 *	Called when value, maximum, or minimum are set.  
		 *	Override this method to update progressBar graphics.
		 */
		public function update():void
		{
			var bar:DisplayObject = this.getChildByName('_bar');
			if (bar)
				bar.scaleX = this.percentComplete / 100;
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * Initializes the BaseProgressBar.
		 */
		private function init():void
		{
			switch (this.mode)
			{
				case ProgressBarMode.EVENT:
					var loaderInfo:Object = this.getLoaderInfo();
				
					if (!loaderInfo) return;

					loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.source_progressHandler);
					loaderInfo.addEventListener(Event.COMPLETE, this.source_completeHandler);
					
					this.minimum = 0;
					this.maximum = loaderInfo.bytesTotal;
					this.value = loaderInfo.bytesLoaded;

					if (this.maximum > 0 && this.value == this.maximum)
						this.source_completeHandler(null);

					break;
				case ProgressBarMode.MANUAL:
					break;
				case ProgressBarMode.POLLED:
					if (!this.source) return;
					this.addEventListener(Event.ENTER_FRAME, this.pollSource);
					break;		
			}
		}

		/**
		 * 
		 */
		private function getLoaderInfo():Object
		{
			return this.source is Loader ? this.source.contentLoaderInfo : this.source;
		}

		/**
		 * 
		 */
		private function invalidate():void
		{
// TODO: Implement real invalidation.
			this.update();
		}

		/**
		 * Called when process is completed.
		 *
		 * @param e:Event
		 *     (optional) the Event that triggered the handler
		 */
		private function source_completeHandler(event:Event):void
		{
			this._setProgress(this.maximum, this.maximum, true);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Checks the progress of the source. Called on the source's PROGRESSS
		 * Event.
		 *
		 * @param e:Event
		 *     the Event that triggered the handler
		 */
		private function source_progressHandler(event:ProgressEvent):void
		{
			this._setProgress(event.bytesLoaded, event.bytesTotal, true);
		}

		/**
		 * Cleans up listeners, etc. when you want to stop monitoring the
		 * progress of something.
		 */
		private function unregister():void
		{
			switch (this.mode)
			{
				case ProgressBarMode.EVENT:
				{
					if (this.source)
					{
						this.source.removeEventListener(ProgressEvent.PROGRESS, this.source_progressHandler);
						this.source.removeEventListener(Event.COMPLETE, this.source_completeHandler);
					}
					break;
				}
				case ProgressBarMode.MANUAL:
				{
					break;
				}
				case ProgressBarMode.POLLED:
				{
					this.removeEventListener(Event.ENTER_FRAME, this.pollSource);
					break;
				}
			}
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * Checks the progress of the source.
		 *
		 * @param event    the Event that triggered the handler
		 */
		protected function pollSource(event:Event):void
		{
			var loaderInfo:Object = this.getLoaderInfo();
			
			if (loaderInfo == null)
				return;
			
			var maximum:Number = loaderInfo.bytesTotal;
			var value:Number = event.type == Event.COMPLETE ? maximum : loaderInfo.bytesLoaded;			
			this._setProgress(value, maximum, true);

			if (this.maximum > 0 && this.value == this.maximum)
			{
				this.removeEventListener(Event.ENTER_FRAME, pollSource);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 
		 */
		protected function _setProgress(value:Number, maximum:Number, fireEvent:Boolean = false):void
		{
			if (value == this._value && maximum == this._maximum)
				return;
			
			if (value != this._value)
				this._value = value;
			if (maximum != this._maximum)
				this._maximum = maximum;

			if (value != this._loaded && fireEvent)
			{
				this._loaded = value;
				this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, value, maximum));
			}

			this.invalidate();
		}

	}
}