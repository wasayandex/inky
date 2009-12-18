package inky.routing.router 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
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
	public interface IRouter extends IEventDispatcher
	{
		
		
		/**
		 *	
		 */
		function addRoute(route:IRoute):void;


		/**
		 *	
		 */
		function route(event:Event):Object;


		/**
		 *	
		 */
		function getRoutes():Array;
		
	}
	
}