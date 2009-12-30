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
			var xml:XML;

			var eventType:String = this.getPropertyValue(data, "eventType", String);
			var defaults:Object = this.getPropertyValue(data, "defaults", Object);
			var requirements:Object = this.getPropertyValue(data, "requirements", Object);
			var requestFormatter:IRequestFormatter = this.getPropertyValue(data, "requestFormatter", IRequestFormatter);
			var propertiesToAdd:XMLList = new XMLList();
			var excludeList:Array = ["eventType", "defaults", "requirements", "requestFormatter"];

			// Create the route.
			if (name.localName == "AddressRoute" || (data.address + data.@address).length() > 0)
			{
				var address:String = this.getPropertyValue(data, "address", String);
				route = new AddressRoute(address, eventType, defaults, requirements, requestFormatter);
				excludeList.push("address");
			}
			else
			{				
				route = new Route(eventType, defaults, requirements, requestFormatter);
			}

			// Create a list of properties to add to the route, excluding those we're already adding.
			for each (xml in data.attributes() + data.children())
			{
				if (excludeList.indexOf(xml.localName()) == -1)
					propertiesToAdd += xml;
			}

// TODO: Set other properties.
if (propertiesToAdd.length())
	throw new Error("This isn't done yet, so it can't add the property \"" + propertiesToAdd[0].localName() + "\" to your route.");

			
			
			return route;
		}


		/**
		 * 
		 */
		private function _xmlNamesToArray(list:XMLList):Array
		{
			var names:Array = [];
			for each (var xml:XML in list)
				names.push(xml.localName());
			return names;
		}


	}
	
}