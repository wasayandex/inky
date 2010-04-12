package inky.app.controller.requestHandlers 
{
	import inky.app.controller.requestHandlers.IRequestHandler;
	import inky.commands.collections.CommandQueue;
	import inky.app.controller.requests.CancelQueuedCommands;
	import inky.app.controller.requests.QueueCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.02
	 *
	 */
	public class QueueManager implements IRequestHandler
	{
		private var _queue:CommandQueue;
		
		/**
		 *
		 */
		public function QueueManager()
		{
			this._queue = new CommandQueue();
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):Object
		{
			if (request is CancelQueuedCommands)
				this._cancelQueuedCommands();
			else if (request is QueueCommand)
				this._queueCommand(request.command);

			return request;
		}




		//
		// private methods
		//


		/**
		 * 
		 */
		private function _cancelQueuedCommands():void
		{
// TODO: Cancel the queued commands.
		}


		/**
		 * 
		 */
		private function _queueCommand(command:Object):void
		{
			this._queue.addItem(command);
			this._queue.start();
		}

	}
	
}