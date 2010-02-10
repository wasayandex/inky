package inky.routing.router 
{
	import flash.events.Event;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.22
	 *
	 */
	public interface IRoute
	{
		/**
		 *	Formats the request object. If the provided request doesn't match
		 *  the route, this function returns null. If the request is already
		 *  correctly formatted, the provided request is returned as is.
		 */
		function formatRequest(oldRequest:Object):Object;


		/**
		 *
		 */
		function get defaults():Object;


		/**
		 *
		 */
		function get requirements():Object;


		
	}
	
}