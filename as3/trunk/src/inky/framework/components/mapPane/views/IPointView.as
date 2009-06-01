package inky.framework.components.mapPane.views 
{
	import inky.framework.display.IDisplayObject;

	public interface IPointView extends IDisplayObject
	{
	
		function set model(model:Object):void;
		
		function get model():Object;
	}
}