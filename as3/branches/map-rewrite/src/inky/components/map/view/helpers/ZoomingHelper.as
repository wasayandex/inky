package inky.components.map.view.helpers 
{
	import flash.events.Event;
	import flash.geom.Point;
	import inky.utils.toCoordinateSpace;
	import inky.components.map.view.events.MapEvent;
	import flash.display.DisplayObjectContainer;
	import inky.display.utils.scale;
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.components.map.view.helpers.HelperInfo;
	
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
	public class ZoomingHelper extends BaseMapHelper
	{
		private var _maximumZoom:Number;
		private var _minimumZoom:Number;
		private var _zoom:Number;
		private var _zoomingProxy:Object;
		private var _zoomControl:Object;
		protected var overlayContainer:DisplayObjectContainer;

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
			if (value != this._maximumZoom)
			{
				this._maximumZoom = value;
				this._zoomControl.maximum = value;
			}
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
			if (value != this._minimumZoom)
			{
				this._minimumZoom = value;
				this._zoomControl.minimum = value;
			}
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
				this._zoomControl.value = this.zoomingProxy ? this.zoomingProxy.zoom : value;
				scale(this.info.overlayContainer, value, this.getCenterPoint());
				this.info.map.dispatchEvent(new MapEvent(MapEvent.SCALED));
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
		override public function destroy():void
		{
			super.destroy();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);

			this._zoomControl = DisplayObjectContainer(this.info.map).getChildByName("_zoomControl");
			if (this._zoomControl)
				this._zoomControl.addEventListener(Event.CHANGE, this.zoomControl_changeHandler);
			
			this._zoom = this.info.overlayContainer.scaleX;
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function zoomControl_changeHandler(event:Event):void
		{
			var target:Object = this.zoomingProxy || this;
			target.zoom = event.currentTarget.value;
		}

		/**
		 * 
		 */
		private function getCenterPoint():Point
		{
			return toCoordinateSpace(new Point(this.info.mask.width * 0.5, this.info.mask.height * 0.5), this.info.mask, this.info.overlayContainer);
		}

	}	
}