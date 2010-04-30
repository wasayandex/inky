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
		protected var availableRenderers:Array;
		protected var rendererCache:Dictionary;
		protected var positionCache:Dictionary;
		private var recyclePlacemarkRenderers:Boolean;
		private var scalePlacemarkRenderers:Boolean;
		private var watchers:Array;
		private var unplottablePlacemarks:Dictionary = new Dictionary(true);

		public var placemarks:ArrayList;
		
		/**
		 * Creates a new placemark plotter.
		 */
		public function PlacemarkPlotter()
		{
			this.placemarks = new ArrayList();
			this.placemarks.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.placemarks_collectionChangeHandler);
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
				point = this.getKMLCoordinatesFor(placemark);

				var longitudeDifference:Number = model.latLonBox.east - model.latLonBox.west;
				var latitudeDifference:Number = model.latLonBox.south - model.latLonBox.north;

				var kmlBounds:Rectangle = new Rectangle(model.latLonBox.west, model.latLonBox.north, longitudeDifference, latitudeDifference);

				if (!this.numberIsBetween(point.x, kmlBounds.left, kmlBounds.right) || !this.numberIsBetween(point.y, kmlBounds.top, kmlBounds.bottom))
				{
					if (!this.unplottablePlacemarks[placemark])
					{
						this.unplottablePlacemarks[placemark] = true;
						trace("Warning: placemark is out of bounds. It will not be plotted.\not" + placemark.xml);
					}
					return null;
				}

				var mapBounds:Rectangle = this.info.overlayContainer.getRect(this.info.contentContainer);

				point.x = mapBounds.x + ((point.x - this.info.map.model.latLonBox.west) / longitudeDifference) * mapBounds.width;
				point.y = mapBounds.y + ((point.y - this.info.map.model.latLonBox.north) / latitudeDifference) * mapBounds.height;

				if (model.latLonBox.rotation)
				{
					var center:Point = new Point(mapBounds.width / 2, mapBounds.height / 2);
					point = point.subtract(center);		
					this.rotatePoint(point, this.info.map.model.latLonBox.rotation);
					point =	point.add(center);
				}

				// Cache the calculated position for this placemark.
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
				BindingUtil.bindSetter(this.toggleRecyclePlacemarkRenderers, info.map, "recyclePlacemarkRenderers"),
				BindingUtil.bindSetter(this.toggleScalePlacemarkRenderers, info.map, "scalePlacemarkRenderers"),
				BindingUtil.bindSetter(this.setSelectedFolders, info.map, ["model", "selectedFolders"])
			];

			info.map.addEventListener(MapEvent.SCALED, this.content_scaledHandler);
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
		override protected function reset():void
		{
			super.reset();
			this.clearPositionCache();
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
					renderer = Object(this.info..placemarkContainer.getChildAt(i));
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
		 * Set the selected folders. This method may be overriden by subclasses 
		 * to alter the view behavior when folder selections change.
		 * 
		 * @param folders
		 * 		A list of selected folers.
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
		 * 
		 */
		private function toggleRecyclePlacemarkRenderers(value:Boolean):void
		{
			this.recyclePlacemarkRenderers = value;
			if (!value && this.availableRenderers)
				this.availableRenderers = null;
		}
		
		/**
		 * 
		 */
		private function toggleScalePlacemarkRenderers(value:Boolean):void
		{
			this.scalePlacemarkRenderers = value;
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