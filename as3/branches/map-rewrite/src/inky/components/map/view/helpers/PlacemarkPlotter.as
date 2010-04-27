package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import inky.collections.IIterator;
	import inky.collections.events.CollectionEvent;
	import inky.collections.ArrayList;
	import inky.utils.IDestroyable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.components.map.view.helpers.BaseMapViewHelper;
	import inky.components.map.view.events.MapEvent;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	
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
		protected var contentContainer:DisplayObjectContainer;
		protected var placemarkContainer:DisplayObjectContainer;
		protected var overlayContainer:DisplayObjectContainer;
		protected var placemarks2Renderers:Dictionary;
		protected var positionCache:Dictionary;
		private var _recyclePlacemarkRenderers:Boolean;
		private var _scalePlacemarks:Boolean;

		public var placemarks:ArrayList;
		
		/**
		 * @copy inky.components.map.view.helpers.BaseMapViewHelper
		 * 
		 * @param placemarkContainer
		 * 		The map's placemark container.
		 * 
		 * @param overlayContainer
		 * 		The map's overlay container.
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
		public function PlacemarkPlotter(map:IMap, layoutValidator:LayoutValidator, contentContainer:DisplayObjectContainer, placemarkContainer:DisplayObjectContainer, overlayContainer:DisplayObjectContainer, scalePlacemarks:Boolean = false, recyclePlacemarkRenderers:Boolean = true, cachePlacemarkPositions:Boolean = true)
		{
			super(map, layoutValidator);
			
			this.recyclePlacemarkRenderers = recyclePlacemarkRenderers;
			this.cachePlacemarkPositions = cachePlacemarkPositions;
			this.scalePlacemarks = scalePlacemarks;
			
			this.placemarks = new ArrayList();
			this.placemarks.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.placemarks_collectionChangeHandler);
			
			this.contentContainer = contentContainer;
			this.placemarkContainer = placemarkContainer;
			this.overlayContainer = overlayContainer;
			
			this.mapContent.addEventListener(MapEvent.SCALED, this.content_scaledHandler);
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
				if (!value)
					this.clearPositionCache();
					
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
		
		/**
		 * Whether or not to scale the placemarks when the map is scaled (zoomed).
		 * 
		 * <p>If <code>false</code>, placemarks are repositioned when the map is scaled. The size 
		 * of the placemarks does not change, but their positions are adjusted relative to the 
		 * scale of the map. If <code>true</code>, the placemarks are not repositioned. The placemark 
		 * container is scaled along with the map, so that the placemarks keep the same positions 
		 * relative to the map. However, the size of the placemarks also scales.</p>
		 * 
		 * @default false
		 */
		public function get scalePlacemarks():Boolean
		{ 
			return this._scalePlacemarks; 
		}
		/**
		 * @private
		 */
		public function set scalePlacemarks(value:Boolean):void
		{
			this._scalePlacemarks = value;
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
		 * Returns a placemark renderer for the specified placemark.
		 * 
		 * @param placemark
		 * 		The placemark to retrieve a renderer for.
		 */
		public function getPlacemarkRendererFor(placemark:Object):Object
		{
			if (!this.map.placemarkRendererClass)
				throw new Error("placemarkRendererClass not defined on map.");

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
		 * Returns a point that represents the position a placemark renderer 
		 * for the provided placemark would occupy.
		 * 
		 * @param placemark
		 * 		The placemark to retrieve a renderer position for.
		 */
		public function getPositionFor(placemark:Object):Point
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

				var mapBounds:Rectangle = this.overlayContainer.getRect(this.contentContainer);

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
			else
			{
				trace("using cached position. HAHA pwdn")
			}

			return point;
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
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			this.clearPositionCache();
		}

		/**
		 * @inheritDoc
		 */
		override public function validate():void
		{
			var placemarksAreInvalid:Boolean = this.validationState.propertyIsInvalid("placemarks");
			super.validate();

// TODO: Separate updating the model (adding and removing placemarks) from updating the positions.
			if (placemarksAreInvalid)
			{
				var placemark:Object;
				var placemarkModel:Object;

				// Remove any placemarks no longer present.
				for (var i:int = 0; i < this.placemarkContainer.numChildren; i++)
				{
					placemarkModel = Object(this.placemarkContainer.getChildAt(i)).model;
					if (!this.placemarks.containsItem(placemarkModel))
						this.placemarkContainer.removeChildAt(i--);
				}
				// Add any items not already added, and adjust all placemark positions.
				for (var j:IIterator = this.placemarks.iterator(); j.hasNext(); )
				{
					placemark = this.getPlacemarkRendererFor(j.next());
					this.updatePlacemarkPosition(placemark);
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
		private function content_scaledHandler(event:MapEvent):void
		{
			if (this.scalePlacemarks)
			{
				this.placemarkContainer.scaleX = this.overlayContainer.scaleX;
				this.placemarkContainer.scaleY = this.overlayContainer.scaleY;
			}
			else
			{
				if (this.cachePlacemarkPositions)
					this.clearPositionCache();

				for (var j:IIterator = this.placemarks.iterator(); j.hasNext(); )
					this.updatePlacemarkPosition(this.getPlacemarkRendererFor(j.next()));
			}
		}
		
		/**
		 * 
		 */
		private function clearPositionCache():void
		{
			this.positionCache = null;
		}

		/**
		 * 
		 */
		private function getKMLCoordinatesFor(placemark:Object):Point
		{
			var point:Object = placemark.point;
			return new Point(point.longitude, point.latitude);
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
		
		/**
		 * @inheritDoc
		 */
		protected function updatePlacemarkPosition(placemark:Object):void
		{
			var placemarkPosition:Point = this.getPositionFor(placemark.model);

			placemark.x = placemarkPosition.x;
			placemark.y = placemarkPosition.y;
		}

	}
	
}