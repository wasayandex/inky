package inky.components.map.view
{
	import inky.utils.IDisplayObject;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.Settings;
	
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
		 * 
		 */
		function get settings():Settings;

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
		function registerHelper(helperClassOrObject:Object, id:String = null, propertyMap:Object = null):void
		
		
	}
}