package inky.routing
{
	import flash.events.IEventDispatcher;
	import inky.routing.events.RouterEvent;
	import flash.events.Event;
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


private var _count:int = 0;

		/**
		 *	@inheritDoc
		 */
		public function handleRequest(unformattedRequest:Object):void
		{
this._count++;
var count:int = this._count;
			// Format the request object.
			var match:Object = this.router.route(unformattedRequest);
			if (match)
			{
				var route:IRoute = match.route;
				var request:Object = match.request;
				this._callback(request);
			}
			else
			{
				this._callback(unformattedRequest);
			}

if (count == this._count)
{
	this._count = 0;
	/*trace("last!>>>>>>>>>>>>>>>>>>>>>>");
	import inky.utils.*;
	trace(describeObject(unformattedRequest));*/
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