package inky.commands 
{
	import inky.commands.ICommand;
	import inky.commands.IChainable;
	import inky.commands.IAsyncCommand;
	
	/**
	 *
	 *  A command that may be used in a chain of responsibility pattern.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.06
	 *
	 */
	public class ChainableCommand implements IChainable
	{
		private var _next:Object;
		
		
		/**
		 * Creates a new ChainableCommand.
		 * 
		 * @param next
		 * 	The next command in the chain.
		 */
		public function ChainableCommand(next:Object = null)
		{
			this.next = next;
		}
		
		
		

		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function set next(value:Object):void
		{
			if (!value || (value is IChainable || value is ICommand || value is IAsyncCommand))
				this._next = value;
			else
				throw new ArgumentError("Invalid command. Command must be either IChainable, ICommand, or IAsyncCommand");
		}
		
		
		
		
		//
		// public methods
		//
		

		/**
		 * @inheritDoc
		 */
		public function execute(params:Object):Boolean
		{
			return true;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function start(params:Object):void
		{
			var doNext:Boolean = this.execute(params);
			if (doNext && this._next)
			{
				if (this._next is IChainable)
					this._next.start(params);
				else
					this._next.execute(params);
			}
		}

		


	}
	
}