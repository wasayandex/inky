package inky.sequencing.commands 
{
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	import inky.sequencing.parsers.TimeUnit;
	import flash.display.Sprite;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.30
	 *
	 */
	public class DelayCommand extends EventDispatcher implements IAsyncCommand
	{
		private var enterFrameBeacon:Sprite;
		private var frameCount:int;
		private var _isComplete:Boolean;
		
		/**
		 * The duration to delay in milliseconds.
		 */
		public var duration:Number = 0;
		
		/**
		 * The units that the duration is in. (Either TimeUnit.MILLISECONDS or TimeUnit.FRAMES)
		 */
		public var units:String = TimeUnit.MILLISECONDS;

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get async():Boolean
		{
			return true;
		}
		
		/**
		 *
		 */
		public function get isComplete():Boolean
		{ 
			return this._isComplete; 
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			this._isComplete = false;
			
			if (this.duration == 0)
			{
				this.onComplete();
			}
			else
			{
				switch (this.units)
				{
					case TimeUnit.MILLISECONDS:
					{
						setTimeout(this.onComplete, this.duration);
						break;
					}
					case TimeUnit.FRAMES:
					{
						this.frameCount = 0;
						this.enterFrameBeacon = this.enterFrameBeacon || new Sprite();
						this.enterFrameBeacon.addEventListener(Event.ENTER_FRAME, this.enterFrameBeacon_enterFrameHandler);
						break;
					}
					default:
					{
						throw new Error("Invalid unit: " + this.units);
					}
				}
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function enterFrameBeacon_enterFrameHandler(event:Event):void
		{
			this.frameCount++;
			if (this.frameCount == this.duration)
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				this.onComplete();
			}
		}
		
		/**
		 * 
		 */
		private function onComplete():void
		{
			this._isComplete = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}