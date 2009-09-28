package inky.go 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.go.FrontController;
	import flash.events.Event;
	import inky.go.AddressRoute;
	
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
		
		/**
		 *
		 */
		public function AddressFrontController(dispatchers:Object, router:Router)
		{
			super(dispatchers, router);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.handleRequest);
		}
		
		override protected function handleRequest(event:Event):void
		{
			var match:Object = this.router.findMatch(event);

			if (match)
			{
				if (!(event is SWFAddressEvent && event.type == SWFAddressEvent.CHANGE) && match.route is AddressRoute)
				{
					var address:String = AddressRoute(match.route).generateAddress(match.params);
					SWFAddress.setValue(address.replace(/.*#/, ""));
				}

// FIXME: If you dispatch an event that causes a url change, the route will be matched twice.
trace("Found match!");
for (var p in match.params)
	trace("\t" + p + ":\t" + match.params[p]);					
			}
else
	trace("no match");
		}

		
	}
	
}