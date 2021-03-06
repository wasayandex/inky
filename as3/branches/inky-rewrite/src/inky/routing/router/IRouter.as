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
		function addRoutes(routes:Array):void;


		/**
		 *	
		 */
		function route(request:Object):Object;


		/**
		 *	
		 */
		function getRoutes():Array;
		
	}
	
}