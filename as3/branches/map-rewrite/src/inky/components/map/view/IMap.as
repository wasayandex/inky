package inky.components.map.view
{
	import inky.utils.IDisplayObject;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.helpers.IMapHelper;
	
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
		
		/**
		 * Whether or not to recycle placemark renderer instances.
		 *  
		 * <p>If <code>false</code>, a new placemark renderer instance is created every 
		 * time a placemark is added. If <code>true</code>, placemark renderers created 
		 * for placemarks that are removed will be used for placemarks that are added.</p>
		 * 
		 * @default true
		 */
		function get recyclePlacemarkRenderers():Boolean;
		function set recyclePlacemarkRenderers(value:Boolean):void;
		
		/**
		 * Whether or not to scale the placemarks when the map is scaled (zoomed).
		 * 
		 * <p>If <code>false</code>, placemarks are repositioned when the map is scaled. The size 
		 * of the placemarks does not change, but their positions are adjusted relative to the 
		 * scale of the map. If <code>true</code>, the placemarks are not repositioned. The placemark 
		 * container is scaled along with the map, so that the placemarks keep the same positions 
		 * relative to the map. However, the size of the placemarks also scales.</p>
		 * 
		 * @default false
		 */
		function get scalePlacemarkRenderers():Boolean;
		function set scalePlacemarkRenderers(value:Boolean):void;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Returns a map helper.
		 * 
		 * @param id
		 * 		The id associated with the map helper.
		 * 
		 * @return The map helper associated with the id.
		 * 
		 * @see inky.components.map.view.helpers.IMapHelper
		 * @see inky.components.map.view.helpers.HelperType
		 */
		function getHelper(id:String):Object;
		
		/**
		 * Registers a map helper class with the map.
		 * 
		 * @param helperClass 
		 * 		An IMapHelper class to register.
		 * 
		 * @param id
		 * 		An optional id to identify the role of the helper. If a helper already occupies 
		 * 		the given id, it is destroyed, and the new helper is created in its place.
		 * 
		 * @see inky.components.map.view.helpers.IMapHelper
		 * @see inky.components.map.view.helpers.HelperType
		 */
		function registerHelper(helperClass:Class, id:String = null):void
		
		
	}
}