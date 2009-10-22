package inky.go.router 
{
	import inky.go.router.Route;
	import inky.go.events.RouterEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import inky.go.router.IRoute;
	import inky.go.router.IRouter;


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
		public function findMatch(event:Event):Object
		{
			var matches:Object;
			for each (var route:IRoute in this._routes)
			{
				if ((matches = route.match(event)))
				{
					return {route: route, params: matches};
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