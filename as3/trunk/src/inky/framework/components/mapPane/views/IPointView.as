package inky.framework.components.mapPane.views 
{
	import inky.framework.components.mapPane.models.PointModel;
	import inky.framework.display.IDisplayObject;

	public interface IPointView extends IDisplayObject
	{
	
		function set model(model:PointModel):void;
		
		function get model():PointModel;
	}
}