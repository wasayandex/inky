package inky.components.map.view
{
	import inky.utils.IDisplayObject;
	import inky.components.map.model.IMapModel;
	
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
	public interface IMap extends IDisplayObject
	{
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Map Model.
		 */
		function get model():IMapModel;
		function set model(value:IMapModel):void;
		
		/**
		 * The renderer class that is used to represent placemarks in the map.
		 */
		function get placemarkRendererClass():Class;
		function set placemarkRendererClass(value:Class):void;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		function addPlacemark(placemark:Object):void;
		
		function addPlacemarks(placemarks:Array):void;
		
		function removeAllPlacemarks():void;
		
		function removePlacemark(placemark:Object):void;
		
		function removePlacemarks(placemarks:Array):void;
	
	}
}