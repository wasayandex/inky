package inky.framework.actions
{
	import caurina.transitions.Tweener;
	import inky.framework.actions.ActionEvent;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.actions.IAction;
	import flash.events.EventDispatcher;
	import flash.events.Event;


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
		 *
		 *
		 */
		public function TweenerAction(tweenParams:Object = null)
		{
			if (tweenParams)
			{
				for (var prop:String in tweenParams)
				{
					this[prop] = tweenParams[prop];
				}
			}
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
			Tweener.removeTweens(this.target);
		}


		/**
		 *
		 *	
		 */
		public function parseData(data:XML):void
		{
			for each (var item:XML in data.* + data.attributes())
			{
				var name = item.localName();
				this[name] = item.toString();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function start():void
		{
			if (!this.target) return;

			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));			
			Tweener.addTween(this.target, {base: this, onComplete: this._completeHandler});
		}


		/**
		 *
		 *	
		 */
		private function _completeHandler(...args:Array):void
		{
			if (this.hasOwnProperty('onComplete'))
			{
				var onCompleteFunc:Function = this['onComplete'];
				if (args && args.length)
				{
					onCompleteFunc.apply(null, args);
				}
				else
				{
					onCompleteFunc();
				}
			}
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}




	}
}
