package inky.components.map.views
{
	import flash.display.Sprite;
	import inky.components.map.models.KMLModel;
	import inky.components.map.models.DocumentModel;
	import inky.components.map.models.PlacemarkModel;
	import inky.binding.utils.BindingUtil;
	import inky.binding.events.PropertyChangeEvent;
	import inky.utils.EqualityUtil;
	
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
		private var _model:KMLModel;
		
		/**
		 *
		 */
		public function MapSprite()
		{
			BindingUtil.bindSetter(this._selectedDocumentChangeHandler, this, ["model", "selectedDocumentModel"]);
			BindingUtil.bindSetter(this._placemarkChangeHandler, this, ["model", "selectedPlacemarkModel"]);
		}

		//
		// accessors
		//
				
		/**
		*	Get/Set the model for the MapSprite. By default this must be a KMLModel object.
		*/
		public function get model():KMLModel
		{
			return this._model;
		}
		public function set model(value:KMLModel):void
		{
			var oldModel:KMLModel = this._model;
			if (!EqualityUtil.objectsAreEqual(oldModel, value))
			{
				this._model = value;			
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, 'model', oldModel, value));
			}
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
		
		private function _selectedDocumentChangeHandler(value:DocumentModel):void
		{			
			this.selectedDocumentChange();
		}
		
		private function _placemarkChangeHandler(value:PlacemarkModel):void
		{
			this.selectedPlacemarkChange();
		}		
	}
}