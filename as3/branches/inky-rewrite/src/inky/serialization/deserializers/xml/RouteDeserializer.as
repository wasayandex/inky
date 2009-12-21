package inky.serialization.deserializers.xml 
{
	import inky.serialization.deserializers.xml.AbstractXMLDeserializer;
	import inky.app.inky;
	import inky.routing.router.AddressRoute;
	import inky.routing.router.Route;
	import inky.serialization.deserializers.xml.StandardDeserializer;
	import inky.routing.request.IRequestFormatter;
	import inky.routing.router.IRoute;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.19
	 *
	 */
	public class RouteDeserializer extends StandardDeserializer
	{
		
		/**
		 * @inheritDoc
		 */
		override public function deserializeXML(data:XML):Object
		{
			var name:QName = data.name();
			var route:IRoute;

			var eventType:String = this.getPropertyValue(data, "eventType", String);
			var defaults:Object = this.getPropertyValue(data, "defaults", Object);
			var requirements:Object = this.getPropertyValue(data, "requirements", Object);
			var requestFormatter:IRequestFormatter = this.getPropertyValue(data, "requestFormatter", IRequestFormatter);
			
			if (name.localName == "AddressRoute" || data.@address.length() > 0)
			{
				var address:String = this.getPropertyValue(data, "address", String);
				route = new AddressRoute(address, eventType, defaults, requirements, requestFormatter);
			}
			else
			{				
				route = new Route(eventType, defaults, requirements, requestFormatter);
			}
			


			
			
			this.setProperties(route, 
			
			return route;
		}




	}
	
}