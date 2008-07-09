package inky.transitions 
{
	import  inky.events.ActionEvent;
	import inky.utils.IAction;
	import flash.events.EventDispatcher;


	/**
	 *
	 *  ..
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @since  22.02.2008
	 *
	 */
	public class EventAction extends EventDispatcher implements IAction
	{
		private var _target:Object;


		/**
		 *
		 *
		 *
		 */
		public function EventAction()
		{
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
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
		}


		/**
		 *
		 * 
		 * 
		 */
		public function finish():void
		{
			if (!this.target) return;
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}


		/**
		 *
		 * 
		 * 
		 */
		public function stop():void
		{
			if (!this.target) return;
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_STOP, false, false));
		}		




	}
}