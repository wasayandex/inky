package inky.transitions 
{
	import caurina.transitions.Tweener;
	import inky.events.ActionEvent;
	import inky.core.IInkyDataParser;
	import inky.utils.IAction;
	import flash.events.EventDispatcher;


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
	public class TweenerAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _target:Object;
		private var _tweenParams:Object;

		/**
		 *
		 *
		 *
		 */
		public function TweenerAction(obj:Object = null)
		{
			this._tweenParams = obj || {};
		}
		
		//
		// accessors
		//
		
		/**
<<<<<<< .mine
		 *
		 * @inheritDoc
		 * 
=======
		 * @inheritDoc
>>>>>>> .r276
		 */
		public function get target():Object
		{
			return this._target;
		}
<<<<<<< .mine
		
		/**
		*
		*	@private	
		*	
		*/
=======
		/**
		 * @private
		 */
>>>>>>> .r276
		public function set target(target:Object):void
		{
			this._target = target;
		}
		
		

		//
		// public methods
		//
		
		public function parseData(data:XML):void
		{
			for each (var item:XML in data.* + data.attributes())
			{
				var name = item.localName();
				this._tweenParams[name] = item.toString();
			}
		}


<<<<<<< .mine

=======
		/**
		 * @inheritDoc
		 */
>>>>>>> .r276
		public function start():void
		{
			if (!this.target) return;
			
			Tweener.addTween(this.target, {base:this._tweenParams, onComplete:this.dispatchEvent, onCompleteParams:[new ActionEvent(ActionEvent.ACTION_FINISH, false, false)]});
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			
		}	
	}
}