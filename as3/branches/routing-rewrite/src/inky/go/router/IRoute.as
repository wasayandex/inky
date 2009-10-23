package inky.go.router 
{
	import inky.go.request.IRequest;
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
		 *	Converts the event into a request object. If the event does not match this route, null is returned.
		 */
		function formatRequest(event:Event):IRequest;


		/**
		 *
		 */
		function get defaults():Object;


		/**
		 *
		 */
		function get requirements():Object;


		/**
		 *	
		 */
		function get trigger():String;

		
	}
	
}