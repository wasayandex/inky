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
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import inky.routing.RouteInfo;
	import inky.utils.CloningUtil;


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
		private var commandClassesToRoutes:Dictionary = new Dictionary();
		private var eventsToCommands:Object = {};
		private var numRoutes:int = 0;
		
		/**
		 *
		 */
		public function RobotLegsRouter(eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector)
		{
			super(eventDispatcher, injector, reflector);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function mapEvent(eventType:String, commandClass:Class, eventClass:Class = null, oneshot:Boolean = false):void
		{
			this.mapEventWithDefaultParams(eventType, commandClass, {}, eventClass, oneshot);
		}

		/**
		 * 
		 */
		public function mapEventWithDefaultParams(eventType:String, commandClass:Class, params:Object = null, eventClass:Class = null, oneshot:Boolean = false):void
		{
			eventClass = eventClass || Event;
			var hash:String = this.getHash(eventType, eventClass);
			this.eventsToCommands[hash] = {
				commandClass: commandClass,
				params: params
			};
			super.mapEvent(eventType, commandClass, eventClass, oneshot);
		}

		/**
		 * @inheritDoc
		 */
		public function mapRoute(pattern:String, commandClass:Class, defaults:Object = null, requirements:Object = null):void
		{
			var route:Route = new Route(pattern, commandClass, defaults, requirements);
			this.commandClassesToRoutes[commandClass] = route;
			this.numRoutes++;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.swfAddress_changeHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function getHash(eventType:String, eventClass:Class):String
		{
			return describeType(eventClass).@name + "$$$$$$$$$$$" + eventType;
		}

		/**
		 * 
		 */
		private function swfAddress_changeHandler(event:SWFAddressEvent):void
		{
// trace("value:\t" + event.value);
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
// trace("routing " + url);
			if (this.numRoutes == 0)
				throw new Error("Could not route url \"" + url + "\". No routes have been added.");

			var params:Object;
			for each (var route:IRoute in this.commandClassesToRoutes)
			{
				if ((params = route.match(url)))
				{
					var commandClass:Class = route.commandClass;
					var routeInfo:RouteInfo = new RouteInfo(route, params);
					this.injector.mapValue(RouteInfo, routeInfo);
					var command:Object = this.injector.instantiate(commandClass);
					this.injector.unmap(RouteInfo);
					command.execute();
					break;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function routeEventToCommand(event:Event, unused:Class, oneshot:Boolean, originalEventClass:Class):void
		{
			var eventClass:Class = Object(event).constructor;
			if (eventClass != originalEventClass)
				return;

			var hash:String = this.getHash(event.type, eventClass);
// trace(hash);
			var commandInfo:Object = this.eventsToCommands[hash];
			var route:IRoute;

			if (commandInfo && (route = this.commandClassesToRoutes[commandInfo.commandClass]))
			{
				var commandClass:Class = commandInfo.commandClass;
				var params:Object = CloningUtil.clone(commandInfo.params);
				var routeInfo:RouteInfo = new RouteInfo(route, params);

				// Set up the injection for, create, and execute, the command.
				this.injector.mapValue(RouteInfo, routeInfo);
				this.injector.mapValue(eventClass, event);
				var command:Object = this.injector.instantiate(commandClass);
				this.injector.unmap(RouteInfo);
				this.injector.unmap(eventClass);
				command.execute();
				if (oneshot)
					this.unmapEvent(event.type, commandClass, originalEventClass);

				var url:String = routeInfo.url;
// trace("generated: " + url);
				this.currentURL = url;
				SWFAddress.setValue(url.replace(/^#/, ""));
			}
			else
			{
				super.routeEventToCommand(event, unused, oneshot, originalEventClass);
			}
		}

	}
	
}