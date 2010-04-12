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
		 * Gets and sets the rotation value for the map content container.
		 */
		function get contentRotation():Number;
		function set contentRotation(value:Number):void;
		
		/**
		 * Gets and sets the x value for the map content container.
		 */
		function get contentX():Number;
		function set contentX(value:Number):void;
		
		/**
		 * Gets and sets the y value for the map content container.
		 */
		function get contentY():Number;
		function set contentY(value:Number):void;
		
		/**
		 * Gets and sets the scaleX value for the map content container.
		 */
		function get contentScaleX():Number;
		function set contentScaleX(value:Number):void;
		
		/**
		 * Gets and sets the scaleY value for the map content container.
		 */
		function get contentScaleY():Number;
		function set contentScaleY(value:Number):void;

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
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Adds a placemark to the map content.
		 * 
		 * @param placemark
		 * 		The placemark to be added.
		 */
		function addPlacemark(placemark:Object):void;
		
		/**
		 * Adds multiple placemarks to the map content.
		 * 
		 * @param placemarks
		 * 		An array of the placemarks to be added.
		 */
		function addPlacemarks(placemarks:Array):void;
		
		/**
		 * Removes all placemarks from the map content.
		 */
		function removeAllPlacemarks():void;
		
		/**
		 * Removes a placemark from the map content.
		 * 
		 * @param placemark
		 * 		The placemark to be removed.
		 */
		function removePlacemark(placemark:Object):void;
		
		/**
		 * Removes multiple placemarks from the map content.
		 * 
		 * @param placemarks
		 * 		An array of the placemarks to be removed.
		 */
		function removePlacemarks(placemarks:Array):void;
	
	}
}