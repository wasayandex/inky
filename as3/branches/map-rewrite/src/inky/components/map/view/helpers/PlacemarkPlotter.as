package inky.components.map.view.helpers 
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import inky.collections.IIterator;
	import inky.collections.events.CollectionEvent;
	import inky.collections.ArrayList;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.components.map.view.events.MapEvent;
	import inky.utils.EqualityUtil;
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.binding.utils.BindingUtil;
	
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
	public class PlacemarkPlotter extends BaseMapHelper
	{
		private var _avoidPlacemarkCollisions:Boolean = false;
		protected var availableRenderers:Array;
		protected var rendererCache:Dictionary;
		private var _placemarkSnapX:Number = 0;
		private var _placemarkSnapY:Number = 0;
		protected var positionCache:Dictionary;
		private var _recyclePlacemarkRenderers:Boolean;
		private var _scalePlacemarkRenderers:Boolean;
		private var watchers:Array;
		private var unplottablePlacemarks:Dictionary = new Dictionary(true);
		private var placemarkPositions:Object = {};
		public var placemarks:ArrayList;
		private var snapDegreesX:Number;
		private var snapDegreesY:Number;
		
		/**
		 * Creates a new placemark plotter.
		 */
		public function PlacemarkPlotter()
		{
			this.placemarks = new ArrayList();
			this.placemarks.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.placemarks_collectionChangeHandler);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get avoidPlacemarkCollisions():Boolean
		{ 
			return this._avoidPlacemarkCollisions; 
		}
		/**
		 * @private
		 */
		public function set avoidPlacemarkCollisions(value:Boolean):void
		{
			this._avoidPlacemarkCollisions = value;
		}

		/**
		 *
		 */
		public function get placemarkSnapY():Number
		{ 
			return this._placemarkSnapY; 
		}
		/**
		 * @private
		 */
		public function set placemarkSnapY(value:Number):void
		{
			this._placemarkSnapY = value;
			this.recalculateSnapDegrees();
		}

		/**
		 *
		 */
		public function get placemarkSnapX():Number
		{ 
			return this._placemarkSnapX;
		}
		/**
		 * @private
		 */
		public function set placemarkSnapX(value:Number):void
		{
			this._placemarkSnapX = value;
			this.recalculateSnapDegrees();
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
			this._recyclePlacemarkRenderers = value;
			if (!value && this.availableRenderers)
				this.availableRenderers = null;
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
		public function get scalePlacemarkRenderers():Boolean
		{
			return this._scalePlacemarkRenderers;
		}
		public function set scalePlacemarkRenderers(value:Boolean):void
		{
			this._scalePlacemarkRenderers = value;
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
		override public function destroy():void
		{
			super.destroy();
			
			if (this.watchers)
			{
				while (this.watchers.length)
					this.watchers.pop().unwatch();
			}

			this.placemarks.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.placemarks_collectionChangeHandler);
			this.placemarks = null;
			
			if (this.rendererCache)
				this.rendererCache = null;
				
			if (this.positionCache)
				this.positionCache = null;
		}

		/**
		 * Returns a placemark renderer for the specified placemark.
		 * 
		 * @param placemark
		 * 		The placemark to retrieve a renderer for.
		 */
		public function getPlacemarkRendererFor(placemark:Object):Object
		{
			var renderer:Object;

			if (!this.rendererCache)
			{
				this.rendererCache = new Dictionary(true);
			}
			else
			{
				for (var key:Object in this.rendererCache)
				{
					if (EqualityUtil.objectsAreEqual(this.rendererCache[key], placemark))
					{
						renderer = key;
						break;
					}
				}
			}
			
			if (!renderer)
				renderer = this.getAvailablePlacemarkRenderer();

			this.rendererCache[renderer] = placemark;
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
			var model:Object = this.info.map.model;

			// Look for a cached position for this placemark.
			if (!this.positionCache)
			{
				this.positionCache = new Dictionary();
			}
			else
			{
				for (var key:Object in this.positionCache)
				{
					if (EqualityUtil.objectsAreEqual(this.positionCache[key], placemark))
					{
						this.positionCache[key] = placemark;
						point = key as Point;
						break;
					}
				}
			}

			if (!point && model)
			{
				// Cache the calculated position for this placemark.
				point = this.calculatePlacemarkPosition(placemark);
				this.positionCache[point] = placemark;
			}

			return point;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);
			this.watchers = 
			[
				BindingUtil.bindSetter(this.setSelectedFolders, info.map, ["model", "selectedFolders"])
			];

			info.map.addEventListener(MapEvent.SCALED, this.content_scaledHandler);
			info.map.addEventListener(MapEvent.OVERLAY_UPDATED, this.map_overlayUpdatedHandler);
			this.recalculateSnapDegrees();
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
		 * 
		 */
		protected function calculatePlacemarkPosition(placemark:Object):Point
		{
			var point:Point = this.getKMLCoordinatesFor(placemark);
			var model:Object = this.info.map.model;

			var longitudeDifference:Number = model.latLonBox.east - model.latLonBox.west;
			var latitudeDifference:Number = model.latLonBox.south - model.latLonBox.north;

			var kmlBounds:Rectangle = new Rectangle(model.latLonBox.west, model.latLonBox.north, longitudeDifference, latitudeDifference);

			if (!this.numberIsBetween(point.x, kmlBounds.left, kmlBounds.right) || !this.numberIsBetween(point.y, kmlBounds.top, kmlBounds.bottom))
			{
				if (!this.unplottablePlacemarks[placemark])
				{
					this.unplottablePlacemarks[placemark] = true;
					trace("Warning: placemark is out of bounds. It will not be plotted.\n" + placemark.xml);
				}
				return null;
			}

			var mapBounds:Rectangle = this.info.overlayContainer.getRect(this.info.contentContainer);

			// Snap the placemarks.
			if (this.placemarkSnapX)
				point.x = Math.round(point.x / this.snapDegreesX) * this.snapDegreesX;
			if (this.placemarkSnapY)
				point.y = Math.round(point.y / this.snapDegreesY) * this.snapDegreesY;

			point.x = mapBounds.x + ((point.x - this.info.map.model.latLonBox.west) / longitudeDifference) * mapBounds.width;
			point.y = mapBounds.y + ((point.y - this.info.map.model.latLonBox.north) / latitudeDifference) * mapBounds.height;

			if (model.latLonBox.rotation)
			{
				var center:Point = new Point(mapBounds.width / 2, mapBounds.height / 2);
				point = point.subtract(center);		
				this.rotatePoint(point, this.info.map.model.latLonBox.rotation);
				point =	point.add(center);
			}

			if (!this.placemarkSnapX || !this.placemarkSnapY && this.avoidPlacemarkCollisions)
			{
				throw new Error("You can't avoid collisions unless you specify values for placemarkSnapX and placemarkSnapY");
			}
			else if (this.avoidPlacemarkCollisions)
			{
				var r:int = 0;
				var p:Point;
				while (!p)
				{
					p = this.tryPosition(point, r);
					r++;
				}
				point = p;
				this.placemarkPositions[point.x + "," + point.y] = true;
			}

			return point;
		}
		
		
		/**
		 * 
		 */
		private function map_overlayUpdatedHandler(event:MapEvent):void
		{
			this.recalculateSnapDegrees();
		}

		/**
		 * 
		 */
		private function tryPosition(origin:Point, r:int):Point
		{
			return this.tryPositionInDirection(origin, r, true) || this.tryPositionInDirection(origin, r, false);
		}
		
		/**
		 * @return the first found non-colliding point, or null if none is found
		 */
		private function tryPositionInDirection(origin:Point, r:int, horizontal:Boolean):Point
		{
			var p:Point = origin.clone();
			
			var collides:Boolean = true;
			for each (var i:int in [-r, r])
			{
				for (var j:int = -r; j <= r; j++)
				{
					var xOffset:int;
					var yOffset:int;
					if (horizontal)
					{
						xOffset = j;
						yOffset = i;
					}
					else
					{
						xOffset = i;
						yOffset = j;
					}

					p.x = Math.round(origin.x + xOffset * this.placemarkSnapX);
					p.y = Math.round(origin.y + yOffset * this.placemarkSnapY);

					collides = this.placemarkPositions[p.x + "," + p.y];

					if (!collides)
						break;
				}
				if (!collides)
					break;
			}

			return collides ? null : p;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function reset():void
		{
			super.reset();
			this.clearPositionCache();
			this.recalculateSnapDegrees();
		}

		/**
		 * @inheritDoc
		 */
		override protected function validate():void
		{
			var placemarksAreInvalid:Boolean = this.info.layoutValidator.validationState.propertyIsInvalid("placemarks");
			super.validate();

// TODO: Separate updating the model (adding and removing placemarks) from updating the positions.
			if (placemarksAreInvalid)
			{
				var renderer:Object;
				var placemark:Object;

				// Remove any placemarks no longer present.
				for (var i:int = 0; i < this.info.placemarkContainer.numChildren; i++)
				{
					renderer = Object(this.info.placemarkContainer.getChildAt(i));
					placemark = renderer.model;
					if (!this.placemarks.containsItem(placemark))
					{
						this.recyclePlacemarkRenderer(renderer)
						i--;
					}
				}
				
				// Add any items not already added, and adjust all placemark positions.
				for (var j:IIterator = this.placemarks.iterator(); j.hasNext(); )
				{
					renderer = this.getPlacemarkRendererFor(j.next());
					if (this.updatePlacemarkRendererPosition(renderer))
						this.info.placemarkContainer.addChild(renderer as DisplayObject);
				}
			}
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function recalculateSnapDegrees():void
		{
			if (!this.info || !this.info.overlayContainer || !this.info.contentContainer || !this.info.map || !this.info.map.model)
			{
				this.snapDegreesX = 0;
				this.snapDegreesY = 0;
				return;
			}
			
			var mapBounds:Rectangle = this.info.overlayContainer.getRect(this.info.contentContainer);
			var model:Object = this.info.map.model;
			var longitudeDifference:Number = model.latLonBox.east - model.latLonBox.west;
			var latitudeDifference:Number = model.latLonBox.south - model.latLonBox.north;
			var pxPerDegreeX:Number = mapBounds.width / longitudeDifference;
			var pxPerDegreeY:Number = mapBounds.height / latitudeDifference;
			this.snapDegreesX = this.placemarkSnapX / pxPerDegreeX;
			this.snapDegreesY = this.placemarkSnapY / pxPerDegreeY;
		}
		
		/**
		 * 
		 */
		private function content_scaledHandler(event:MapEvent):void
		{
			if (this.scalePlacemarkRenderers)
			{
				this.info.placemarkContainer.scaleX = this.info.overlayContainer.scaleX;
				this.info.placemarkContainer.scaleY = this.info.overlayContainer.scaleY;
			}
			else
			{
				this.clearPositionCache();

				for (var j:IIterator = this.placemarks.iterator(); j.hasNext(); )
					this.updatePlacemarkRendererPosition(this.getPlacemarkRendererFor(j.next()));
			}
		}
		
		/**
		 * 
		 */
		private function clearPositionCache():void
		{
			this.positionCache = null;
			this.placemarkPositions = {};
		}

		/**
		 * 
		 */
		private function getAvailablePlacemarkRenderer():Object
		{
			if (!this.info.map.placemarkRendererClass)
				throw new Error("placemarkRendererClass not defined on map.");

			var renderer:Object;

			if (this.recyclePlacemarkRenderers && this.availableRenderers && this.availableRenderers.length)
				renderer = this.availableRenderers.pop();
			
			if (!renderer)
				renderer = new this.info.map.placemarkRendererClass();
			
			return renderer;
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
		private function numberIsBetween(n:Number, a:Number, b:Number):Boolean
		{
			var min:Number;
			var max:Number;
			if (a < b)
			{
				min = a;
				max = b;
			}
			else
			{
				min = b;
				max = a;
			}

			return n <= max && n >= min;
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
		private function recyclePlacemarkRenderer(renderer:Object):void
		{
			if (this.info.placemarkContainer.contains(DisplayObject(renderer)))
				this.info.placemarkContainer.removeChild(DisplayObject(renderer));
			
			delete this.rendererCache[renderer];

			if (this.recyclePlacemarkRenderers)
			{
				if (!this.availableRenderers)
					this.availableRenderers = [];

				this.availableRenderers.push(renderer);
			}
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
		 * 
		 */
		private function setSelectedFolders(folders:Array):void
		{
			this.removeAllPlacemarks();
			
			var model:Object = this.info.map.model;
			
			if (model)
			{
				for each (var folder:Object in model.selectedFolders)
					this.addPlacemarks(model.getPlacemarks(folder));
				
				// Add the placemarks that sit outside of the folder structure.
				// Since they don't reside in folders that can never be selected, they are always present.
				this.addPlacemarks(model.getPlacemarks(model.document));
			}
		}

		/**
		 * @inheritDoc
		 */
		private function updatePlacemarkRendererPosition(renderer:Object):Boolean
		{
			var placemarkPosition:Point = this.getPositionFor(renderer.model);
			
			if (placemarkPosition)
			{
				renderer.x = placemarkPosition.x;
				renderer.y = placemarkPosition.y;
			}
			
			return placemarkPosition != null;
		}

	}
	
}