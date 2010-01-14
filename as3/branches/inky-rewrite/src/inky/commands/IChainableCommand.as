package inky.commands 
{
	
	/**
	 *
	 *  An interface for use in a chain of responsibility.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.06
	 *
	 */
	public interface IChainableCommand
	{
		/**
		 * Set the next command in the chain of responsibility.
		 */
		function set next(value:Object):void;
		
		
		/**
		 * @copy inky.commands.ICommand#execute
		 * 
		 * @return Boolean
		 * 	Whether or not the chain should continue on to the next node.
		 */
		function execute(params:Object = null):Boolean;


		/**
		 * start the execution of the command.  This typically results in a call to the execute() method.
		 * @see inky.commands.ICommand#execute.
		 * 
		 * @param params
		 *	The object that defines conditions under which the command is executed.
		 */
		function start(params:Object = null):void;

	}
	
}