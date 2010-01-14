package inky.commands 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
	 *	@author Matthew Tretter
	 *	@since  2010.01.14
	 *
	 */
	public class Delay implements IAsyncCommand
	{
		private var _timer:Timer;
		
		/**
		 *
		 */
		public function Delay(delay:uint)
		{
			this._timer = new Timer(delay, 1);
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function execute(params:Object = null):IAsyncToken
		{
// FIXME: Repeated calls to execute should all use different timers, right?
			var token:IAsyncTokenken = new AsyncToken();

			this._timer.addEventListener
			(
				TimerEvent.TIMER, 
				function (event:TimerEvent)
				{
					event.currentTarget.removeEventListener(event.type, arguments.callee);
					token.callResponders();
				}
			);
			
			this._timer.start();
			return token;
		}
		

		

	}
	
}