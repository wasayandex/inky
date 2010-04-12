package inky.components.map.view.helpers 
{
	import flash.display.DisplayObjectContainer;
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import inky.display.utils.scale;
	import inky.components.map.view.IMap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.utils.toCoordinateSpace;
	
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
	public class ZoomingHelper extends MaskedMapViewHelper
	{
		private var _maximumZoom:Number;
		private var _minimumZoom:Number;
		private var _zoomInButton:InteractiveObject;
		private var _zoomingProxy:Object;
		private var _zoomInterval:Number;
		private var _zoomOutButton:InteractiveObject;

		/**
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 * 
		 * @param maximumZoom
		 * 		The maximum 'zoom' amount.
		 * @see #maximumZoom
		 * 
		 * @param minimumZoom
		 * 		The minimum 'zoom' amount.
		 * @see #minimumZoom
		 * 
		 * @param zoomInterval
		 * 		The amount of 'zoom' change per update.
		 * @see #zoomInterval
		 */
		public function ZoomingHelper(map:IMap, zoomingProxy:Object = null, maximumZoom:Number = 2, minimumZoom:Number = 1, zoomInterval:Number = 0.1)
		{
			super(map);
			
			this.zoomingProxy = zoomingProxy;
			this.maximumZoom = maximumZoom;
			this.minimumZoom = minimumZoom;
			this.zoomInterval = zoomInterval;
			
			this.zoomInButton = this.content.getChildByName("_zoomInButton") as InteractiveObject;
			this.zoomOutButton = this.content.getChildByName("_zoomOutButton") as InteractiveObject;
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
		 * Interactive Object that is monitored for mouse activity. 
		 * While the mouse is down, the map will 'zoom' in.
		 */
		public function get zoomInButton():InteractiveObject
		{ 
			return this._zoomInButton; 
		}
		/**
		 * @private
		 */
		public function set zoomInButton(value:InteractiveObject):void
		{
			var oldValue:Object = this._zoomInButton;
			if (value != oldValue)
			{
				if (oldValue)
				{
					oldValue.removeEventListener(MouseEvent.MOUSE_DOWN, this.zoomInButton_mouseDownHandler);
					oldValue.removeEventListener(MouseEvent.MOUSE_UP, this.zoomInButton_mouseUpHandler);
				}
				if (value)
				{
					value.addEventListener(MouseEvent.MOUSE_DOWN, this.zoomInButton_mouseDownHandler);
					value.addEventListener(MouseEvent.MOUSE_UP, this.zoomInButton_mouseUpHandler);
				}
				this._zoomInButton = value;
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
		
		/**
		 * The amount of 'zoom' or 'scale' change per update.
		 * 
		 * @default 0.1
		 */
		public function get zoomInterval():Number
		{ 
			return this._zoomInterval; 
		}
		/**
		 * @private
		 */
		public function set zoomInterval(value:Number):void
		{
			this._zoomInterval = value;
		}

		/**
		 * Interactive Object that is monitored for mouse activity. 
		 * While the mouse is down, the map will 'zoom' out.
		 */
		public function get zoomOutButton():InteractiveObject
		{ 
			return this._zoomOutButton; 
		}
		/**
		 * @private
		 */
		public function set zoomOutButton(value:InteractiveObject):void
		{
			var oldValue:InteractiveObject = this._zoomOutButton;
			if (value != oldValue)
			{
				if (oldValue)
				{
					oldValue.removeEventListener(MouseEvent.MOUSE_DOWN, this.zoomOutButton_mouseDownHandler);
					oldValue.removeEventListener(MouseEvent.MOUSE_UP, this.zoomOutButton_mouseUpHandler);
				}
				if (value)
				{
					value.addEventListener(MouseEvent.MOUSE_DOWN, this.zoomOutButton_mouseDownHandler);
					value.addEventListener(MouseEvent.MOUSE_UP, this.zoomOutButton_mouseUpHandler);
				}
				this._zoomOutButton = value;
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Scales the content.
		 */
		public function scaleContent(scaleX:Number, scaleY:Number):void
		{
			var obj:Object = this.zoomingProxy || this.map;
			if (obj.contentScaleX != scaleX || obj.contentScaleY != scaleY)
			{
				var point:Point = toCoordinateSpace(new Point(this.mask.width * 0.5, this.mask.height * 0.5), this.mask, this.contentContainer);
				scale(obj, [scaleX, scaleY], point, {x: "contentX", y: "contentY", scaleX: "contentScaleX", scaleY: "contentScaleY", rotation: "contentRotation"});
			}
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function validate():void
		{
			var scaleIsInvalid:Boolean = this.validationState.propertyIsInvalid("contentScaleX") || this.validationState.propertyIsInvalid("contentScaleY");
			super.validate();
			
			if (scaleIsInvalid)
			{
				this.contentContainer.scaleX = this.contentScaleX;
				this.contentContainer.scaleY = this.contentScaleY;
				
//				var obj:Object = this.zoomingProxy || this.map;
				var dragBounds:Rectangle = this.getDragBounds();
// FIXME: This mostly works, but why doesn't it work going through contentX and contentY??
				this.contentContainer.x = Math.max(Math.min(dragBounds.right, this.contentContainer.x), dragBounds.left);
				this.contentContainer.y = Math.max(Math.min(dragBounds.bottom, this.contentContainer.y), dragBounds.top);
			}
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * Scale the map up.
		 */
		private function zoomIn(event:Event):void
		{
			var obj:Object = this.zoomingProxy || this.map;
			var scaleX:Number = obj.contentScaleX;
			var scaleY:Number = obj.contentScaleY;

			scaleX += this.zoomInterval;
			scaleY += this.zoomInterval;
			this.scaleContent(scaleX >= this.maximumZoom ? this.maximumZoom : scaleX, scaleY >= this.maximumZoom ? this.maximumZoom : scaleY);
		}

		/**
		 * 
		 */
		private function zoomInButton_mouseDownHandler(event:MouseEvent):void
		{
			this.content.addEventListener(Event.ENTER_FRAME, this.zoomIn);			
		}

		/**
		 * 
		 */
		private function zoomInButton_mouseUpHandler(event:MouseEvent):void
		{
			this.content.removeEventListener(Event.ENTER_FRAME, this.zoomIn);			
		}

		/**
		 * Scale the map down.
		 */
		private function zoomOut(event:Event):void
		{
			var obj:Object = this.zoomingProxy || this.map;
			var scaleX:Number = obj.contentScaleX;
			var scaleY:Number = obj.contentScaleY;
			
			scaleX -= this.zoomInterval;
			scaleY -= this.zoomInterval;
			this.scaleContent(scaleX <= this.minimumZoom ? this.minimumZoom : scaleX, scaleY <= this.minimumZoom ? this.minimumZoom : scaleY);
		}

		/**
		 * 
		 */
		private function zoomOutButton_mouseDownHandler(event:MouseEvent):void
		{
			this.content.addEventListener(Event.ENTER_FRAME, this.zoomOut);			
		}

		/**
		 * 
		 */
		private function zoomOutButton_mouseUpHandler(event:MouseEvent):void
		{
			this.content.removeEventListener(Event.ENTER_FRAME, this.zoomOut);			
		}

	}	
}