package inky.routing
{
	import flash.events.IEventDispatcher;
	import inky.routing.events.RouterEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.routing.events.RoutingEvent;
	import inky.routing.IFrontController;
	import inky.routing.request.Request;
	import inky.routing.router.IRoute;
	import inky.routing.router.IRouter;
	import inky.routing.router.Router;
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
	public class FrontController extends EventDispatcher implements IFrontController
	{
		private var _callback:Function;
		private var _dispatchers:Array
		private var _router:IRouter;


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
// FIXME: what if dispatcher has changed?
					for each (route in this._router.getRoutes())
						for each (dispatcher in this._dispatchers)
							dispatcher.removeEventListener(route.trigger, this.routeEvent);
					this._router.removeEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler);
				}
				if (value)
				{
					for each (route in value.getRoutes())
						for each (dispatcher in this._dispatchers)
							dispatcher.addEventListener(route.trigger, this.routeEvent, false, 0, true);
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
		public function routeEvent(event:Event):void
		{
			// Map the event to a request object.
			var match:Object = this.router.route(event);
			if (match)
			{
				var route:IRoute = match.route;
				var request:IRequest = match.request;

				if (this.dispatchEvent(new RoutingEvent(RoutingEvent.REQUEST_ROUTED, event, route, request)))
					this._callback(request);
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
			for each (var dispatcher:IEventDispatcher in this._dispatchers)
				dispatcher.addEventListener(event.route.trigger, this.routeEvent, false, 0, true);
		}




	}
}