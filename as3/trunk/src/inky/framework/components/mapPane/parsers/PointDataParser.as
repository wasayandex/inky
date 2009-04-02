package inky.framework.components.mapPane.parsers 
{
	import inky.framework.components.mapPane.models.PointModel;
	
	public class PointDataParser 
	{
		
		public function parse(data:XML):PointModel
		{
			var model:PointModel = new PointModel();
			model.id = data.@id;
			model.setLabel(data.@label);
			
			model.x = parseInt(data.@x);
			model.y = parseInt(data.@y);
			
			return model;
		}
	}
}