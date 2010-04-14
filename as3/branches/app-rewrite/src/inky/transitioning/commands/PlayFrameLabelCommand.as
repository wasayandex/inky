package inky.transitioning.commands 
{
	import flash.events.Event;
	import flash.display.FrameLabel;
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *  @author Matthew Tretter
	 *	@since  2010.01.14
	 *
	 */
	public class PlayFrameLabelCommand extends EventDispatcher implements IAsyncCommand
	{
		private var firstFrame:int;
		private var lastFrame:int;
		private var _labelName:String;
		private var _target:Object;
		

		/**
		 *
		 */
		public function PlayFrameLabelCommand(labelName:String = null, target:Object = null)
		{
			if (labelName)
				this.labelName = labelName;
			if (target)
				this.target = target;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isAsync():Boolean
		{
			return true;
		}
		
		/**
		 *
		 */
		public function get labelName():String
		{ 
			return this._labelName; 
		}
		/**
		 * @private
		 */
		public function set labelName(value:String):void
		{
			this._labelName = value;
		}
		
		
		/**
		 *
		 */
		public function get target():Object
		{ 
			return this._target; 
		}
		/**
		 * @private
		 */
		public function set target(value:Object):void
		{
			this._target = value;
			this._init();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			this.target.addEventListener(Event.ENTER_FRAME, this.detectEndHandler);
			this.target.gotoAndPlay(this.labelName);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function _init():void
		{
			if (!this.target) return;

			var max:int = this.target.currentLabels.length;
			for (var i:uint = 0; i < max; i++)
			{
				var label:FrameLabel = this.target.currentLabels[i];
				if (label.name == this.labelName)
				{
					this.firstFrame = label.frame;
					this.lastFrame = i + 1 < max ? this.target.currentLabels[i + 1].frame - 1 : this.target.totalFrames;
				}
			}
		}
		
		/**
		 * 
		 */
		private function detectEndHandler(event:Event):void
		{
			if (this.target.currentFrame == this.lastFrame)
				this.stop();
		}
		
		/**
		 * 
		 */
		private function stop():void
		{
			this.target.stop();
			this.target.removeEventListener(Event.ENTER_FRAME, this.detectEndHandler);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}