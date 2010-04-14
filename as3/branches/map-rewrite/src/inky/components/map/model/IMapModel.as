package inky.components.map.model 
{
	
	/**
	 *
	 *  A model representation of a KML Document.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.07
	 *
	 */
	public interface IMapModel
	{
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Returns an object that represents the kml document root.
		 */
		function get document():Object;
		
		/**
		 * Returns an object that represents the latitude and longitude boundaries of the map.
		 */
		function get latLonBox():Object;
		
		/**
		 * Returns a list of currently selected folders.
		 */
		function get selectedFolders():Array;
		
		/**
		 * Returns the currently selected placemark. 
		 * 
		 * This value can be null if no placemark has been selected, or if the 
		 * document contains no placemarks. This value is nulled if the 
		 * selectedFolders value changes to not include the folder that contains 
		 * the selected placemark.
		 */
		function get selectedPlacemark():Object;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Deselects the specified folder. If this folder contains 
		 * one or more other folders, those folders will be deselected 
		 * as well. A view might respond to this action by removing 
		 * all Placemarks contained in the deselected folders.
		 */
		function deselectFolder(folder:Object):void;
		
		/**
		 * Determines whether or not a folder is selected.
		 */
		function folderIsSelected(folder:Object):Boolean;
		
		/**
		 * Returns a list of folders in a container. If the container is not
		 * specified, the document root is assumed.
		 */
		function getFolders(container:Object = null):Array;
		
		/**
		 * Returns a list of placemarks in a container. If the container is not
		 * specified, the document root is assumed.
		 */
		function getPlacemarks(container:Object = null):Array;
		
		/**
		 * Selects the specified folder. If this folder is nested in 
		 * one or more other folders, those folders will be selected 
		 * as well. A view might respond to this action by rendering 
		 * all Placemarks contained in the selected folders.
		 */
		function selectFolder(folder:Object):void;
		
	}
	
}