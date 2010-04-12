package inky.async
{
	
	/**
	 *
	 *  ..
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
		 *
		 */
		function addResponder(responder:Function, filter:Object = null):void;


		/**
		 *	
		 */
		function cancel():void;


		/**
		 *	
		 */
		function get cancelable():Boolean;


		/**
		 *	
		 */
		function get complete():Boolean;

		
	}
}
