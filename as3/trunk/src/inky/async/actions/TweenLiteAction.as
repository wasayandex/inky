package inky.async.actions
{
	import flash.events.EventDispatcher;
	
	import inky.app.IInkyDataParser;
	import inky.async.actions.events.ActionEvent;
	import inky.async.actions.IAction;
	import inky.async.IAsyncToken;
	import inky.async.AsyncToken;
	import inky.async.async_internal;
	
	import com.greensock.*;
	import com.greensock.easing.*;


	/**
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Ryan Sprake
	 * @since  13.01.2010
	 *
	 */
	dynamic public class TweenLiteAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _target:Object;
		private var _duration:Number;

		/**
		 *
		 */
		public function TweenLiteAction(duration:Number, tweenParams:Object = null, target:Object = null)
		{			
			if(tweenParams)
			{				
				for (var prop:String in tweenParams)
				{
					this[prop] = tweenParams[prop];
				}
			}
			
			this._duration = duration;
			this._target = target;
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
		 *
		 * @inheritDoc
		 * 
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
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function cancel():void
		{
		}


		/**
		 *
		 *	
		 */
		public function parseData(data:XML):void
		{
		}
		
		
		/**
		 *	@inheritDoc
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
			if (!this.target)
				throw new Error('target is null.');

			var token:AsyncToken = new AsyncToken();
			
			// Get the tween params from this instance. (Using this as the base value for Tweener results in a memory leak.)
			var base:Object = {};
			for (var p:String in this)
			{
				base[p] = this[p];
			}
			
			base.onComplete = this._completeHandler;
			base.onCompleteParams = [token, this["onComplete"], this["onCompleteParams"]];
			
			// Dispatch an ACTION_START event.
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, token));
			
			// Create the tween.
			TweenLite.to(this.target, this._duration, base);
			
			return token;
		}	
		

		//
		// private methods
		//


		/**
		 *	
		 */
		private function _completeHandler(actionToken:IAsyncToken, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			if (onComplete != null)
				onComplete.apply(null, onCompleteParams);
				
			if (this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, actionToken)))
				actionToken.async_internal::callResponders();
		}
	}
}