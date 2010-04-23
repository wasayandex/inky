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
	import inky.binding.utils.IChangeWatcher;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import inky.utils.describeObject;
	
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
		protected var contentContainer:DisplayObjectContainer;
		protected var overlayContainer:DisplayObjectContainer;
		protected var overlayLoader:OverlayLoader;
		protected var placemarkContainer:DisplayObjectContainer;
		protected var placemarkPlotter:PlacemarkPlotter;
		protected var layoutValidator:LayoutValidator;
		private var modelWatcher:IChangeWatcher;
		private var _model:IMapModel;
		private var _placemarkRendererClass:Class;
		
		/**
		 * Creates a BaseMap. 
		 */
		public function BaseMap()
		{

			// Find the content container. If it can't be found, create one.
			var contentContainer = this.getChildByName("_contentContainer") as DisplayObjectContainer;
			if (!contentContainer)
			{
				contentContainer = new Sprite();
				contentContainer.name == "_contentContainer";
				this.addChild(contentContainer);
			}
			this.contentContainer = contentContainer;
			
			// Find the overlay container. If it can't be found, create one.
			var overlayContainer:DisplayObjectContainer = this.contentContainer.getChildByName("_overlayContainer") as DisplayObjectContainer;
			if (!overlayContainer)
			{
				overlayContainer = new Sprite();
				overlayContainer.name = "_overlayContainer";
				this.contentContainer.addChild(overlayContainer);
				for (var i:int = 0; i < this.contentContainer.numChildren; i++)
				{
					var child:DisplayObject = this.contentContainer.getChildAt(i);
					if (!child.name.match(/^_(placemark|overlay)Container$/))
					{
						overlayContainer.addChild(child);
						i--;
					}
				}
			}
			this.overlayContainer = overlayContainer;

			// Find the placemark container. If it can't be found, create one.
			var placemarkContainer:DisplayObjectContainer = this.contentContainer.getChildByName("_placemarkContainer") as DisplayObjectContainer;
			if (!placemarkContainer)
			{
				placemarkContainer = new Sprite();
				this.contentContainer.addChild(placemarkContainer);
			}
			this.placemarkContainer = placemarkContainer;

			this.layoutValidator = new LayoutValidator(this, this.validate);
			
			this.overlayLoader = new OverlayLoader(this, this.layoutValidator, this.overlayContainer);
			// TODO: Should we store exposed PlacemarkPlotter values (recyclePlacemarkRenderers, cachePlacemarkPositions) to account for a situation where a subclass sets them before calling super()?
			this.placemarkPlotter = new PlacemarkPlotter(this, this.layoutValidator, this.contentContainer, this.placemarkContainer, this.overlayContainer);

			this.changeWatchers = [];
			this.modelWatcher = BindingUtil.bindSetter(this.initializeForModel, this, "model");
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
		
		/**
		 * @copy inky.components.map.view.helpers.PlacemarkPlotter#scalePlacemarks
		 */
		public function get scalePlacemarks():Boolean
		{ 
			return this.placemarkPlotter.scalePlacemarks; 
		}
		/**
		 * @private
		 */
		public function set scalePlacemarks(value:Boolean):void
		{
			this.placemarkPlotter.scalePlacemarks = value;
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
			
			this.modelWatcher.unwatch();
			
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
		
		/**
		 * @inheritDoc
		 */
		protected function validate():void
		{
			this.overlayLoader.validate();
			this.placemarkPlotter.validate();
			this.layoutValidator.validationState.markAllPropertiesAsValid();
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 *
		 */
		private function initializeForModel(model:Object):void
		{
			while (this.changeWatchers.length)
				this.changeWatchers.pop().unwatch();
			
			if (model)
			{
				this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedPlacemarks, model, "selectedPlacemarks"));
				this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedFolders, model, "selectedFolders"));
			}
		}
		
	}
	
}