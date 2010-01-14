package inky.commands.collections 
{
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.collections.IIterator;
	import inky.commands.tokens.AsyncToken;
	import inky.collections.Set;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.13
	 *
	 */
	public class CommandGroup extends Set implements IAsyncCommand
	{
		private var _currentIndex:Number;
		
		
		/**
		 *
		 */
		public function CommandGroup(...rest:Array)
		{
			this._currentIndex = 0;
			for each (var command:Object in rest)
				this.addItem(command);
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function execute(params:Object = null):IAsyncToken
		{
			var token:AsyncToken = new AsyncToken();
			this._startGroup(token);
			return token;
		}
		
		
		/**
		 * 
		 */
		public function start():IAsyncToken
		{
			return this.execute();
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _finishGroup(groupToken:IAsyncToken):void
		{
			if (++this._currentIndex >= this.length)
				groupToken.callResponders();
		}


		/**
		 *	Iterates through the group, starting each command.
		 */
		private function _startGroup(groupToken:IAsyncToken):void
		{
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var token:IAsyncToken = i.next().execute();
				if (!(token is IAsyncToken))
				{
					token = new AsyncToken();
					token.callResponders();
				}

				token.addResponder(
					function()
					{
						_finishGroup(groupToken);
					}
				);
			}
		}


		
	}
	
}