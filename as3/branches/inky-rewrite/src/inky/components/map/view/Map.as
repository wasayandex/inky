package inky.components.map.view 
{
	import flash.display.Sprite;
	import inky.collections.IMap;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.map.controller.MapController;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.helpers.PlacemarkPlotter;
	
	/**
	 *
	 *  A base implemention of IMap.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.07
	 *
 	 */
	public class Map extends Sprite implements IMap
	{
		private var controller:MapController;
		private var placemarkPlotter:PlacemarkPlotter;
		private var _model:IMapModel;
		private var _placemarkRendererClass:Class;
		
		/**
		 *
		 */
		public function Map()
		{
			this.placemarkPlotter = new PlacemarkPlotter(this);
			this.controller = new MapController(this);
		}
		
		//---------------------------------------
		// IMap Implementation
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get model():IMapModel
		{ 
			return this._model; 
		}
		/**
		 * @private
		 */
		public function set model(value:IMapModel):void
		{
			var oldValue:IMapModel = this._model;
			if (value != oldValue)
			{
				this._model = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "model", oldValue, value));	
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get placemarkRendererClass():Class
		{ 
			return this._placemarkRendererClass; 
		}
		/**
		 * @private
		 */
		public function set placemarkRendererClass(value:Class):void
		{
			this._placemarkRendererClass = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function addPlacemark(placemark:Object):void
		{
			this.placemarkPlotter.addPlacemark(placemark);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addPlacemarks(placemarks:Array):void
		{
			this.placemarkPlotter.addPlacemarks(placemarks);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllPlacemarks():void
		{
			this.placemarkPlotter.removeAllPlacemarks();
		}
		
		/**
		 * @inheritDoc
		 */
		public function removePlacemark(placemark:Object):void
		{
			this.placemarkPlotter.removePlacemark(placemark);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removePlacemarks(placemarks:Array):void
		{
			this.placemarkPlotter.removePlacemarks(placemarks);
		}

		
		
		
	}
	
}