package inky.components.map.views
{
	import flash.display.Sprite;
	import inky.components.listViews.IListView;
	import inky.components.map.models.KMLModel;
	import inky.components.map.models.DocumentModel;
	import inky.components.map.views.IMapView;
	import inky.components.map.events.MapEvent;
	import inky.components.accordion.views.IAccordionItemView;
	import inky.utils.IDisplayObject;
	
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
	public class MapSprite extends Sprite
	{
		private var _categoryMode:Boolean;
		private var _listView:IListView;
		private var _mapView:IMapView;
		private var _model:KMLModel;
		
		/**
		 *
		 */
		public function MapSprite()
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:Object = this.getChildAt(i) as Object;
				if (child is IMapView)
					this._mapView = child as IMapView;
								
				if (child is IListView)
					this._listView = child as IListView;
					
				if (this._listView && this._mapView)
					break;
			}
		}

		//
		// accessors
		//
		
		/**
		*	Sets the categoryMode for the MapSprite. By default this is set to true
		*/
		public function set categoryMode(value:Boolean):void
		{
			this._categoryMode = value;
		}
		
		/**
		*	Get/Set the model for the MapSprite. By default this must be a KMLModel object.
		*/
		public function get model():KMLModel
		{
			return this._model;
		}
		public function set model(value:KMLModel):void
		{
			this._model = value;			
			this.model.addEventListener(MapEvent.SELECTED_DOCUMENT_CHANGE, this._selectedDocumentChangeHandler);					
		}
		
		//
		// protected functions
		//		
		
		protected function selectedDocumentChange():void
		{
		}
		
		protected function selectedPlacemarkChange():void
		{
		}
		
		//
		// private functions
		//
		
		private function _selectedDocumentChangeHandler(event:MapEvent):void
		{
			var documentModel:DocumentModel = this.model.selectedDocument;
			if (this._listView)
			{
				documentModel.addEventListener(MapEvent.SELECTED_PLACEMARK_CHANGE, this._placemarkChangeHandler);						
				this._listView.model = documentModel.categories;
			}
			
			this.categoryMode = documentModel.categories.length > 0;
			this._mapView.model = documentModel.placemarks;
			this.selectedDocumentChange();
		}
		
		private function _placemarkChangeHandler(event:MapEvent):void
		{
			var id:int = int(event.id);
			var placemark:Object = this.model.selectedDocument.placemarks.getItemAt(id);

			if (this._categoryMode)
			{
				id = int(placemark.id);
				this._listView.showItemAt(id);
			}

			this._mapView.showPointByModel(placemark);
			this.selectedPlacemarkChange();
		}		
	}
}