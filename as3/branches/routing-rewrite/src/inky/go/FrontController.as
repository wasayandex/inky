package inky.go
{
	import flash.events.IEventDispatcher;
	import inky.go.events.RouterEvent;
	import inky.go.Route;
	import flash.events.Event;


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
	public class FrontController
	{
		private var _dispatcher:IEventDispatcher;
		private var _router:Router;


		/**
		 *
		 */
		public function FrontController(dispatcher:IEventDispatcher, router:Router)
		{
			this._dispatcher = dispatcher;
			this.router = router;
		}


		/**
		 *
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
				var route:Route;
				if (this._router)
				{
// FIXME: what if triggers have been removed?
// FIXME: what if dispatcher has changed?
					for each (route in this._router.getRoutes())
						this._dispatcher.removeEventListener(route.trigger, this._handleRequest);
					this._router.removeEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler);
				}
				if (value)
				{
					for each (route in value.getRoutes())
					{
						this._dispatcher.addEventListener(route.trigger, this._handleRequest, false, 0, true);
					}
					value.addEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler, false, 0, true);
				}

				this._router = value;
			}
		}


		/**
		 *	
		 */
		private function _routeAddedHandler(event:RouterEvent):void
		{
			this._dispatcher.addEventListener(event.route.trigger, this._handleRequest, false, 0, true);
		}


		private function _handleRequest(event:Event):void
		{
			var match:Object = this.router.findMatch(event);
			if (match)
				this.handleRequest(match.params);
			else
				trace("no match");
		}



		protected function handleRequest(params:Object):void
		{
			trace("Found match!");
			for (var p in params)
				trace("\t" + p + ":\t" + params[p]);
		}



	}
}