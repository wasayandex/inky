package inky.async.actions
{
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.async.actions.events.ActionEvent;
	import inky.async.actions.IAction;
	import inky.async.IAsyncToken;
	import inky.async.AsyncToken;
	import inky.async.async_internal;


	/**
	 *
	 *  ..
	 * 
	 * 	@langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.02.12
	 *
	 */
	public class PlayFrameLabelAction extends EventDispatcher implements IAction
	{
		private var _labelName:String;
		private var _labelMap:Object;
		private var _target:Object;
		private var _token:IAsyncToken;



		/**
		 *
		 *
		 *
		 */
		public function PlayFrameLabelAction(labelName:String = null, target:Object = null)
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
		 * @inheritDoc
		 */
		public function get cancelable():Boolean
		{
			return true;
		}


		/**
		 * @inheritDoc
		 */
		public function get target():Object
		{
			return this._target;
		}
		/**
		 * @private
		 */
		public function set target(target:Object):void
		{
			this._target = target;
			this._createLabelMap();
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get labelName():String
		{
			return this._labelName;
		}
		/**
		 * @private
		 */
		public function set labelName(labelName:String):void
		{
			this._labelName = labelName;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function cancel():void
		{
			/*this.stop();*/
		}
		
		
		/**
		 *	
		 */
		public function start():IAsyncToken
		{
			return this.startAction();
		}


		/**
		 * @inheritDoc
		 */
		public function startAction():IAsyncToken
		{
			var token:AsyncToken = new AsyncToken();
			var startEvent:ActionEvent = new ActionEvent(ActionEvent.ACTION_START, token, false, true);
			this.dispatchEvent(startEvent);
			if (!startEvent.isDefaultPrevented())
			{
				this.target.addEventListener(Event.ENTER_FRAME, this._detectEndHandler);
				this.target.gotoAndPlay(this.labelName);
			}
			this._token = token;
			return token;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function stop():void
		{
			/*this._stop();
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_STOP, false, false));*/
		}




		//
		// private methods
		//
		
		
		/**
		 *
		 * 
		 * 
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
		 *
		 *
		 * @param e:Event
		 *     the ENTER_FRAME event that triggered the handler
		 *
		 */
		private function _detectEndHandler(e:Event):void
		{
			var lastFrame:uint = this._labelMap[this.labelName].lastFrame;
			if (this.target.currentFrame == lastFrame)
			{
				this._stop();
				var finishEvent:ActionEvent = new ActionEvent(ActionEvent.ACTION_FINISH, this._token, false, true);
				this.dispatchEvent(finishEvent);
				if (!finishEvent.isDefaultPrevented())
				{
					this._token.async_internal::callResponders();
				}
			}
		}
		
		
		/**
		 *
		 * 
		 * 
		 */
		private function _stop():void
		{
			this.target.stop();
			this.target.removeEventListener(Event.ENTER_FRAME, this._detectEndHandler);
		}




	}
}