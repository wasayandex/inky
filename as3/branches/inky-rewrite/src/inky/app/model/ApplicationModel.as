package inky.app.model
{
	import inky.app.inky;
	import inky.dynamic.DynamicObject;
	import inky.routing.router.AddressRoute;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.28
	 *
	 */
	dynamic public class ApplicationModel extends DynamicObject
	{
		private var _data:XML;
		private var _routes:Array;


		/**
		 *
		 */
		public function ApplicationModel(data:Object = null)
		{
			if (data is XML)
				this._data = data as XML;
			else if (data is String)
				this._data = new XML(data as String);
			else
				throw new ArgumentError("ApplicationModel requires XML. If you want to use a different data format, create a custom ApplicationModel.");
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get routes():Array
		{
			if (!this._routes)
			{
// FIXME: Move this out of here so that if you override the getter, these will still be set.
				var routeElement:QName = new QName(inky.uri, "Route");
				var addressRouteElement:QName = new QName(inky.uri, "AddressRoute");
				if (!this.getElementParser(routeElement))
					this.registerElementParser(routeElement, new RouteParser());
				if (!this.getElementParser(addressRouteElement))
					this.registerElementParser(addressRouteElement, new AddressRouteParser());
					
				this._routes = [];
				this._routes.concat.apply(null, this.parseElements(routeElement));
				this._routes.concat.apply(null, this.parseElements(addressRouteElement));
			}
			
			return this._routes;
		}




		//
		// public methods
		//


		/**
		 * 
		 */
		public function getElementParser(element:QName):*
		{
			
		}


		/**
		 * 
		 */
		public function parseElements(type:QName):Array
		{
			var parser:* = this.getElementParser(type);
			var elements:Array = [];
			for each (var element:XML in this._data..*.(name().uri == type.uri && name().localName == type.localName))
			{
				if (!element.@inky::parsed == "true")
				{
					// Mark the element as parsed.
// TODO: Is there a better way to do this? Dictionaries aren't very effective with XML, so that's out. Anything else we can do without modifying the XML?
					element.@inky::parsed = "true";
					elements.push(parser.parse(element));
				}
			}
			return elements;
		}


		/**
		 * 
		 */
		public function registerElementParser(element:QName, parser:*):void
		{
			
		}





	}
	
}
