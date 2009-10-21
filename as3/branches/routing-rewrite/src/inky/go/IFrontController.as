package inky.go 
{
	import flash.events.IEventDispatcher;
	import inky.go.Router;
	import flash.events.Event;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.21
	 *
	 */
	public interface IFrontController extends IEventDispatcher
	{
		
		/**
		 *
		 */
		function get router():Router;
		function set router(value:Router):void;


		/**
		 *	
		 */
		function routeRequest(request:Event):void;


		
	}
	
}