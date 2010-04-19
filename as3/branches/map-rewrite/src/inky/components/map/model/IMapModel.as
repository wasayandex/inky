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
		 * Gets an object that represents the kml document root.
		 */
		function get document():Object;
		
		/**
		 * Gets an object that represents the latitude and longitude boundaries of the map.
		 */
		function get latLonBox():Object;
		
		/**
		 * Gets an object that represent a graphic overlay.
		 */
		function get overlay():Object;
		
		/**
		 * Gets a list of currently selected folders.
		 * 
		 * <p>This list can be empty if no folders have been selected, or if there 
		 * are no folders in the document. When this value changes, the 
		 * <code>selectedPlacemark</code> value may change, depending on whether 
		 * or not any of the <code>selectedPlacemarks</code> are contained in a folder 
		 * that is marked as selected.</p>
		 * 
		 * @see #selectFolder
		 * @see #deselectFolder
		 * @see #folderIsSelected
		 */
		function get selectedFolders():Array;
		
		/**
		 * Gets and list of currently selected placemarks.
		 * 
		 * <p>This list can be empty if no placemarks have been selected, 
		 * or if there are no placemarks in the document. This value is updated if the 
		 * <code>selectedFolders</code> value changes to not include the folder that 
		 * contains any of the selected placemarks.</p>
		 * 
		 * @see #selectPlacemark
		 * @see #deselectPlacemark
		 * @see #placemarkIsSelected
		 */
		function get selectedPlacemarks():Array;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Deselects the specified folder.
		 * 
		 * <p>If this folder contains one or more other folders, those folders will 
		 * be deselected as well. A view might respond to this action by removing 
		 * all placemark views that correspond to placemarks contained in the 
		 * deselected folder.</p>
		 * 
		 * @param folder
		 * 		The folder to deselect.
		 * 
		 * @see #selectedFolders
		 * @see #folderIsSelected
		 * @see #selectFolder
		 */
		function deselectFolder(folder:Object):void;
		
		
		/**
		 * Deselects the specified placemark.
		 * 
		 * <p>A view might respond to this action by removing all placemark views 
		 * that correspond to the deselected placemark.</p>
		 * 
		 * @param placemark
		 * 		The placemark to deselect.
		 * 
		 * @see #selectedPlacemarks
		 * @see #placemarkIsSelected
		 * @see #selectPlacemark
		 */
		function deselectPlacemark(placemark:Object):void;
		
		/**
		 * Determines whether or not a folder is selected.
		 * 
		 * @param folder
		 * 		The folder to evaluate.
		 * 
		 * @return Whether or not the evaluated folder is selected.
		 * 
		 * @see #selectedFolders
		 * @see #deselectFolder
		 * @see #selectFolder
		 */
		function folderIsSelected(folder:Object):Boolean;
		
		/**
		 * Determines whether or not a placemark is selected.
		 * 
		 * @param placemark
		 * 		The placemark to evaluate.
		 * 
		 * @return Whether or not the evaluated placemark is selected.
		 * 
		 * @see #selectedPlacemarks
		 * @see #deselectPlacemark
		 * @see #selectPlacemark
		 */
		function placemarkIsSelected(placemark:Object):Boolean;
		
		/**
		 * Returns a list of folders in a container.
		 * 
		 * <p>If the container is not specified, the document root is assumed.</p>
		 * 
		 * @param container
		 * 		An optional container to search for folders in.  If no container 
		 * 		is specified, the document root is assumed.
		 * 
		 * @return A list of all folders found in the specified container. If no 
		 * 		container is specified, returns a list of all folders found in 
		 * 		the document root. If no folders are found, returns an empty array.
		 * 
		 * @see #getFolderByID
		 */
		function getFolders(container:Object = null):Array;
		
		/**
		 * Returns a list of placemarks in a container. 
		 * 
		 * <p>If the container is not specified, the document root is assumed.</p>
		 * 
		 * @param container
		 * 		An optional container to search for placemarks in.  If no container 
		 * 		is specified, the document root is assumed.
		 * 
		 * @return A list of all placemarks found in the specified container. If no 
		 * 		container is specified, returns a list of all placemarks found in 
		 * 		the document root. If no placemarks are found, returns an empty array.
		 * 
		 * @see #getPlacemarkByID
		 */
		function getPlacemarks(container:Object = null):Array;
		
		/**
		 * Selects the specified folder. 
		 * 
		 * <p>If this folder is nested in one or more other folders, those folders 
		 * will be selected as well. A view might respond to this action by 
		 * adding placemark views that correspond to the placemarks contained in 
		 * the selected folders.</p>
		 * 
		 * @param folder
		 * 		The folder to select.
		 * 
		 * @see #selectedFolders
		 * @see #folderIsSelected
		 * @see #deselectFolder
		 */
		function selectFolder(folder:Object):void;

		/**
		 * Selects the specified placemark. 
		 * 
		 * <p>If this placemark is nested in one or more other folders, those folders 
		 * will be selected as well. A view might respond to this action by 
		 * adding placemark views that correspond to the selected placemark.</p>
		 * 
		 * @param placemark
		 * 		The placemark to select.
		 * 
		 * @see #selectedPlacemarks
		 * @see #placemarkIsSelected
		 * @see #deselectPlacemark
		 */
		function selectPlacemark(placemark:Object):void;
		
	}
	
}