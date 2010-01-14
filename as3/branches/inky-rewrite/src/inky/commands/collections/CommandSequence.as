package inky.commands.collections 
{
	import inky.collections.ArrayList;
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.commands.collections.CommandQueue;
	import inky.collections.IIterator;
	
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
	public class CommandSequence extends ArrayList implements IAsyncCommand
	{
		/**
		 *
		 */
		public function CommandSequence(...rest:Array)
		{
			for each (var command:Object in rest)
				this.addItem(action);
		}
		
		
		

		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function execute(params:Object = null):IAsyncToken
		{
			var queue:CommandQueue = new CommandQueue();
			for (var i:IIterator = this.iterator(); i.hasNext(); )
				queue.addItem(i.next());

			return queue.execute();
		}

		


	}
	
}