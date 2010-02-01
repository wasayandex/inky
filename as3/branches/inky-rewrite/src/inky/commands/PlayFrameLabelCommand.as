package inky.commands 
{
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import flash.events.Event;
	import inky.commands.tokens.AsyncToken;
	import flash.display.FrameLabel;
	
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
	public class PlayFrameLabelCommand implements IAsyncCommand
	{
		private var _firstFrame:int;
		private var _lastFrame:int;
		private var _labelName:String;
		private var _target:Object;
		private var _token:IAsyncToken;
		

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
		
		
		
		
		//
		// accessors
		//
		
		
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
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function execute(params:Object = null):IAsyncToken
		{
			var token:AsyncToken = new AsyncToken();
			this.target.addEventListener(Event.ENTER_FRAME, this._detectEndHandler);
			this.target.gotoAndPlay(this.labelName);
			this._token = token;
			return token;
		}
		
		
		
		
		//
		// private methods
		//
		
		
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
					this._firstFrame = label.frame;
					this._lastFrame = i + 1 < max ? this.target.currentLabels[i + 1].frame - 1 : this.target.totalFrames;
				}
			}
		}
		
		
		/**
		 * 
		 */
		private function _detectEndHandler(event:Event):void
		{
			if (this.target.currentFrame == this._lastFrame)
				this._stop();
		}
		
		
		/**
		 * 
		 */
		private function _stop():void
		{
			this.target.stop();
			this.target.removeEventListener(Event.ENTER_FRAME, this._detectEndHandler);
			this._token.callResponders();
		}
		
		

		
	}
	
}