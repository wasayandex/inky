package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import flash.events.Event;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import inky.utils.toCoordinateSpace;
	import inky.utils.IDestroyable;
	import inky.components.map.view.events.MapEvent;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import inky.components.map.view.IInteractiveMap;
	import inky.display.utils.scale;
	
	/**
	 *
	 *  An IMap view helper that provides basic 'zooming' functionality.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.12
	 *
	 */
	public class ZoomingHelper extends MaskedMapViewHelper implements IDestroyable
	{
		private var _maximumZoom:Number;
		private var _minimumZoom:Number;
		private var _zoom:Number;
		private var _zoomInButton:InteractiveObject;
		private var _zoomingProxy:Object;
		private var _zoomControl:Object;
		private var _zoomOutButton:InteractiveObject;
		protected var overlayContainer:DisplayObjectContainer;

		/**
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 * 
		 * @param overlayContainer
		 * 		The map's overlay container.
		 * 
		 * @param zoomingProxy
		 * 		An object that stands in for the contentContainer in scale manipulation methods.
		 * 
		 * @param maximumZoom
		 * 		The maximum 'zoom' amount.
		 * @see #maximumZoom
		 * 
		 * @param minimumZoom
		 * 		The minimum 'zoom' amount.
		 * @see #minimumZoom
		 * 
		 */
		public function ZoomingHelper(map:IInteractiveMap, layoutValidator:LayoutValidator, mask:DisplayObject, contentContainer:DisplayObjectContainer, overlayContainer:DisplayObjectContainer, zoomingProxy:Object = null, maximumZoom:Number = 2, minimumZoom:Number = 1)
		{
			super(map, layoutValidator, mask, contentContainer);
			
			this.zoomingProxy = zoomingProxy;
			this.maximumZoom = maximumZoom;
			this.minimumZoom = minimumZoom;
			
			this._zoomControl = this.mapContent.getChildByName("_zoomControl");
			if (this._zoomControl)
				this._zoomControl.addEventListener(Event.CHANGE, this.zoomControl_changeHandler);
			
			this.overlayContainer = overlayContainer;
			this._zoom = overlayContainer.scaleX;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * The maximum 'zoom' or 'scale' amount.
		 * 
		 * @default 2
		 */
		public function get maximumZoom():Number
		{ 
			return this._maximumZoom; 
		}
		/**
		 * @private
		 */
		public function set maximumZoom(value:Number):void
		{
			this._maximumZoom = value;
		}
		
		/**
		 * The minimum 'zoom' or 'scale' amount.
		 * 
		 * @default 1
		 */
		public function get minimumZoom():Number
		{ 
			return this._minimumZoom; 
		}
		/**
		 * @private
		 */
		public function set minimumZoom(value:Number):void
		{
			this._minimumZoom = value;
		}
		
		/**
		 *
		 */
		public function get zoom():Number
		{ 
			return this._zoom; 
		}
		/**
		 * @private
		 */
		public function set zoom(value:Number):void
		{
			if (value != this._zoom)
			{
				this._zoom = value;
				scale(this.overlayContainer, value, this.getCenterPoint());
				this.mapContent.dispatchEvent(new MapEvent(MapEvent.SCALED));
			}
		}

		/**
		 * An object that stands in for the contentContainer in scale manipulation methods.
		 * For example, setting this value to a GTween proxy will let you have easing pretty easily.
		 * 
		 * @default null
		 */
		public function get zoomingProxy():Object
		{ 
			return this._zoomingProxy; 
		}
		/**
		 * @private
		 */
		public function set zoomingProxy(value:Object):void
		{
			this._zoomingProxy = value;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function zoomControl_changeHandler(event:Event):void
		{
			this.setZoom(event.currentTarget.value);
		}

		/**
		 * 
		 */
		private function getCenterPoint():Point
		{
			return toCoordinateSpace(new Point(this.mask.width * 0.5, this.mask.height * 0.5), this.mask, this.overlayContainer);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function setZoom(zoom:Number):void
		{
			var target:Object = this.zoomingProxy || this;
			target.zoom = zoom;
		}

	}	
}