package inky.framework.actions
{
	import flash.events.EventDispatcher;
	import inky.framework.actions.ActionEvent;
	import inky.framework.actions.IAction;


	/**
	 *	
	 *	..
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 * 	@author Zack Dolin
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2008.12.08
	 *	
	 */
	public class FunctionAction extends EventDispatcher implements IAction
	{
		private var _fn:Function;
		private var _args:Array;
		private var _scope:Object;
		private var _target:Object;
		

		/**
		 *
		 */
		public function FunctionAction(fn:Function, args:Array = null, scope:Object = null)
		{
			this._fn = fn;
			this._args = args || [];
			this._scope = scope;
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
		 *	The target upon which the action acts.
		 *
		 * 	@default null	
		 * 
		 */
		public function get target():Object
		{
			return this._target;
		}
		/**
		 * 	@private	
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
		 * 	@inheritDoc
		 */
		public function start():void
		{
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			this._fn.apply(this._scope, this._args);
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}








	}
}
