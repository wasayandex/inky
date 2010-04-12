package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import inky.binding.utils.BindingUtil;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import inky.collections.IIterator;
	import inky.collections.events.CollectionEvent;
	import inky.collections.IList;
	import inky.collections.ArrayList;
	import inky.utils.IDestroyable;
	import inky.layout.validation.LayoutValidator;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.components.map.model.MapModel;
	import inky.binding.utils.IChangeWatcher;
	import inky.components.map.view.helpers.BaseMapViewHelper;
	
	/**
	 *
	 *  An IMap view helper that provides basic placmark plotting functionality.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.09
	 *
	 */
	public class PlacemarkPlotter extends BaseMapViewHelper implements IDestroyable
	{
		private var _cachePlacemarkPositions:Boolean;
		private var placemarkContainer:Sprite;
		private var layoutValidator:LayoutValidator;
		private var placemarks:ArrayList;
		private var placemarks2Renderers:Dictionary;
		private var positionCache:Dictionary;
		private var _recyclePlacemarkRenderers:Boolean;
		
		/**
		 * @copy inky.components.map.view.helpers.BaseMapViewHelper
		 * 
		 * @param recyclePlacemarkRenderers
		 * 		Whether or not to recycle placemark renderer instances.
		 * @see #recyclePlacemarkRenderers
		 * @see inky.components.map.view.IMap#placemarkRendererClass
		 * 
		 * @param cachePlacemarkPositions
		 * 		Whether or not to cache the placemark positions, or recalculate them every time a placemark is added.
		 * @see #cachePlacemarkPositions
		 */
		public function PlacemarkPlotter(map:IMap, recyclePlacemarkRenderers:Boolean = true, cachePlacemarkPositions:Boolean = true)
		{
			super(map);
			
			this.recyclePlacemarkRenderers = recyclePlacemarkRenderers;
			this.cachePlacemarkPositions = cachePlacemarkPositions;

			this.layoutValidator = new LayoutValidator(map as DisplayObject, this.validate);

			this.placemarks = new ArrayList();
			this.placemarks.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.placemarks_collectionChangeHandler);
			
			var placemarkContainer:Sprite = this.contentContainer.getChildByName("_placemarkContainer") as Sprite;
			if (!placemarkContainer)
			{
				placemarkContainer = new Sprite();
				this.contentContainer.addChild(placemarkContainer);
			}
			this.placemarkContainer = placemarkContainer;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * Whether or not to cache the placemark positions.
		 * 
		 * <p>If <code>false</code>, positions are recalculated every time the same placemark is added. 
		 * If <code>true</code>, positions are reused every time the same placemark is added.</p>
		 * 
		 * @default true
		 */
		public function get cachePlacemarkPositions():Boolean
		{ 
			return this._cachePlacemarkPositions; 
		}
		/**
		 * @private
		 */
		public function set cachePlacemarkPositions(value:Boolean):void
		{
			var oldValue:Boolean = this._cachePlacemarkPositions;
			if (value != oldValue)
			{
				this._cachePlacemarkPositions = value;
				if (!value && this.positionCache)
					this.positionCache = null;
					
			}
		}
		
		/**
		 * Whether or not to recycle placemark renderer instances.
		 *  
		 * <p>If <code>false</code>, a new placemark renderer instance is created every 
		 * time a placemark is added. If <code>true</code>, placemark renderers created 
		 * for placemarks that are removed will be used for placemarks that are added.</p>
		 * 
		 * @default true
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
				if (!value && this.placemarks2Renderers)
					this.placemarks2Renderers = null;
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * 
		 */
		public function addPlacemark(placemark:Object):void
		{
			if (!this.placemarks.containsItem(placemark))
				this.placemarks.addItem(placemark);
		}
		
		/**
		 * 
		 */
		public function addPlacemarks(placemarks:Array):void
		{
			for (var i:int = 0; i < placemarks.length; i++)
				this.addPlacemark(placemarks[i]);
		}
		
		/**
		 * 
		 */
		public function destroy():void
		{
			this.placemarks.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.placemarks_collectionChangeHandler);
			this.placemarks = null;
		}
		
		/**
		 * 
		 */
		public function removeAllPlacemarks():void
		{
			if (this.placemarks.length)
				this.placemarks.removeAll();
		}
		
		/**
		 * 
		 */
		public function removePlacemark(placemark:Object):void
		{
			if (this.placemarks.containsItem(placemark))
				this.placemarks.removeItem(placemark);
		}
		
		/**
		 * 
		 */
		public function removePlacemarks(placemarks:Array):void
		{
			for (var i:int = 0; i < placemarks.length; i++)
				this.removePlacemark(placemarks[i]);
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		protected function getPlacemarkRendererFor(placemark:Object):Object
		{
			var renderer:Object;

// TODO: recycle placemarks instead of simply saving all of them.
if (this.recyclePlacemarkRenderers)
{
	if (!this.placemarks2Renderers)
		this.placemarks2Renderers = new Dictionary(true);
	else
		renderer = this.placemarks2Renderers[placemark];
}

			if (!renderer)
			{
				renderer = new this.map.placemarkRendererClass();
if (this.recyclePlacemarkRenderers)
	this.placemarks2Renderers[placemark] = renderer;
			}

			renderer.model = placemark;
			return renderer;
		}

		/**
		 * @inheritDoc
		 */
		protected function getPositionFor(placemark:Object):Point
		{
			var point:Point;

			// If position caching is enabled, look for a cached position for this placemark.
			if (this.cachePlacemarkPositions)
			{
				if (!this.positionCache)
					this.positionCache = new Dictionary(true);
				else
					point = this.positionCache[placemark];

			}

			if (!point)
			{
				point = this.getKMLCoordinatesFor(placemark);

				var longitudeDifference:Number = this.map.model.latLonBox.east - this.map.model.latLonBox.west;
				var latitudeDifference:Number = this.map.model.latLonBox.south - this.map.model.latLonBox.north;

				var mapBounds:Rectangle = DisplayObject(this.map).getBounds(DisplayObject(this.map));

				point.x = ((point.x - this.map.model.latLonBox.west) / longitudeDifference) * mapBounds.width;
				point.y = ((point.y - this.map.model.latLonBox.north) / latitudeDifference) * mapBounds.height;

				if (this.map.model.latLonBox.rotation)
				{
					var center:Point = new Point(mapBounds.width / 2, mapBounds.height / 2);
					point = point.subtract(center);		
					this.rotatePoint(point, this.map.model.latLonBox.rotation);
					point =	point.add(center);
				}

				// If position caching is enabled, cache the calculated position for this placemark.
				if (this.cachePlacemarkPositions)
					this.positionCache[placemark] = point;
			}

			return point;
		}

		/**
		 * @inheritDoc
		 */
		protected function invalidateProperty(property:String):void
		{
			this.layoutValidator.properties[property] = this[property];
			this.invalidate();
		}

		/**
		 * @inheritDoc
		 */
		protected function invalidate():void
		{
			this.layoutValidator.invalidate();
		}

		/**
		 * @inheritDoc
		 */
		protected function validate():void
		{
			var placemarksAreInvalid:Boolean = this.layoutValidator.validationState.propertyIsInvalid("placemarks");
			this.layoutValidator.validationState.markAllPropertiesAsValid();

			if (placemarksAreInvalid)
			{
				var placemark:Object;

				// Remove any placemarks no longer present.
				while (this.placemarkContainer.numChildren)
					this.placemarkContainer.removeChildAt(0);

				// Add any items not already added.
				for (var i:IIterator = this.placemarks.iterator(); i.hasNext(); )
				{
					var placemarkModel:Object = i.next();
					placemark = this.getPlacemarkRendererFor(placemarkModel);
					var placemarkPosition:Point = this.getPositionFor(placemarkModel);
					placemark.x = placemarkPosition.x;
					placemark.y = placemarkPosition.y;
//					this.adjustScaleForPlacemark(placemark as DisplayObject);
					this.placemarkContainer.addChild(placemark as DisplayObject);
				}
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function getKMLCoordinatesFor(placemark:Object):Point
		{
			var coords:Object = placemark.geometry.coordinates.coordsList[0];
			return new Point(coords.lon, coords.lat);
		}
		
		/**
		 * 
		 */
		private function placemarks_collectionChangeHandler(event:CollectionEvent):void
		{
			this.invalidateProperty("placemarks");
		}
		
		/**
		 * 
		 */
		private function rotatePoint(p:Point, r:Number):void
		{
			r *= Math.PI / 180;
			var cos:Number = Math.cos(r);
			var sin:Number = Math.sin(r);
			var oldX:Number = p.x;
			var oldY:Number = p.y;
			p.x = oldX * cos - oldY * sin;
			p.y = oldX * sin + oldY * cos;
		}
		
		

		
	}
	
}