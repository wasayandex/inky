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
	dynamic public class TweenerAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _target:Object;

		/**
		 *
		 *
		 *
		 */
		public function TweenerAction()
		{
		}
		
		//
		// accessors
		//
		
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
		
		public function parseData(data:XML):void
		{
			for each (var item:XML in data.* + data.attributes())
			{
				var name = item.localName();
				this[name] = item.toString();
				trace(name)
			}
		}

		/**
		 * @inheritDoc
		 */
		public function start():void
		{
			if (!this.target) return;
			
			Tweener.addTween(this.target, {base:this, onComplete:this.dispatchEvent, onCompleteParams:[new ActionEvent(ActionEvent.ACTION_FINISH, false, false)]});
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			
		}	
	}
}