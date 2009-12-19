package inky.routing 
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import inky.routing.router.IRouter;
	

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
		 * Navigates to the root route.
		 */
		function initialize():void;


		/**
		 *
		 */
		function get router():IRouter;
		function set router(value:IRouter):void;


		/**
		 *	
		 */
		function routeEvent(event:Event):void;


		
	}
	
}