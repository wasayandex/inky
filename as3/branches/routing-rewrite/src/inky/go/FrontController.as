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
		private var _dispatchers:Array
		private var _router:Router;


		/**
		 *
		 */
		public function FrontController(dispatchers:Object, router:Router)
		{
			if (dispatchers is Array)
				this._dispatchers = dispatchers.concat();
			else if (dispatchers is IEventDispatcher)
				this._dispatchers = [dispatchers];
			else
				throw new ArgumentError();

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
								dispatcher.removeEventListener(trigger, this.handleRequest);
					this._router.removeEventListener(RouterEvent.ROUTE_ADDED, this._routeAddedHandler);
				}
				if (value)
				{
					for each (route in value.getRoutes())
						for each (dispatcher in this._dispatchers)
							for each (trigger in route.triggers)
								dispatcher.addEventListener(trigger, this.handleRequest, false, 0, true);
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
			for each (var trigger:String in event.route.triggers)
				for each (var dispatcher:IEventDispatcher in this._dispatchers)
					dispatcher.addEventListener(trigger, this.handleRequest, false, 0, true);
		}


		protected function handleRequest(event:Event):void
		{
			var match:Object = this.router.findMatch(event);
			if (match)
			{
trace("Found match!");
for (var p in match.params)
	trace("\t" + p + ":\t" + match.params[p]);
			}
else
	trace("no match");
		}




	}
}