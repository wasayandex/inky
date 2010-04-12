package inky.components.map.model
{
	import flash.events.EventDispatcher;
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.ArrayList;
	import inky.collections.IList;
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
		private var document:Document;
		private var _documents:IList;
		private var _folders:IList;
		private var _latLonBox:Object;
		private var _placemarks:IList;
		private var _selectedDocument:Object;
		private var _selectedFolder:Object;
		private var _selectedPlacemark:Object;
		
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
			this.document = document;
			
			// Parse the latLonBox. We use the first one we find.
			var overlays:Array = this.getOverlaysInContainer(Container(document));
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
		public function get documents():IList
		{
			return new ArrayList(this.getDocumentsInContainer(Container(this.document)));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get folders():IList
		{
			return new ArrayList(this.getFoldersInContainer(Container(this.document)));
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
		public function get placemarks():IList
		{
			return new ArrayList(this.getPlacemarksInContainer(Container(this.document)));
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedDocument():Object
		{ 
			return this._selectedDocument; 
		}
		/**
		 * @private
		 */
		public function set selectedDocument(value:Object):void
		{
			var oldValue:Object = this._selectedDocument;
			if (value != oldValue)
			{
				this._selectedDocument = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedDocument", oldValue, value));	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedFolder():Object
		{ 
			return this._selectedFolder; 
		}
		/**
		 * @private
		 */
		public function set selectedFolder(value:Object):void
		{
			var oldValue:Object = this._selectedFolder;
			if (value != oldValue)
			{
				this._selectedFolder = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedFolder", oldValue, value));	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedPlacemark():Object
		{ 
			return this._selectedPlacemark; 
		}
		/**
		 * @private
		 */
		public function set selectedPlacemark(value:Object):void
		{
			var oldValue:Object = this._selectedPlacemark;
			if (value != oldValue)
			{
				this._selectedPlacemark = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedPlacemark", oldValue, value));	
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function getFoldersForDocument(document:Object):IList
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPlacemarksForDocument(document:Object):IList
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPlacemarksForFolder(folder:Object):IList
		{
			return null;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function getDocumentsInContainer(container:Container):Array
		{
			return this.getFeaturesInContainer(Document, container);
		}
		
		/**
		 * 
		 */
		private function getFeaturesInContainer(featureClass:Class, container:Container):Array
		{
			var containerFeatures:Array = container.features;
			var features:Array = [];
			for each (var feature:Object in containerFeatures)
			{
				var addFeature:Boolean = feature is featureClass;

				if (!addFeature && feature is Container)
				{
					feature = this.getFeaturesInContainer(featureClass, Container(feature));
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
		private function getFoldersInContainer(container:Container):Array
		{
			return this.getFeaturesInContainer(Folder, container);
		}
		
		/**
		 * 
		 */
		private function getOverlaysInContainer(container:Container):Array
		{
			return this.getFeaturesInContainer(Overlay, container);
		}

		/**
		 * 
		 */
		private function getPlacemarksInContainer(container:Container):Array
		{
			return this.getFeaturesInContainer(Placemark, container);
		}
		

	}
}