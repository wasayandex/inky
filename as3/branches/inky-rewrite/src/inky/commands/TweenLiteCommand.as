package inky.commands 
{
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.commands.tokens.AsyncToken;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.14
	 *
	 */
	dynamic public class TweenLiteCommand implements IAsyncCommand
	{
		private var _target:Object;
		private var _duration:Number;


		/**
		 *
		 */
		public function TweenLiteCommand(duration:Number, tweenParams:Object = null, target:Object = null)
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
		private function _completeHandler(token:IAsyncToken, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			if (onComplete != null)
				onComplete.apply(null, onCompleteParams);
			
			/*
			if (this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, actionToken)))
				actionToken.async_internal::callResponders();
			*/
				
			token.callResponders();
		}
	}	
}