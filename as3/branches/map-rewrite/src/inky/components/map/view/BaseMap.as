package inky.components.map.view 
{
	import flash.display.Sprite;
	import inky.collections.IMap;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.map.controller.MapController;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.helpers.PlacemarkPlotter;
	import flash.display.DisplayObject;
	import inky.binding.utils.BindingUtil;
	import flash.events.MouseEvent;
	import inky.components.map.view.events.MapEvent;
	
	/**
	 *
	 *  A basic implementation of IMap. This implementation provides basic 
	 *  placemark plotting functionality.
	 * 
	 *  @see inky.components.map.view.IMap
	 * 	@see inky.components.map.view.Map
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.07
	 *
 	 */
	public class BaseMap extends Sprite implements IMap
	{
		private var changeWatchers:Array;
		private var placemarkPlotter:PlacemarkPlotter;
		private var _model:IMapModel;
		private var _placemarkRendererClass:Class;
		
		/**
		 * Creates a BaseMap. 
		 * This class can be instantiated directly, but generally should be extended intstead.
		 */
		public function BaseMap()
		{
			// TODO: Should we store exposed PlacemarkPlotter values (recyclePlacemarkRenderers, cachePlacemarkPositions) to account for a situation where a subclass sets them before calling super()?
			this.placemarkPlotter = new PlacemarkPlotter(this);

			this.changeWatchers = [];
			this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedFolders, this, ["model", "selectedFolders"]));
		}
		
		//---------------------------------------
		// IMap Implementation
		//---------------------------------------
		
		/**
		 * @copy inky.components.map.view.helpers.PlacemarkPlotter#cachePlacemarkPositions
		 */
		public function get cachePlacemarkPositions():Boolean
		{ 
			return this.placemarkPlotter.cachePlacemarkPositions; 
		}
		/**
		 * @private
		 */
		public function set cachePlacemarkPositions(value:Boolean):void
		{
			this.placemarkPlotter.cachePlacemarkPositions = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentRotation():Number
		{ 
			return this.getContentContainer().rotation; 
		}
		/**
		 * @private
		 */
		public function set contentRotation(value:Number):void
		{
			this.getContentContainer().rotation = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentX():Number
		{ 
			return this.getContentContainer().x; 
		}
		/**
		 * @private
		 */
		public function set contentX(value:Number):void
		{
			this.getContentContainer().x = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentY():Number
		{ 
			return this.getContentContainer().y; 
		}
		/**
		 * @private
		 */
		public function set contentY(value:Number):void
		{
			this.getContentContainer().y = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentScaleX():Number
		{ 
			return this.getContentContainer().scaleX; 
		}
		/**
		 * @private
		 */
		public function set contentScaleX(value:Number):void
		{
			this.getContentContainer().scaleX = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentScaleY():Number
		{ 
			return this.getContentContainer().scaleY; 
		}
		/**
		 * @private
		 */
		public function set contentScaleY(value:Number):void
		{
			this.getContentContainer().scaleY = value;
		}
		
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
		
		/**
		 * @copy inky.components.map.view.helpers.PlacemarkPlotter#recyclePlacemarkRenderers
		 */
		public function get recyclePlacemarkRenderers():Boolean
		{ 
			return this.placemarkPlotter.recyclePlacemarkRenderers; 
		}
		/**
		 * @private
		 */
		public function set recyclePlacemarkRenderers(value:Boolean):void
		{
			this.placemarkPlotter.recyclePlacemarkRenderers = value;
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
		public function destroy():void
		{
			while (this.changeWatchers.length)
				this.changeWatchers.pop().unwatch();
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
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Returns the content container.
		 */
		protected function getContentContainer():DisplayObject
		{
			return this.getChildByName("_contentContainer");
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function setSelectedFolders(folders:Array):void
		{
			this.removeAllPlacemarks();

			if (this.model)
			{
				for each (var folder:Object in this.model.selectedFolders)
					this.addPlacemarks(this.model.getPlacemarks(folder));
				
				// Add the placemarks that sit outside of the folder structure.
				// Since they don't reside in folders that can ever be selected, they are always present.
				this.addPlacemarks(this.model.getPlacemarks(this.model.document));
			}
		}
		
	}
	
}