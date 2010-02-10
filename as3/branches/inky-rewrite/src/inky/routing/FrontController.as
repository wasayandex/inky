package inky.routing
{
	import flash.events.IEventDispatcher;
	import inky.routing.events.RouterEvent;
	import flash.events.EventDispatcher;
	import inky.routing.events.RoutingEvent;
	import inky.routing.IFrontController;
	import inky.routing.router.IRoute;
	import inky.routing.router.IRouter;
	import inky.routing.router.IEventRoute;


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
	public class FrontController extends EventDispatcher implements IFrontController
	{
		protected var _callback:Function;
		private var _dispatchers:Array
		private var _router:IRouter;
		private static const MAX_ROUTE_RECURSION:uint = 100;


		/**
		 *
		 */
		public function FrontController(dispatchers:Object, router:IRouter, callback:Function)
		{
			if (dispatchers is Array)
				this._dispatchers = dispatchers.concat();
			else if (dispatchers is IEventDispatcher)
				this._dispatchers = [dispatchers];
			else
				throw new ArgumentError();
			
			this._callback = callback;
			this.router = router;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get router():IRouter
		{ 
			return this._router; 
		}
		/**
		 * @private
		 */
		public function set router(value:IRouter):void
		{
			if (value != this._router)
			{
				var trigger:String;
				var route:IRoute;
				var dispatcher:IEventDispatcher;
				if (this._router)
				{
throw new Error("You can't unset a router yet.");
				}
				if (value)
				{
					for each (route in value.getRoutes())
						this.initializeRoute(route);
					value.addEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler, false, 0, true);
				}

				this._router = value;
			}
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
throw new Error("Not yet implemented!");
		}


		/**
		 *	@inheritDoc
		 */
		public function handleRequest(request:Object):void
		{
			var recursionLevel:uint = 0;
			var match:Object;
			var routedRequest:Object = request;
			var routes:Array = [];
			while (match = this.router.route(routedRequest))
			{
				this.dispatchEvent(new RoutingEvent(RoutingEvent.REQUEST_ROUTED, match.route, match.request));

				// If a route matches--but doesn't reformat--the request, stop looking for matches. (It would just cause an infinite loop.)
				if (match.request == routedRequest)
					break;

				routedRequest = match.request;
				routes.push(match.route);
				if (recursionLevel > MAX_ROUTE_RECURSION)
					throw new Error("Too much recursion. The request " + request + " is being routed circuitously through the following routes:\n\t" + routes.join("\n\t"));
				recursionLevel++;
			}
			
			this._callback(routedRequest);
		}




		//
		// private methods
		//


		/**
		 *	Add listeners to the dispatchers whenever a route is added.
		 */
		private function _routeAddedHandler(event:RouterEvent):void
		{
			this.initializeRoute(event.route);
		}


		/**
		 * 
		 */
		protected function initializeRoute(route:IRoute):void
		{
			if (route is IEventRoute)
			{
				for each (var dispatcher:Object in this._dispatchers)
					for each (var trigger:String in IEventRoute(route).triggers)
						dispatcher.addEventListener(trigger, this.handleRequest);
			}
		}


	}
}