package inky.components.map.model 
{
	import inky.collections.IList;
	
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
		 * The currently selected document.
		 * 
		 * This value can be null if no document has been selected, or if the
		 * model contains no documents. This value is nulled if the 
		 * selectedPlacemark value changes to a value that does not lie in
		 * a document. If the selectedPlacemark does lie in a document, this
		 * value is updated to reflect that document as being selected.
		 */
		function get selectedDocument():Object;
		function set selectedDocument(value:Object):void;
		
		/**
		 * The currently selected folder. 
		 * 
		 * This value can be null if no folder has been selected, or if the 
		 * document contains no folders. This value is nulled if the 
		 * selectedPlacemark value changes to a value that does not lie in 
		 * a Folder. If the selectedPlacemark does lie in a folder, this 
		 * value is updated to reflect that folder as being selected.
		 */
		function get selectedFolder():Object;
		function set selectedFolder(value:Object):void;		
		
		/**
		 * The currently selected placemark. 
		 * 
		 * This value can be null if no placemark has been selected, or if the 
		 * document contains no placemarks. This value is nulled if the 
		 * selectedFolder or selectedDocument values change.
		 */
		function get selectedPlacemark():Object;
		function set selectedPlacemark(value:Object):void;
		
		/**
		 * Returns a list of all documents.
		 * Documents can contain other Features, such as Placemarks and Folders.
		 */
		function get documents():IList;
		
		/**
		 * Returns a list of all folders.
		 * Folders can be used to organize other Features, such as Placemarks, hierarchically.
		 */
		function get folders():IList;
		
		/**
		 * Returns an object that represents the latitude and longitude boundaries of the map.
		 */
		function get latLonBox():Object;
		
		/**
		 * Returns a list of all placemarks. 
		 */
		function get placemarks():IList;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Returns a list of the folders contained in a document.
		 */
		function getFoldersForDocument(document:Object):IList;
		
		/**
		 * Returns a list of placemarks contained in a document.
		 */
		function getPlacemarksForDocument(document:Object):IList;
		
		/**
		 * Returns a list of placemarks contained in a folder.
		 */
		function getPlacemarksForFolder(folder:Object):IList;
		
		
	}
	
}