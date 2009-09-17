package inky.async.actions
{
	import caurina.transitions.Tweener;
	import inky.async.actions.events.ActionEvent;
	import inky.app.IInkyDataParser;
	import inky.async.actions.IAction;
	import flash.events.EventDispatcher;
	import inky.async.IAsyncToken;
	import inky.async.AsyncToken;
	import inky.async.async_internal;


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @since  30.01.2008
	 *
	 */
	dynamic public class TweenerAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _target:Object;

		/**
		 *
		 */
		public function TweenerAction(tweenParams:Object = null, target:Object = null)
		{
			if (tweenParams)
			{
				for (var prop:String in tweenParams)
				{
					this[prop] = tweenParams[prop];
				}
			}
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
//			Tweener.removeTweens(this.target);
		}


		/**
		 *
		 *	
		 */
		public function parseData(data:XML):void
		{
			/*for each (var item:XML in data.* + data.attributes())
			{
				var name = item.localName();
				this[name] = item.toString();
			}*/
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
		private function _completeHandler(actionToken:IAsyncToken, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			if (onComplete != null)
				onComplete.apply(null, onCompleteParams);
			actionToken.async_internal::callResponders();
		}




	}
}
