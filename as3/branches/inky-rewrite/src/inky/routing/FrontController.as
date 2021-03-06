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
		public function get router():IRouter { return this._router; }
		/** @private */
		public function set router(value:IRouter):void { this._router = value; }




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			if (!this.router)
				throw new Error("You must set a router before initializing the front controller.");

			for each (var route:IRoute in this.router.getRoutes())
				this.initializeRoute(route);
		}


		/**
		 *	@inheritDoc
		 */
		public function handleRequest(request:Object):void
		{
			var match:Object = this.router.route(request);
			if (match)
			{
				var event:RoutingEvent = new RoutingEvent(RoutingEvent.REQUEST_ROUTED, match.route, match.request);
				if (this.dispatchEvent(event))
					this._callback(match.request);
			}
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