package inky.async.actions
{
	import flash.events.EventDispatcher;
	import inky.async.actions.events.ActionEvent;
	import inky.async.actions.IAction;
	import inky.async.AsyncToken;
	import inky.async.IAsyncToken;
	import inky.async.async_internal;


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
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		public function start():IAsyncToken
		{
			return this.startAction();
		}


		/**
		 * 	@inheritDoc
		 */
		public function startAction():IAsyncToken
		{
			var token:IAsyncToken = this._fn.apply(this._scope, this._args) as IAsyncToken;
			var fnReturnsToken:Boolean = !!token;
			token = token || new AsyncToken();

// FIXME: By the point start event is fired, fn has already been called.
			var startEvent:ActionEvent = new ActionEvent(ActionEvent.ACTION_START, token, false, true);
			this.dispatchEvent(startEvent);

			var finishEvent:ActionEvent = new ActionEvent(ActionEvent.ACTION_FINISH, token, false, true);
			this.dispatchEvent(finishEvent);

// Should we call the responders if default is prevented?
if (!fnReturnsToken)
	token.async_internal::callResponders();

			return token;
		}








	}
}