package inky.commands 
{
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import flash.events.Event;
	
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
		private var _labelName:String;
		private var _labelMap:Object;
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
			this._createLabelMap();
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
		private function _createLabelMap():void
		{
			if (!this.target) return;

			// Create a hashmap that contains information about the labels.
			this._labelMap = {};
			for (var i:uint = 0; i < this.target.currentLabels.length; i++)
			{
				var label:FrameLabel = this.target.currentLabels[i];
				var nextLabel:FrameLabel = this.target.currentLabels[i + 1];
				this._labelMap[label.name] = {
					firstFrame: label.frame,
					lastFrame: nextLabel ? nextLabel.frame - 1 : this.target.totalFrames
				};
			}
		}
		
		
		/**
		 * 
		 */
		private function _detectEndHandler(event:Event):void
		{
			var lastFrame:uint = this._labelMap[this.labelName].lastFrame;
			if (this.target.currentFrame == lastFrame)
			{
				this._stop();
				this._token.callResponders();
			}
		}
		
		
		/**
		 * 
		 */
		private function _stop():void
		{
			this.target.stop();
			this.target.removeEventListener(Event.ENTER_FRAME, this._detectEndHandler);
		}
		
		

		
	}
	
}