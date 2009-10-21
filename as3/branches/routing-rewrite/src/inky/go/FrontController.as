package inky.go
{
	import flash.events.IEventDispatcher;
	import inky.go.events.RouterEvent;
	import inky.go.Route;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.go.IRequestHandler;
	import inky.go.events.RoutingEvent;
	import inky.go.IFrontController;


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
		private var _dispatchers:Array
		private var _router:Router;
		public var requestHandler:Object;


		/**
		 *
		 */
		public function FrontController(dispatchers:Object, router:Router, requestHandler:IRequestHandler)
		{
			if (dispatchers is Array)
				this._dispatchers = dispatchers.concat();
			else if (dispatchers is IEventDispatcher)
				this._dispatchers = [dispatchers];
			else
				throw new ArgumentError();
			
			this.requestHandler = requestHandler;
			this.router = router;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get router():Router
		{ 
			return this._router; 
		}
		/**
		 * @private
		 */
		public function set router(value:Router):void
		{
			if (value != this._router)
			{
				var trigger:String;
				var route:Route;
				var dispatcher:IEventDispatcher;
				if (this._router)
				{
// FIXME: what if triggers have been removed?
// FIXME: what if dispatcher has changed?
					for each (route in this._router.getRoutes())
						for each (dispatcher in this._dispatchers)
							for each (trigger in route.triggers)
								dispatcher.removeEventListener(trigger, this.routeRequest);
					this._router.removeEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler);
				}
				if (value)
				{
					for each (route in value.getRoutes())
						for each (dispatcher in this._dispatchers)
							for each (trigger in route.triggers)
								dispatcher.addEventListener(trigger, this.routeRequest, false, 0, true);
					value.addEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler, false, 0, true);
				}

				this._router = value;
			}
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		public function routeRequest(event:Event):void
		{
			// Map the event to a request object.
			var match:Object = this.router.findMatch(event);
			if (match)
			{
				var route:Route = match.route;
				var params:Object = match.params;

				if (this.dispatchEvent(new RoutingEvent(RoutingEvent.REQUEST_ROUTED, event, route, params)))
					this.requestHandler.handleRequest(params);
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
			for each (var trigger:String in event.route.triggers)
				for each (var dispatcher:IEventDispatcher in this._dispatchers)
					dispatcher.addEventListener(trigger, this.routeRequest, false, 0, true);
		}




	}
}