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
	import flash.utils.getQualifiedClassName;
	import inky.components.map.view.events.MapChangeEvent;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.HelperType;
	
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
		private var helpers:Array;
		protected var helperInfo:HelperInfo;
		protected var contentContainer:DisplayObjectContainer;
		protected var overlayContainer:DisplayObjectContainer;
		protected var placemarkContainer:DisplayObjectContainer;
		protected var layoutValidator:LayoutValidator;
		private var modelWatcher:IChangeWatcher;
		private var _model:IMapModel;
		private var _placemarkRendererClass:Class;
		private var _recyclePlacemarkRenderers:Boolean;
		private var _scalePlacemarkRenderers:Boolean;

		
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
			
			// Set up the helper info.
			this.helperInfo = new HelperInfo(this, this.layoutValidator, this.contentContainer, this.placemarkContainer, this.overlayContainer);
			
			// Register default helpers.
			this.registerHelper(OverlayLoader, HelperType.OVERLAY_HELPER);
			this.registerHelper(PlacemarkPlotter, HelperType.PLACEMARK_HELPER);

			this.modelWatcher = BindingUtil.bindSetter(this.initializeForModel, this, "model");
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
			var oldValue:Class = this._placemarkRendererClass;
			if (value != oldValue)
			{
				this._placemarkRendererClass = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "placemarkRendererClass", oldValue, value));	
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get recyclePlacemarkRenderers():Boolean
		{ 
			return this._recyclePlacemarkRenderers; 
		}
		/**
		 * @private
		 */
		public function set recyclePlacemarkRenderers(value:Boolean):void
		{
			var oldValue:Boolean = this._recyclePlacemarkRenderers;
			if (value != oldValue)
			{
				this._recyclePlacemarkRenderers = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "recyclePlacemarkRenderers", oldValue, value));	
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get scalePlacemarkRenderers():Boolean
		{ 
			return this._scalePlacemarkRenderers; 
		}
		/**
		 * @private
		 */
		public function set scalePlacemarkRenderers(value:Boolean):void
		{
			var oldValue:Boolean = this._scalePlacemarkRenderers;
			if (value != oldValue)
			{
				this._scalePlacemarkRenderers = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "scalePlacemarkRenderers", oldValue, value));	
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			this.modelWatcher.unwatch();
			this.dispatchEvent(new MapChangeEvent(MapChangeEvent.DESTROY_TRIGGERED));
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Returns a map helper.
		 * 
		 * @param id
		 * 		The id associated with the map helper.
		 * 
		 * @see inky.components.map.view.helpers.IMapHelper
		 * @see inky.components.map.view.helpers.HelperType
		 */
		protected function getHelper(id:String):Object
		{
			return this.helpers[id];
		}
		
		/**
		 * Registers a map helper class with the map.
		 * 
		 * @param helperClass 
		 * 		An IMapHelper class to register.
		 * 
		 * @param id
		 * 		An optional id to identify the role of the helper. If a helper already occupies 
		 * 		the given id, it is destroyed, and the new helper is created in its place.
		 * 
		 * @see inky.components.map.view.helpers.IMapHelper
		 * @see inky.components.map.view.helpers.HelperType
		 */
		protected function registerHelper(helperClass:Class, id:String = null):void
		{
			if (!this.helpers)
				this.helpers = [];
			
// TODO: schedule destroy in next update?
			if (id && this.helpers[id] && !(this.helpers[id] is Class))
				this.helpers[id].destroy();
			
			if (!id)
				this.helpers.push(helperClass);
			else
				this.helpers[id] = helperClass;
				
			this.invalidateProperty('helpers');
		}
		
		/**
		 * Resets the map (called when the map model changes, typically).
		 */
		protected function reset():void
		{
			this.dispatchEvent(new MapChangeEvent(MapChangeEvent.RESET_TRIGGERED));
		}

		/**
		 * Set the selected folders. This method may be overriden by subclasses 
		 * to alter the view behavior when folder selections change.
		 * 
		 * @param folders
		 * 		A list of selected folers.
		 */
		/*protected function setSelectedFolders(folders:Array):void
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
		}*/
		
		/**
		 * Set the selected placemarks. This method may be overriden by subclasses 
		 * to alter the view behavior when placemark selections change.
		 * 
		 * @param placemarks
		 * 		A list of selected placemarks.
		 */
		/*protected function setSelectedPlacemarks(placemarks:Array):void
		{
			
		}*/
		
		/**
		 * @inheritDoc
		 */
		protected function invalidateProperty(property:String):void
		{
			this.layoutValidator.validationState.markPropertyAsInvalid(property);
			this.layoutValidator.invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		protected function validate():void
		{
			if (this.layoutValidator.validationState.propertyIsInvalid('helpers'))
			{
				for (var key:Object in this.helpers)
				{
					var helper:Object = this.helpers[key];
					if (helper is Class)
					{
						helper = new helper();
						helper.initialize(this.helperInfo);
						this.helpers[key] = helper;
					}
				}
			}

			this.dispatchEvent(new MapChangeEvent(MapChangeEvent.VALIDATION_TRIGGERED));
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
			if (model)
				this.reset();
		}
		
	}
	
}