package inky.routing 
{
	import flash.events.Event;
	import inky.routing.IRoute;
	import inky.routing.IRouter;
	import flash.events.IEventDispatcher;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.core.ICommandMap;
	import inky.routing.IRouter;
	import inky.routing.Route;
	import flash.events.Event;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.routing.events.RouteMatchedEvent;


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
	public class RobotLegsRouter extends CommandMap implements ICommandMap, IRouter
	{
		private var currentURL:String;
		protected var _routes:Array;
		
		/**
		 *
		 */
		public function RobotLegsRouter(eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector)
		{
			super(eventDispatcher, injector, reflector);
			this._routes = [];
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function mapRoute(pattern:String, commandClass:Class, defaults:Object = null, requirements:Object = null):void
		{
			var route:Route = new Route(pattern, commandClass, defaults, requirements);
			this._routes.push(route);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.swfAddress_changeHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function swfAddress_changeHandler(event:SWFAddressEvent):void
		{
			this.routeURLToCommand("#" + event.value);
		}

		//---------------------------------------
		// Internal
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function routeURLToCommand(url:String):void
		{
			if (url == this.currentURL)
				return;
				
			this.currentURL = url;
trace("routing " + url);
			if (!this._routes.length)
				throw new Error("Could not route url \"" + url + "\". No routes have been added.");

			var params:Object;
			for each (var route:IRoute in this._routes)
			{
				if ((params = route.match(url)))
				{
					var commandClass:Class = route.commandClass;
					var event:RouteMatchedEvent = new RouteMatchedEvent(url, route, params);
					this.mapEvent(RouteMatchedEvent.ROUTE_MATCHED, commandClass, RouteMatchedEvent, true);
					this.eventDispatcher.dispatchEvent(event);
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function routeEventToCommand(event:Event, commandClass:Class, oneshot:Boolean, originalEventClass:Class):void
		{
			super.routeEventToCommand(event, commandClass, oneshot, originalEventClass);
		}

	}
	
}