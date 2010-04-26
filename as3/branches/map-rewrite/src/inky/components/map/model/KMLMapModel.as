package inky.components.map.model
{
	import flash.events.EventDispatcher;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.map.model.IMapModel;
	import inky.kml.Document;
	import inky.kml.Container;
	import inky.kml.Folder;
	import inky.kml.Placemark;
	import inky.kml.Overlay;
	import inky.kml.GroundOverlay;
	
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
	public class KMLMapModel extends EventDispatcher implements IMapModel
	{
		private var _allowMultipleFolderSlections:Boolean;
		private var _allowMultiplePlacemarkSelections:Boolean;
		private var _document:Document;
		private var _overlay:GroundOverlay;
		private var _selectedFolders:Array;
		private var _selectedPlacemarks:Array;
		
		/**
		 * Creates a new KMLMapModel.
		 * 
		 * KMLMapModel uses the KML parsing tools in the <code>inky.kml</code> package.
		 * 
		 * @see inky.components.map.model.deserializers.KMLDeserializer;
		 * 
		 * @param document
		 * 		The root document object. This is the document that the model represents.
		 */
		public function KMLMapModel(document:Document)
		{
			if (document == null)
				throw new ArgumentError("KMLMapModel must be instantiated with a valid KML Document.");

			this._document = document;
			
			this._selectedFolders = [];
			this._selectedPlacemarks = [];
			
			this._allowMultipleFolderSlections = true;
			this._allowMultiplePlacemarkSelections = false;
			
			// Find the overlay. We use the first one we find.
			// TODO: Support multiple overlays?
			var overlays:Array = this.getOverlaysInContainer(Container(document), true);
			for (var i:int = 0; i < overlays.length; i++)
			{
				var overlay:Overlay = Overlay(overlays[i]);
				if (overlay is GroundOverlay)
				{
					this._overlay = GroundOverlay(overlay);
					break;
				}
			}
			
			// TODO: interpret folder 'visible' data as indicating whether or not to make the folders selected?
			for each (var folder:Object in this.getFolders())
				this.selectFolder(folder);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Gets and sets whether the model allows more than one folder to be 
		 * selected at a time.
		 * 
		 * <p>If <code>false</code>, new folder selections replace old selections.
		 * If <code>true</code>, new folder selections are added to old selections.</p>
		 */
		public function get allowMultipleFolderSlections():Boolean
		{ 
			return this._allowMultipleFolderSlections; 
		}
		/**
		 * @private
		 */
		public function set allowMultipleFolderSlections(value:Boolean):void
		{
			var oldValue:Boolean = this._allowMultipleFolderSlections;
			if (value != oldValue)
			{
				this._allowMultipleFolderSlections = value;
				if (!value && this._selectedFolders.length > 1)
				{
					var oldSelectedFoldersValue:Array = this.selectedFolders;
					while (this._selectedFolders.length > 1)
						this._selectedFolders.shift();
					
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedFolders", oldSelectedFoldersValue, this.selectedFolders));	
				}
			}
		}
		
		/**
		 * Gets and sets whether the model allows more than one placemark to be 
		 * selected at a time.
		 * 
		 * <p>If <code>false</code>, new placemark selections replace old selections.
		 * If <code>true</code>, new placemark selections are added to old selections.</p>
		 */
		public function get allowMultiplePlacemarkSelections():Boolean
		{ 
			return this._allowMultiplePlacemarkSelections; 
		}
		/**
		 * @private
		 */
		public function set allowMultiplePlacemarkSelections(value:Boolean):void
		{
			var oldValue:Boolean = this._allowMultiplePlacemarkSelections;
			if (value != oldValue)
			{
				this._allowMultiplePlacemarkSelections = value;
				if (!value && this._selectedPlacemarks.length > 1)
				{
					var oldSelectedPlacemarksValue:Array = this.selectedPlacemarks;
					while (this._selectedPlacemarks.length > 1)
						this._selectedPlacemarks.shift();
					
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedPlacemarks", oldSelectedPlacemarksValue, this.selectedPlacemarks));	
				}
			}
		}
		
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
			return this.overlay.latLonBox;
		}
		
		public function get overlay():Object
		{
			return this._overlay;
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
				
				// Update the selected placemarks.
				for each (var placemark:Object in this.selectedPlacemarks)
				{
					var deselectPlacemark:Boolean = true;
					for (var j:int = 0; deselectPlacemark && j < this._selectedFolders.length; j++)
					{
						if (this.getPlacemarksInContainer(this._selectedFolders[j]).indexOf(placemark) != -1)
							deselectPlacemark = false;
					}

					if (deselectPlacemark)
						this.deselectPlacemark(placemark);
				}

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
		 * @inheritDoc
		 */
		public function getFolderByID(id:String):Object
		{
			return this.getFeatureByID(Folder, id);
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
			return this.getFeatureByID(Placemark, id);
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

				if (!this.allowMultipleFolderSlections)
					this._selectedFolders = [];

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
				
				if (!this.allowMultiplePlacemarkSelections)
					this._selectedPlacemarks = [];

				this._selectedPlacemarks.push(placemark);
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedPlacemarks", oldValue, this.selectedPlacemarks));	

				// Update the selected folders.
				/*for each (var placemark:Object in this.selectedPlacemarks)
				{
					var deselectPlacemark:Boolean = true;
					for (var j:int = 0; deselectPlacemark && j < this._selectedFolders.length; j++)
					{
						if (this.getPlacemarksInContainer(this._selectedFolders[j]).indexOf(placemark) != -1)
							deselectPlacemark = false;
					}

					if (deselectPlacemark)
						this.deselectPlacemark(placemark);
				}*/
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * Utility for finding a feature in the document that matches an id.
		 * NOTE: This assumes feature ids are unique.
		 */
		private function getFeatureByID(featureClass:Class, id:String):Object
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
					arr.unshift(features.length, 0);
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