package inky.commands 
{
	import caurina.transitions.Tweener;
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.commands.tokens.AsyncToken;
	
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
	dynamic public class TweenerCommand implements IAsyncCommand
	{
		private var _target:Object;


		/**
		 *
		 */
		public function TweenerCommand(tweenParams:Object = null, target:Object = null)
		{
			if (tweenParams)
			{
				for (var prop:String in tweenParams)
					this[prop] = tweenParams[prop];
			}
			this._target = target;
		}
		
		
		
		
		//
		// accessors
		//
		
		
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
				base[p] = this[p];

			// Create the tween.
			Tweener.addTween(this.target, {base: base, onComplete: this._completeHandler, onCompleteParams: [token, this["onComplete"], this["onCompleteParams"]]});
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
				
			token.callResponders();
		}
		
		


	}
	
}
