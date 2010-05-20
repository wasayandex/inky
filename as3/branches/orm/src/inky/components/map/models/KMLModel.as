package inky.components.map.models
{
	import flash.events.EventDispatcher;
	import inky.collections.ArrayList;
	import inky.components.map.models.DocumentModel;
	import inky.components.map.models.PlacemarkModel;
	import inky.components.map.events.MapEvent;
	import inky.binding.utils.BindingUtil;
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.map.events.MapEvent;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.19
	 *
	 */
	public class KMLModel extends EventDispatcher
	{
		private var _documents:ArrayList;
		private var _selectedDocument:DocumentModel;
		private var _selectedPlacemark:PlacemarkModel;
		
		/**
		 *
		 */
		public function KMLModel()
		{
			this._documents = new ArrayList();			

			BindingUtil.setPropertyBindingEvents(KMLModel, 'selectedPlacemarkModel', [MapEvent.SELECTED_PLACEMARK_CHANGE]);
			BindingUtil.setPropertyBindingEvents(KMLModel, 'selectedDocumentModel', [MapEvent.SELECTED_DOCUMENT_CHANGE]);
		}
		
		//
		// accessors
		//
		
		public function get documents():ArrayList
		{
			return this._documents;
		}
		
		public function get selectedDocumentModel():DocumentModel
		{
			return this._selectedDocument;
		}
		public function set selectedDocumentModel(value:DocumentModel):void
		{
			var oldValue:DocumentModel = this._selectedDocument;
			if (value != this._selectedDocument)
			{
				this._selectedDocument = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedDocumentModel", oldValue, value));
			}
		}

		public function get selectedPlacemarkModel():PlacemarkModel
		{
			return this._selectedPlacemark;
		}
		public function set selectedPlacemarkModel(value:PlacemarkModel):void
		{
			var oldValue:PlacemarkModel = this._selectedPlacemark;
			if (value != this._selectedPlacemark)
			{
				this._selectedPlacemark = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedDocumentModel", oldValue, value));
			}
		}

		//
		// public functions
		//
		
		public function selectDocumentByName(name:String):void
		{
			for (var i:int = 0; i < length; i++)
			{
				var document:DocumentModel = this._documents.getItemAt(i) as DocumentModel;
				if (name == document.name)
				{
					document.selected = true;			
					this.selectedDocumentModel = document;
					this._togglePropertyChangeListener(this._selectedDocument.placemarks.toArray(), CollectionEventKind.ADD);
		
					this.dispatchEvent(new MapEvent(MapEvent.SELECTED_DOCUMENT_CHANGE));
				}
				else
				{
					this._togglePropertyChangeListener(document.placemarks.toArray(), CollectionEventKind.REMOVE);
					document.selected = false;
				}
			}
		}
		
		
		//
		// private functions
		//
		
		private function _togglePropertyChangeListener(placemarks:Array, kind:String):void
		{
			var placemark:Object;
			switch (kind)
			{
				case CollectionEventKind.ADD:
				{
					for each (placemark in placemarks)
						placemark.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._itemPropertyChangeHandler);
					break;
				}
				case CollectionEventKind.REMOVE:
				{
					for each (placemark in placemarks)
						placemark.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._itemPropertyChangeHandler);
					break;
				}
			}
		}

		/**
		 *
		 */
		private function _itemPropertyChangeHandler(event:PropertyChangeEvent):void
		{
			if (event.newValue && (event.property == "selected"))
			{
				if (this._selectedPlacemark) this._selectedPlacemark.selected = false;
				this.selectedPlacemarkModel = event.currentTarget as PlacemarkModel;
				this._selectedPlacemark.selected = true;

				this.dispatchEvent(new MapEvent(MapEvent.SELECTED_PLACEMARK_CHANGE));
			}
		}
		
	}
}