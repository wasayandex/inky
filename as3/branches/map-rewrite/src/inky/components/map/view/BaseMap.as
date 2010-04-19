package inky.components.map.view 
{
	import flash.display.Sprite;
	import inky.collections.IMap;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.helpers.PlacemarkPlotter;
	import flash.display.DisplayObject;
	import inky.binding.utils.BindingUtil;
	import inky.components.map.view.helpers.OverlayLoader;
	import flash.geom.Point;
	
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
		private var overlayLoader:OverlayLoader;
		private var placemarkPlotter:PlacemarkPlotter;
		private var _model:IMapModel;
		private var _placemarkRendererClass:Class;
		
		/**
		 * Creates a BaseMap. 
		 */
		public function BaseMap()
		{
			this.overlayLoader = new OverlayLoader(this);
			// TODO: Should we store exposed PlacemarkPlotter values (recyclePlacemarkRenderers, cachePlacemarkPositions) to account for a situation where a subclass sets them before calling super()?
			this.placemarkPlotter = new PlacemarkPlotter(this);

			this.changeWatchers = [];
			this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedPlacemarks, this, ["model", "selectedPlacemarks"]));
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
		public function destroy():void
		{
			while (this.changeWatchers.length)
				this.changeWatchers.pop().unwatch();
			
			this.placemarkPlotter.destroy();
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
		
		/**
		 * @copy inky.components.map.view.helpers.PlacemarkPlotter#getPlacemarkRendererFor
		 */
		protected function getPlacemarkRendererFor(placemark:Object):Object
		{
			return this.placemarkPlotter.getPlacemarkRendererFor(placemark);
		}
		
		/**
		 * @copy inky.components.map.view.helpers.PlacemarkPlotter#getPositionFor
		 */
		protected function getPositionFor(placemark:Object):Point
		{
			return this.placemarkPlotter.getPositionFor(placemark);
		}
		
		/**
		 * Set the selected folders. This method may be overriden by subclasses 
		 * to alter the view behavior when folder selections change.
		 * 
		 * @param folders
		 * 		A list of selected folers.
		 */
		protected function setSelectedFolders(folders:Array):void
		{
			this.placemarkPlotter.removeAllPlacemarks();
			
			if (this.model)
			{
				for each (var folder:Object in this.model.selectedFolders)
					this.placemarkPlotter.addPlacemarks(this.model.getPlacemarks(folder));
				
				// Add the placemarks that sit outside of the folder structure.
				// Since they don't reside in folders that can never be selected, they are always present.
				this.placemarkPlotter.addPlacemarks(this.model.getPlacemarks(this.model.document));
			}
		}
		
		/**
		 * Set the selected placemarks. This method may be overriden by subclasses 
		 * to alter the view behavior when placemark selections change.
		 * 
		 * @param placemarks
		 * 		A list of selected placemarks.
		 */
		protected function setSelectedPlacemarks(placemarks:Array):void
		{
			
		}
		
	}
	
}