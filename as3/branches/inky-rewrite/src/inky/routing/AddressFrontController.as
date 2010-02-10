package inky.routing 
{
	import inky.routing.events.RoutingEvent;
	import inky.routing.router.IRouter;
	import inky.routing.FrontController;
	import inky.routing.router.IAddressRoute;
	import com.asual.swfaddress.SWFAddress;
	
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
	public class AddressFrontController extends FrontController
	{
		private var _addressRequest:Object;
		private var _addressRoute:IAddressRoute;
		private var _count:int = 0;
		

		public function AddressFrontController(dispatchers:Object, router:IRouter, callback:Function)
		{
			super(dispatchers, router, callback);
			this.addEventListener(RoutingEvent.REQUEST_ROUTED, this._requestRoutedHandler);
		}


		/**
		 *	@inheritDoc
		 */
		override public function handleRequest(request:Object):void
		{
			// Maintain a recursion count. This way we only set the address once per stack.
			this._count++;
			var count:int = this._count;

			super.handleRequest(request);

			// Set the address.
			if (count == this._count)
			{
				this._count = 0;
				if (this._addressRoute)
				{
					var address:String = this._addressRoute.generateAddress(this._addressRequest);
trace(">>>>>>>>>>" + address);
//					SWFAddress.setValue(address);
					this._addressRequest =
					this._addressRoute = null;
				}
			}
		}



		private function _requestRoutedHandler(event:RoutingEvent):void
		{
			if (event.route is IAddressRoute)
			{
				this._addressRoute = event.route as IAddressRoute;
				this._addressRequest = event.request;
			}
		}

	}
}