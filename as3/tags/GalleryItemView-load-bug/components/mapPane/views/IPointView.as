package inky.framework.components.mapPane.views 
{
	import inky.framework.components.mapPane.models.PointModel;

	public interface IPointView
	{
	
		function set model(model:PointModel):void;
		
		function get model():PointModel;
	}
}