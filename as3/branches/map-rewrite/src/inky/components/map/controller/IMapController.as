package inky.components.map.controller 
{
	import inky.utils.IDestroyable;
	import inky.components.map.view.IMap;
	import inky.components.map.model.IMapModel;
	
	/**
	 *
	 *  MapController facilitates interaction between an IMap and IMapModel.
	 * 
	 * 	@see inky.components.map.model.IMapModel
	 *  @see inky.components.map.view.IMap
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public interface IMapController
	{
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Sets the map model that is moderated by this controller.
		 */
		function set model(value:IMapModel):void;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Deselects the specified folder.
		 * 
		 * @param folder
		 * 		The folder to deselect.
		 */
		function deselectFolder(folder:Object):void;
		
		/**
		 * Deselects the specified placemark.
		 * 
		 * @param placemark
		 * 		The placemark to deselect.
		 */
		function deselectPlacemark(placemark:Object):void;
		
		/**
		 * Selects the specified folder.
		 * 
		 * @param folder
		 * 		The folder to select.
		 */
		function selectFolder(folder:Object):void;
		
		/**
		 * Selects the specified placemark.
		 * 
		 * @param placemark
		 * 		The placemark to select.
		 */
		function selectPlacemark(placemark:Object):void;
		
	}
	
}