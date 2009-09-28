package inky.go 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.go.FrontController;
	import flash.events.Event;
	import inky.go.AddressRoute;
	import inky.utils.CloningUtil;
	import inky.utils.EqualityUtil;
	
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
		private var _lastParams:Object;


		/**
		 *
		 */
		public function AddressFrontController(dispatchers:Object, router:Router)
		{
			super(dispatchers, router);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.handleRequest);
		}


		/**
		 *	@inheritDoc
		 */
		override protected function handleRequest(event:Event):void
		{
			var match:Object = this.router.findMatch(event);

			// Prevent responding to the same request twice. (Routed events will trigger address changes which will trigger this to fire again.)
			if (this._lastParams && event is SWFAddressEvent && event.type == SWFAddressEvent.CHANGE && EqualityUtil.propertiesAreEqual(this._lastParams, match.params))
			{
				this._lastParams = null;
				return;
			}
			else
			{
				this._lastParams = null;
			}

			if (match)
			{
				if (!(event is SWFAddressEvent && event.type == SWFAddressEvent.CHANGE) && match.route is AddressRoute)
				{
					// Remember the params so we can prevent interpreting the same request twice.
					this._lastParams = CloningUtil.clone(match.params);
					
					var address:String = AddressRoute(match.route).generateAddress(match.params);
					SWFAddress.setValue(address.replace(/.*#/, ""));
				}

trace("Found match!");
for (var p in match.params)
	trace("\t" + p + ":\t" + match.params[p]);					
			}
else
	trace("no match");
		}

		
	}
	
}