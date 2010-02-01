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
	 *	@since  2010.02.01
	 *
	 */
	public class PlayToFrameCommand implements IAsyncCommand
	{
		private var _frame:int;
		private var _target:Object;
		private var _token:IAsyncToken;
		

		/**
		 *
		 */
		public function PlayToFrameCommand(frame:int = 1, target:Object = null)
		{
			this.frame = frame;
			this.target = target;
		}
		
		
		
		
		//
		// accessors
		//
		
		/**
		 *
		 */
		public function get frame():int
		{ 
			return this._frame; 
		}
		/**
		 * @private
		 */
		public function set frame(value:int):void
		{
			this._frame = value;
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
			this.target.addEventListener(Event.ENTER_FRAME, this._update);
			this._token = token;
			return token;
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _update(event:Event):void
		{
			if (this.target.currentFrame == this._frame)
				this._stop();
			else if (this.target.currentFrame > this._frame)
				this.target.prevFrame();
			else
				this.target.nextFrame();
		}
		
		
		/**
		 * 
		 */
		private function _stop():void
		{
			this.target.removeEventListener(Event.ENTER_FRAME, this._update);
			this._token.callResponders();
		}
		
		

		
	}
	
}