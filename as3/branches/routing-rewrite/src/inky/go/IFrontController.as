package inky.go 
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import inky.go.router.IRouter;
	

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
		function get router():IRouter;
		function set router(value:IRouter):void;


		/**
		 *	
		 */
		function routeEvent(event:Event):void;


		
	}
	
}