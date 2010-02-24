package inky.components.map.parsers
{
	import inky.components.map.models.DocumentModel;
	import inky.components.map.models.KMLModel;
	import inky.components.map.models.CategoryModel;
	import inky.components.map.models.GroundOverlayModel;
	import inky.components.map.models.KMLModel;
	import inky.components.map.models.PlacemarkModel;
	import inky.collections.ArrayList;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.18
	 *
	 */
	public class MapDataParser
	{
		
		
		public function parse(xml:XML):KMLModel
		{
			var prop:Object;
			var kmlModel:KMLModel = new KMLModel();
			for each (var documentXML:XML in xml.Document)
			{
				var documentModel:DocumentModel = new DocumentModel();
				for each (prop in documentXML.attributes())
					documentModel[String(prop.localName())] = prop == "false" ? false : prop == "true" ? true : prop;
				
				for each (var groundOverlayXML:XML in documentXML.GroundOverlay)
				{
					var groundOverlayModel:GroundOverlayModel = new GroundOverlayModel();
					for each (prop in groundOverlayXML.attributes())
						groundOverlayModel[String(prop.localName())] = prop == "false" ? false : prop == "true" ? true : prop;
					
					var latLonBox:XML = groundOverlayXML.LatLonBox[0];
					if (latLonBox)
						groundOverlayModel.latLonBox = {east: latLonBox.east, west: latLonBox.west, north: latLonBox.north, south: latLonBox.south};
												
					documentModel.groundOverlay = groundOverlayModel;
				}
			
				var categoriesXML:XML = documentXML.categories[0];			
				for each (var categoryXML:XML in categoriesXML..category)
				{
					var categoryModel:CategoryModel = new CategoryModel();

					for each (prop in categoryXML.attributes() + categoryXML.children())
						categoryModel[String(prop.localName())] = prop == "false" ? false : prop == "true" ? true : prop;

					documentModel.categories.addItem(categoryModel);
				}	
	
				for each (var placemarksXML:XML in documentXML.Placemark)
				{
					var placemarkModel:PlacemarkModel = new PlacemarkModel();
					categoryModel = documentModel.categories.findFirst({id: placemarksXML.@id}) as CategoryModel;
					placemarkModel.color = categoryModel.color;

					for each (prop in placemarksXML.attributes() + placemarksXML.children())
					{
						var pointXML:XML = placemarksXML.Point[0];
						switch (prop)
						{
							case "false":
								placemarkModel[String(prop.localName())] = false;
								break;
							case "true":
								placemarkModel[String(prop.localName())] = true;
								break;
							case pointXML:
								var splits:Array = pointXML.coordinates.toString().split(",");
								placemarkModel.coordinates = {long: Number(splits[0]), lat: Number(splits[1])};
								break;
							default:
								placemarkModel[String(prop.localName())] = prop;
								break;
						}
					}
	
	// Not really sure if this is best. Need to find a better way to handle this.
	// Doing this because each CategoryModel needs a reference of what placemarks are associated with it.
	categoryModel.placemarks.addItem(placemarkModel);
					
					documentModel.placemarks.addItem(placemarkModel);
				}
				kmlModel.documents.addItem(documentModel);
			}
			
			return kmlModel;
		}


	}
}