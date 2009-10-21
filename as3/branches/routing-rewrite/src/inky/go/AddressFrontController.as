package inky.go 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import flash.events.Event;
	import inky.go.AddressRoute;
	import inky.utils.CloningUtil;
	import inky.utils.EqualityUtil;
	import flash.events.EventDispatcher;
	import inky.go.events.RoutingEvent;
	import inky.go.Router;
	
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
		private var _lastParams:Object;


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

			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.routeRequest);
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
			var request:Event = event.request;
			var route:Route = event.route;
			var params:Object = event.params;

			// Prevent responding to the same request twice. (Routed events will trigger address changes which will trigger this to fire again.)
			if (this._lastParams && request is SWFAddressEvent && request.type == SWFAddressEvent.CHANGE && EqualityUtil.propertiesAreEqual(this._lastParams, params))
			{
				this._lastParams = null;
				event.preventDefault();
				return;
			}
			else
			{
				this._lastParams = null;
			}

			if (!(request is SWFAddressEvent && request.type == SWFAddressEvent.CHANGE) && route is AddressRoute)
			{
				// Remember the params so we can prevent interpreting the same request twice.
				this._lastParams = CloningUtil.clone(params);

				// Update the address.
				var address:String = AddressRoute(route).generateAddress(params);
				SWFAddress.setValue(address.replace(/.*#/, ""));
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
		 *	@inheritDoc
		 */
		public function get router():Router { return this._frontController.router; }
		/**
		 *	@private
		 */
		public function set router(value:Router):void { this._frontController.router = value; }


		/**
		 *	@inheritDoc
		 */
		public function routeRequest(event:Event):void { this._frontController.routeRequest(event); }




	}
}