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
	import inky.binding.utils.IChangeWatcher;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import inky.components.map.view.events.MapChangeEvent;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.HelperType;
	import inky.components.map.view.Settings;
	import inky.components.map.view.helpers.IMapHelper;
	import inky.utils.getClass;
	import inky.components.map.view.helpers.SelectPlacemarkHelper;

	
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
		private var helperCount:int = 0;
		private var helpers:Object;
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
		private var _settings:Settings;

		
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
			this.registerHelper(
				PlacemarkPlotter,
				HelperType.PLACEMARK_HELPER,
				{
					avoidPlacemarkCollisions: "avoidPlacemarkCollisions",
					placemarkSnapX: "placemarkSnapX",
					placemarkSnapY: "placemarkSnapY",
					recyclePlacemarkRenderers: "recyclePlacemarkRenderers",
					scalePlacemarkRenderers: "scalePlacemarkRenderers"
				}
			);
			this.registerHelper(SelectPlacemarkHelper, HelperType.SELECT_PLACEMARK_HELPER);

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
		
		/**
		 * @inheritDoc
		 */
		public function get settings():Settings
		{
			return this._settings || (this._settings = new Settings());
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
		
		/**
		 * @inheritDoc
		 */
		public function getHelper(id:String):Object
		{
			return this.initializeHelper(id);
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerHelper(helperClassOrObject:Object, id:String = null, propertyMap:Object = null):void
		{
			if (!this.helpers)
				this.helpers = {};

// TODO: schedule destroy in next update?				
			var helper:Object = (id && this.helpers[id] && this.helpers[id].helper) as Object;
			if (helper)
				helper.destroy();
// TODO: Actually eliminate the potential collisions instead of just making them less likely.
			id = id || ("_____________" + String(this.helperCount++));
			
			this.helpers[id] = {
				helperClassOrObject: helperClassOrObject
			};
// TODO: How do these get unregistered.
			var property:String;
			for (property in propertyMap)
			{
				var targetProperty:String = propertyMap[property];
				this.defineProperty(property, targetProperty, id);
			}

			this.invalidateProperty("helpers");
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Resets the map (called when the map model changes, typically).
		 */
		protected function reset():void
		{
			this.dispatchEvent(new MapChangeEvent(MapChangeEvent.RESET_TRIGGERED));
		}

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
				for (var key:String in this.helpers)
				{
					this.initializeHelper(key);
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
		private function defineProperty(sourceProperty:String, targetProperty:String, helperId:String):void
		{
			var scope:Object = this;
			this.settings.defineProperty(
				sourceProperty,
				function():*
				{
					return scope.getHelper(helperId)[targetProperty];
				},
				function(value:*):void
				{
					scope.getHelper(helperId)[targetProperty] = value;
				}
			);
		}
		
		/**
		 * 
		 */
		private function initializeHelper(key:String):Object
		{
			var helperData:Object = this.helpers[key];

			if (!helperData.helper)
			{
				if (helperData.helperClassOrObject is IMapHelper)
				{
					helperData.helper = helperData.helperClassOrObject;
				}
				else if (helperData.helperClassOrObject is String || helperData.helperClassOrObject is Class)
				{
					var cls:Class = getClass(helperData.helperClassOrObject);
					helperData.helper = new cls();
				}
				helperData.helper.initialize(this.helperInfo);
			}
			return helperData.helper;
		}
		
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