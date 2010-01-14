package inky.commands.tokens
{
	
	/**
	 *
	 *  An object that represents the life cycle of an asynchronous process.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.10
	 *
	 */
	public interface IAsyncToken
	{
		
		/**
		 * Add a callback (responder) that is executed when the token's process is complete.
		 * 
		 * @param responder
		 * 	The callback method to be executed.
		 * 
		 * @param filter
		 * 	???
		 * 
		 * @see #callResponders
		 */
		function addResponder(responder:Function, filter:Object = null):void;
		
		
		/**
		 * Calls registered responder methods.
		 * 
		 * @see #addResponder
		 */
		function callResponders():void;


		/**
		 * Cancels the process, if it is cancelable.
		 */
		function cancel():void;


		/**
		 * Whether or not the process is cancelable.
		 */
		function get cancelable():Boolean;


		/**
		 * Whether or not the process is complete.
		 */
		function get complete():Boolean;

		
	}
}
