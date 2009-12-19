package inky.routing.router 
{
	import inky.routing.router.Route;
	import inky.routing.events.RouterEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import inky.routing.router.IRoute;
	import inky.routing.router.IRouter;
	import inky.routing.request.IRequest;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.24
	 *
	 */
	public class Router extends EventDispatcher implements IRouter
	{
		private var _routes:Array;
		
		/**
		 *
		 */
		public function Router()
		{
			this._routes = [];
		}



		//
		// accessors
		//


		/**
		 *	
		 */
		public function addRoute(route:IRoute):void
		{
			this._routes.push(route);
			this.dispatchEvent(new RouterEvent(RouterEvent.ROUTE_ADDED, route));
		}


		/**
		 *	
		 */
		public function route(event:Event):Object
		{
			if (!this._routes.length)
				throw new Error("Could not route event " + event + ". No routes have been added.");
			
			var request:IRequest;
			for each (var route:IRoute in this._routes)
			{
				if ((request = route.formatRequest(event)))
				{
// FIXME: I don't like returning this object. Is there any way we could just return the request? (The sticking point in that AddressFC needs the route to generate the URL)
					return {route: route, request: request};
				}
			}
			return null;
		}


		/**
		 *	
		 */
		public function getRoutes():Array
		{
			return this._routes.concat();
		}


	}
	
}