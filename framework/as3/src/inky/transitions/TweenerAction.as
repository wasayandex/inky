package inky.transitions 
{
	import caurina.transitions.Tweener;
	import inky.events.ActionEvent;
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
	public class TweenerAction extends EventDispatcher implements IAction
	{
		private var _target:Object;
		private var _tweenParams:Object;


		/**
		 *
		 *
		 *
		 */
		public function TweenerAction(userParams:Object = null)
		{
			this._tweenParams = {};
			this._tweenParams.transition = 'easeOutSine';
			this._tweenParams.time = 0.75;
			if (userParams) for(var param:Object in userParams) this._tweenParams[param] = userParams[param];
		}




		//
		// accessors
		//


		/**
		 *
		 * 
		 * 
		 */
		public function get target():Object
		{
			return this._target;
		}
		public function set target(target:Object):void
		{
			this._target = target;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get playing():Boolean
		{
			return this.target ? Tweener.isTweening(this.target) : false;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get tweenParams():Object
		{
			return this._tweenParams;
		}



		//
		// public methods
		//


		/**
		 *
		 * 
		 * 
		 */
		public function start():void
		{
			if (!this.target) return;
			Tweener.addTween(this.target, {base:this._tweenParams, onComplete:this.dispatchEvent, onCompleteParams:[new ActionEvent(ActionEvent.ACTION_FINISH, false, false)]});
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
		}


		/**
		 *
		 * 
		 * 
		 */
		public function stop():void
		{
			if (!this.target) return;
			Tweener.removeTweens(this.target);
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_STOP, false, false));
		}		




	}
}