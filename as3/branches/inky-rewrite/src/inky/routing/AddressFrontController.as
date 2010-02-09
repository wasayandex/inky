package inky.routing 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import flash.events.Event;
	import inky.routing.router.AddressRoute;
	import inky.utils.CloningUtil;
	import inky.utils.EqualityUtil;
	import flash.events.EventDispatcher;
	import inky.routing.events.RoutingEvent;
	import inky.routing.router.Router;
	import inky.routing.router.IRoute;
	import inky.routing.router.IRouter;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.28
	 *
	 */
	public class AddressFrontController extends EventDispatcher implements IFrontController
	{
		private var _frontController:IFrontController;
		private var _lastAddress:String;


		/**
		 *
		 */
		public function AddressFrontController(frontController:IFrontController)
		{
			this._frontController = frontController;
			
			// Interrupt the normal flow to add browser address manipulation.
			frontController.addEventListener(RoutingEvent.REQUEST_ROUTED, this._requestRoutedHandler);

			// Relay all of the events from the decorated front controller.
			this._setupEventRelaying([RoutingEvent.REQUEST_ROUTED]);
		}




		//
		// private methods
		//


		/**
		 *	This is the guts of the AddressFrontController. It interrupts the normal flow
		 *  of the routing in order to change the address.
		 */
		private function _requestRoutedHandler(event:RoutingEvent):void
		{
			var request:Object = event.request;
			var triggerEvent:Event = event.triggerEvent;
			var route:IRoute = event.route;

			// Prevent responding to the same request twice. (Routed events will trigger address changes which will trigger this to fire again.)
			if (triggerEvent is SWFAddressEvent && triggerEvent.type == SWFAddressEvent.CHANGE && (this._lastAddress == SWFAddressEvent(triggerEvent).value))
			{
				event.preventDefault();
				return;
			}

			if (!(triggerEvent is SWFAddressEvent && triggerEvent.type == SWFAddressEvent.CHANGE) && route is AddressRoute)
			{
				// Update the address.
				var address:String = AddressRoute(route).generateAddress(request).replace(/.*#/, "");

				// Remember the address so we can prevent interpreting the same request twice.
				this._lastAddress = address;

				SWFAddress.setValue(address);
			}
		}




		//
		// event relaying
		//


		/**
		 *	
		 */
		private function _relayEvent(event:Event):void
		{
			this.dispatchEvent(event.clone() as Event);
		}


		/**
		 *	
		 */
		private function _setupEventRelaying(types:Array):void
		{
			for each (var type:String in types)
				this._frontController.addEventListener(type, this._relayEvent);
		}




		//
		// proxied to the decorated front controller
		//


		/**
		 * @inheritDoc
		 */
		public function initialize():void { SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.handleRequest); }


		/**
		 *	@inheritDoc
		 */
		public function get router():IRouter { return this._frontController.router; }
		/**
		 *	@private
		 */
		public function set router(value:IRouter):void { this._frontController.router = value; }


		/**
		 *	@inheritDoc
		 */
		public function handleRequest(request:Object):void { this._frontController.handleRequest(request); }




	}
}