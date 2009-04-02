package inky.framework.components.mapPane.parsers 
{
	import inky.framework.components.mapPane.models.MapModel;
	import inky.framework.components.mapPane.parsers.PointDataParser;
	
	public class MapDataParser 
	{
		
		public function parse(data:XML):MapModel
		{
			var model:MapModel = new MapModel();
			for each (var o:XML in data[0].*)
			{
				model.addPointModel(new PointDataParser().parse(new XML(o.toXMLString())));
			}
			
			return model;
		}
	}
}