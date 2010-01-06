package inky.commands 
{
	
	/**
	 *
	 *  An object that represents a method or procedure that may be executed at a later time.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.05
	 *
	 */
	public interface ICommand
	{
		
		/**
		 * executes the command.
		 * 
		 * @param params
		 *	The object that defines conditions under which the command is executed.
		 * 
		 */
		function execute(params:Object):void;
		

		
	}
	
}
