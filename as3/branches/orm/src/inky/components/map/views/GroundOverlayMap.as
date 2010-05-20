package inky.components.map.views 
{
	import inky.components.map.models.DocumentModel;
	import inky.components.map.models.PlacemarkModel;
	import inky.components.map.views.IMapView;
	import inky.components.map.views.MapSprite;

	public class GroundOverlayMap extends MapSprite 
	{
		private var _mapView:IMapView;
	
		public function GroundOverlayMap()
		{
			this._init();
		}
				
		//
		// protected functions
		//
		
		
		override protected function selectedDocumentChange():void
		{
			if (!this._mapView) return;
			
			var documentModel:DocumentModel = this.model.selectedDocumentModel;
			if (documentModel)
			{
				this._mapView.latLonBox = documentModel.groundOverlay.latLonBox;
				this._mapView.model = documentModel.placemarks;				
			}
		}
		
		override protected function selectedPlacemarkChange():void
		{	
		if (!this.model || !this._mapView) return;
		
			var placemark:PlacemarkModel = this.model.selectedPlacemarkModel;
			if (placemark)
				this._mapView.showPointByModel(placemark);
		}
		
		//
		// private functions
		//
		
		
		private function _init():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:Object = this.getChildAt(i) as Object;
				if (child is IMapView)
				{
					this._mapView = child as IMapView;
					break;
				}
			}
		}
	}
}