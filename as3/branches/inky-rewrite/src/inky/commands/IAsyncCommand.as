package inky.commands 
{
	import inky.commands.tokens.IAsyncToken;
	
	/**
	 *
	 *  An object that represents an asynchronous method or procedure that may be executed at a later time.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.05
	 *
	 */
	public interface IAsyncCommand
	{
		
		/**
		 * @copy inky.commands.ICommand#execute
		 * 
		 * @return
		 * 	An IAsyncToken which represents the life cycle of the executing command.
		 * 
		 * @see	inky.commands.tokens.IAsyncToken
		 * 
		 */
		function execute(params:Object = null):IAsyncToken;
		

		
	}
	
}