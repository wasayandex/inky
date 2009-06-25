package inky.framework.components.mapPane.views 
{
	import inky.framework.display.IDisplayObject;

	/**
	 *
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	
	 */
	public interface IPointView extends IDisplayObject
	{
	
		function set model(model:Object):void;
		
		function get model():Object;
	}
}