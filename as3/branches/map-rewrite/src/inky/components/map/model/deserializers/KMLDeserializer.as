package inky.components.map.model.deserializers 
{
	import inky.components.map.model.KMLMapModel;
	import inky.kml.KMLDocument;
	import inky.kml.Feature;
	import inky.kml.Document;
	
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
		public function deserialize(data:Object):KMLMapModel
		{
			var xml:XML;
			if (data is XML)
				xml = data as XML;
			else if (data is String)
				xml = new XML(data);
			else
				throw new ArgumentError("Data type not recognized as XML.");
			
			var model:KMLMapModel;

			var document:Document;
			var root:Feature = new KMLDocument(xml).rootFeature;
			
			if (!root)
				throw new Error("No root feature found. KML is malformed.");
			
			if (root is Document)
				document = Document(root);
			else
				document = new Document(root.xml);

			return new KMLMapModel(document);
		}
	}
	
}