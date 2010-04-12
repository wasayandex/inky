package inky.components.map.model.deserializers 
{
	import com.google.maps.extras.xmlparsers.kml.Kml22;
	import inky.components.map.model.MapModel;
	import com.google.maps.extras.xmlparsers.kml.Feature;
	import com.google.maps.extras.xmlparsers.kml.Document;
	import inky.components.map.model.IMapModel;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.02
	 *
	 */
	public class KMLDeserializer
	{

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function deserialize(data:Object):IMapModel
		{
			var xml:XML;
			if (data is XML)
				xml = data as XML;
			else if (data is String)
				xml = new XML(data);
			else
				throw new ArgumentError("Data type not recognized as XML.");

			var document:Document;
			var root:Feature = new Kml22(xml).feature;

			if (!root)
				throw new Error("No root feature found. KML is malformed.");

			if (root is Document)
				document = Document(root);
			else
				document = new Document(root.xml);

			var model:MapModel = new MapModel(document);
			return model;
		}
	}
	
}