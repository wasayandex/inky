package inky.components.map.model
{
	import flash.events.EventDispatcher;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.map.model.IMapModel;
	import com.google.maps.extras.xmlparsers.kml.Document;
	import com.google.maps.extras.xmlparsers.kml.Folder;
	import com.google.maps.extras.xmlparsers.kml.Container;
	import com.google.maps.extras.xmlparsers.kml.Placemark;
	import com.google.maps.extras.xmlparsers.kml.Overlay;
	import com.google.maps.extras.xmlparsers.kml.KmlGroundOverlay;
	
	/**
	 *
	 *  @inheritDoc
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.19
	 *
	 */
	public class MapModel extends EventDispatcher implements IMapModel
	{
		private var _document:Document;
		private var _latLonBox:Object;
		private var _selectedFolders:Array;
		private var _selectedPlacemarks:Array;
		
		/**
		 * Creates a new MapModel.
		 * 
		 * MapModel uses the KML parsing tools in the Google Maps API for Flash Utility Library. 
		 * The library can be found at: <code>http://code.google.com/p/gmaps-utility-library-flash/</code>.
		 * MapModel uses this libarary's KML parsers to populate the model from XML.
		 * 
		 * @see inky.components.map.model.deserializers.KMLDeserializer;
		 * 
		 * @param document
		 * 		The root document object. This is the document that the model represents.
		 */
		public function MapModel(document:Document)
		{
			if (document == null)
				throw new ArgumentError("MapModel must be instantiated with a valid KML Document.");

			this._document = document;
			
			this._selectedFolders = [];
			this._selectedPlacemarks = [];
			
			// Parse the latLonBox. We use the first one we find.
			var overlays:Array = this.getOverlaysInContainer(Container(document), true);
			for (var i:int = 0; i < overlays.length; i++)
			{
				var overlay:Overlay = Overlay(overlays[i]);
				if (overlay is KmlGroundOverlay)
				{
					this._latLonBox = KmlGroundOverlay(overlay).latLonBox;
					break;
				}
			}
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get document():Object
		{
			return this._document;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get latLonBox():Object
		{
			return this._latLonBox;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedFolders():Array
		{
			return this._selectedFolders.slice();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedPlacemarks():Array
		{ 
			return this._selectedPlacemarks.slice(); 
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function deselectFolder(folder:Object):void
		{
			if (!(folder is Folder))
				throw new ArgumentError("Invalid target.");

			var i:int = this._selectedFolders.indexOf(folder);
			if (i != -1)
			{
				var oldValue:Array = this.selectedFolders;
				this._selectedFolders.splice(i, 1);
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedFolders", oldValue, this.selectedFolders));	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function deselectPlacemark(placemark:Object):void
		{
			if (!(placemark is Placemark))
				throw new ArgumentError("Invalid target.");

			var i:int = this._selectedPlacemarks.indexOf(placemark);
			if (i != -1)
			{
				var oldValue:Array = this.selectedPlacemarks;
				this._selectedPlacemarks.splice(i, 1);
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedPlacemarks", oldValue, this.selectedPlacemarks));	
			}
		}

		/**
		 * @inheritDoc
		 */
		public function folderIsSelected(folder:Object):Boolean
		{
			return this._selectedFolders.indexOf(folder) != -1;
		}

		/**
		 * @inheritDoc
		 */
		public function placemarkIsSelected(placemark:Object):Boolean
		{
			return this._selectedPlacemarks.indexOf(placemark) != -1;
		}

		/**
		 * 
		 */
		public function getFolderByID(id:String):Object
		{
			return this.getFeatureByID(id, Folder);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getFolders(container:Object = null):Array
		{
			if (container == null)
				return this.getFoldersInContainer(Container(this.document), true);
			else
				return this.getFoldersInContainer(Container(container));
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPlacemarkByID(id:String):Object
		{
			return this.getFeatureByID(id, Placemark);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPlacemarks(container:Object = null):Array
		{
			if (container == null)
				return this.getPlacemarksInContainer(Container(this.document), true);
			else
				return this.getPlacemarksInContainer(Container(container));
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectFolder(folder:Object):void
		{
			if (!(folder is Folder))
				throw new ArgumentError("Invalid target.");

			if (this._selectedFolders.indexOf(folder) == -1)
			{
				var oldValue:Array = this.selectedFolders;
				this._selectedFolders.push(folder);
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedFolders", oldValue, this.selectedFolders));	
			}
		}

		/**
		 * @inheritDoc
		 */
		public function selectPlacemark(placemark:Object):void
		{
			if (!(placemark is Placemark))
				throw new ArgumentError("Invalid target.");

			if (this._selectedPlacemarks.indexOf(placemark) == -1)
			{
				var oldValue:Array = this.selectedPlacemarks;
				this._selectedPlacemarks.push(placemark);
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedPlacemarks", oldValue, this.selectedPlacemarks));	
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * Utility for finding a feature in the document that matches an id.
		 * NOTE: This assumes feature ids are unique.
		 */
		private function getFeatureByID(id:String, featureClass:Class):Object
		{
			var feature:Object;
			var features:Array = this.getFeaturesInContainer(featureClass, Container(this.document), true);
			for each (feature in features)
			{
				if (feature.id == id)
					return feature;
			}
			return null;
		}
		
		/**
		 * Utility for recursively retrieving all features of a specific type found in a container.
		 */
		private function getFeaturesInContainer(featureClass:Class, container:Container, recursive:Boolean):Array
		{
			var containerFeatures:Array = container.features;
			var features:Array = [];
			for each (var feature:Object in containerFeatures)
			{
				var addFeature:Boolean = feature is featureClass;

				if (!addFeature && feature is Container && recursive)
				{
					feature = this.getFeaturesInContainer(featureClass, Container(feature), recursive);
					addFeature = feature.length;
				}
				
				if (addFeature)
				{
					// Workaround for an Array.splice() bug. See comments from matthew@exanimo.com: http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/Array.html#comments
					var arr:Array = feature is Array ? feature as Array : [feature];
					arr.unshift(-1, 0);
					features.splice.apply(null, arr);
				}
			}
			return features;
		}
		
		/**
		 * 
		 */
		private function getFoldersInContainer(container:Container, recursive:Boolean = false):Array
		{
			return this.getFeaturesInContainer(Folder, container, recursive);
		}
		
		/**
		 * 
		 */
		private function getOverlaysInContainer(container:Container, recursive:Boolean = false):Array
		{
			return this.getFeaturesInContainer(Overlay, container, recursive);
		}

		/**
		 * 
		 */
		private function getPlacemarksInContainer(container:Container, recursive:Boolean = false):Array
		{
			return this.getFeaturesInContainer(Placemark, container, recursive);
		}
		

	}
}