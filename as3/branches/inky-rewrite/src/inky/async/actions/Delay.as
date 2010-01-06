package inky.async.actions
{
	import flash.events.EventDispatcher;
	import inky.async.actions.events.ActionEvent;
	import inky.async.actions.IAction;
	import inky.commands.AsyncToken;
	import inky.commands.IAsyncToken;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	/**
	 *	
	 *	..
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2009.08.27
	 *	
	 */
	public class Delay extends EventDispatcher implements IAction
	{
		private var _delay:uint;
		private var _timer:Timer;
		

		/**
		 *
		 */
		public function Delay(delay:uint)
		{
			this._delay = delay;
			this._timer = new Timer(delay, 1);
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
// FIXME: Repeated calls to startAction should all use different timers, right?
			var token:IAsyncToken = new AsyncToken();
			
			var startEvent:ActionEvent = new ActionEvent(ActionEvent.ACTION_START, token, false, true);
			var scope:Object = this;
			this._timer.addEventListener(
				TimerEvent.TIMER_COMPLETE,
				function(event:TimerEvent):void
				{
// FIXME: This is pretty sloppy. What if event never fires?
					event.currentTarget.removeEventListener(event.type, arguments.callee);
					
					var finishEvent:ActionEvent = new ActionEvent(ActionEvent.ACTION_FINISH, token, false, true);
					scope.dispatchEvent(finishEvent);					
					
					token.callResponders();
				}
			);
			
			this._timer.start();

			return token;
		}








	}
}