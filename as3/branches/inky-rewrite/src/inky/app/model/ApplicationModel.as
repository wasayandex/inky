package inky.app.model
{
	import inky.app.inky;
	import inky.dynamic.DynamicObject;
	import inky.routing.router.AddressRoute;
	import inky.serialization.deserializers.IDeserializer;
	import inky.serialization.deserializers.ICollectionDeserializer;
	import inky.routing.router.Route;
	import inky.serialization.deserializers.xml.XMLListDeserializer;
	import inky.serialization.deserializers.xml.RouteDeserializer;
	import inky.app.SPath;
	import inky.app.model.IApplicationModel;


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
	dynamic public class ApplicationModel extends DynamicObject implements IApplicationModel
	{
		private var _data:Object;
		private var _deserializer:ICollectionDeserializer;
		private var _routes:Array;


		/**
		 *
		 */
		public function ApplicationModel(data:Object = null)
		{
			this._data = data;
//!
this._routes = [];
		}




		//
		// accessors
		//

// TODO: Get rid of ICollectionDeserializer, I think.
		/**
		 *
		 */
		public function get deserializer():ICollectionDeserializer
		{
			if (!this._deserializer)
				this.deserializer = this.createDeserializer(this._data);
			return this._deserializer; 
		}
		/**
		 * @private
		 */
		public function set deserializer(value:ICollectionDeserializer):void
		{
			this._deserializer = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get routes():Array
		{
			if (!this._routes)
			{
				var regularRoutes:Array = this.deserializer.deserializeType(Route);
				var addressRoutes:Array = this.deserializer.deserializeType(AddressRoute);
				this._routes = regularRoutes.concat.apply(null, addressRoutes);
			}

			return this._routes;
		}




		//
		// public methods
		//
		
		
		
		public function getSectionClassName(sPath:SPath):String
		{
// TODO: This parsing needs to be done by a deserializer.
			var segments:Array = sPath.toArray();
			var segment:String;
			var node:XML = XML(this._data);
			while (segments.length)
			{
				segment = segments.shift();
				node = node.inky::Section.(@name == segment)[0];

				if (!node)
// TODO: Throw more informative error.
					throw new Error(sPath.toString() + " cannot be found.");
			}

			node = node.attribute(new QName(inky, "class"))[0];
			if (!node)
// TODO: Throw more informative error.
				throw new Error("Class cannot be determined for " + sPath.toString());
			
			return node.toString();
		}




		//
		// protected methods
		//


		/**
		 * 
		 */
		protected function createDeserializer(data:Object):ICollectionDeserializer
		{
/*
			var xml:XML;
			if (data is String)
				xml = new XML(data as String);
			else if (data is XML)
				xml = data as XML;
			else
				throw new ArgumentError("Could not create deserializer.");

			var deserializer:ICollectionDeserializer = new XMLListDeserializer(xml + xml..*);
			var routeDeserializer:IDeserializer = new RouteDeserializer();
			deserializer.registerTypeDeserializer(Route, routeDeserializer);
			deserializer.registerTypeDeserializer(AddressRoute, routeDeserializer);
			return deserializer;
*/
return null;
		}

	}
	
}
