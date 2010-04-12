package inky.components.map.views 
{
	import inky.collections.IList;
	import inky.components.map.views.MapSprite;
	import flash.display.Sprite;
	import inky.components.listViews.IListView;
	import inky.components.map.models.KMLModel;
	import inky.components.map.models.DocumentModel;
	import inky.components.map.models.PlacemarkModel;
	import inky.components.map.views.IMapView;
	import inky.components.map.events.MapEvent;
	import inky.components.accordion.views.IAccordionItemView;
	import inky.utils.IDisplayObject;
	import inky.binding.utils.BindingUtil;
	import inky.binding.events.PropertyChangeEvent;
	import inky.utils.EqualityUtil;
	
	public class MapListing extends MapSprite 
	{
		private var _useCategories:Boolean;
		private var _listView:IListView;
		
		public function MapListing()
		{
			this._init();
		}
		
		//
		// protected functions
		//
		
		/**
		* 	@inheritDoc	
		*/
		override protected function selectedDocumentChange():void
		{
			if (!this._listView) return;
			
			var documentModel:DocumentModel = this.model.selectedDocumentModel;
			if (documentModel)
			{
				this._useCategories = documentModel.categories.length > 0;
				this._listView.model = this._useCategories ? documentModel.categories : documentModel.placemarks;
			}
		}
		
		/**
		* 	@inheritDoc	
		*/
		override protected function selectedPlacemarkChange():void
		{
			if (!this._listView || !this.model) return;

			var placemark:PlacemarkModel = this.model.selectedPlacemarkModel;
			if (placemark)
			{
				var id:int = this.model.selectedDocumentModel.placemarks.getItemIndex(placemark);
				if (this._useCategories)
					id = int(placemark.id);
				
				this._listView.showItemAt(id);
			}
		}
		
		//
		// private functions
		//
		
		
		/**
		* 	@private	
		*/
		private function _init():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:Object = this.getChildAt(i) as Object;
				if (child is IListView)
				{
					this._listView = child as IListView;
					break;
				}
			}
		}
		
	}
}