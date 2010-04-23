package inky.components.map.view
{
	import inky.utils.IDisplayObject;
	import inky.components.map.model.IMapModel;
	
	/**
	 *	An interface that defines a map component view.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	
	 */
	public interface IMap extends IDisplayObject
	{
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * Map model.
		 */
		function get model():IMapModel;
		function set model(value:IMapModel):void;
		
		/**
		 * The renderer class that is used to represent placemarks in the map.
		 */
		function get placemarkRendererClass():Class;
		function set placemarkRendererClass(value:Class):void;
		
	}
}