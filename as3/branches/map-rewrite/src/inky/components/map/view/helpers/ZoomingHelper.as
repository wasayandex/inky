package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		private var _zoomInButton:InteractiveObject;
		private var _zoomingProxy:Object;
		private var _zoomInterval:Number;
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
		 * @param zoomInterval
		 * 		The amount of 'zoom' change per update.
		 * @see #zoomInterval
		 */
		public function ZoomingHelper(map:IInteractiveMap, layoutValidator:LayoutValidator, mask:DisplayObject, contentContainer:DisplayObjectContainer, overlayContainer:DisplayObjectContainer, zoomingProxy:Object = null, maximumZoom:Number = 2, minimumZoom:Number = 1, zoomInterval:Number = 0.05)
		{
			super(map, layoutValidator, mask, contentContainer);
			
			this.zoomingProxy = zoomingProxy;
			this.maximumZoom = maximumZoom;
			this.minimumZoom = minimumZoom;
			this.zoomInterval = zoomInterval;
			
			this.zoomInButton = this.mapContent.getChildByName("_zoomInButton") as InteractiveObject;
			this.zoomOutButton = this.mapContent.getChildByName("_zoomOutButton") as InteractiveObject;
			
			this.overlayContainer = overlayContainer;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get contentRotation():Number
		{ 
			var contentContainerProxy:Object = this.getContentContainerProxy();
			var value:Number = contentContainerProxy.rotation;
			if (isNaN(value))
			{
				value =
				contentContainerProxy.rotation =
				this.contentContainer.rotation;
			}
			return value;
		}
		/**
		 * @private
		 */
		public function set contentRotation(value:Number):void
		{
			var oldValue:Number = this.contentRotation;
			if (value != oldValue)
			{
				this.getContentContainerProxy().rotation = value;
				this.invalidateProperty('contentRotation');
			}
		}

		/**
		 *
		 */
		public function get contentScaleX():Number
		{ 
			var contentContainerProxy:Object = this.getContentContainerProxy();
			var value:Number = contentContainerProxy.scaleX;
			if (isNaN(value))
			{
				value =
				contentContainerProxy.scaleX =
				this.overlayContainer.scaleX;
			}
			return this.normalizeScale(value);
		}
		/**
		 * @private
		 */
		public function set contentScaleX(value:Number):void
		{
			var oldValue:Number = this.contentScaleX;
			if (value != oldValue)
			{
				this.getContentContainerProxy().scaleX = this.normalizeScale(value);
				this.invalidateProperty('contentScaleX');
			}
		}
		
		/**
		 *
		 */
		public function get contentScaleY():Number
		{ 
			var contentContainerProxy:Object = this.getContentContainerProxy();
			var value:Number = contentContainerProxy.scaleY;
			if (isNaN(value))
			{
				value =
				contentContainerProxy.scaleY =
				this.overlayContainer.scaleY;
			}
			return this.normalizeScale(value);
		}
		/**
		 * @private
		 */
		public function set contentScaleY(value:Number):void
		{
			var oldValue:Number = this.contentScaleY;
			if (value != oldValue)
			{
				this.getContentContainerProxy().scaleY = this.normalizeScale(value);
				this.invalidateProperty('contentScaleY');
			}
		}

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
					oldValue.removeEventListener(MouseEvent.MOUSE_DOWN, this.zoomOutButton_mouseDownHandler);
				if (value)
					value.addEventListener(MouseEvent.MOUSE_DOWN, this.zoomOutButton_mouseDownHandler);

				this._zoomOutButton = value;
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
			this.mapContent.removeEventListener(Event.ENTER_FRAME, this.zoomIn);
			if (this.mapContent.stage)
			{
				this.mapContent.stage.removeEventListener(MouseEvent.MOUSE_UP, this.zoomInButton_mouseUpHandler);
				this.mapContent.stage.removeEventListener(MouseEvent.MOUSE_UP, this.zoomOutButton_mouseUpHandler);
			}
			
			if (this.zoomInButton)
				this.zoomInButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.zoomInButton_mouseDownHandler);

			if (this.zoomOutButton)
				this.zoomOutButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.zoomOutButton_mouseDownHandler);
		}
		
		/**
		 * Scales the content.
		 */
		public function scaleContent(scaleX:Number, scaleY:Number):void
		{
			var obj:Object = this.zoomingProxy || this.map;
			/*obj.contentScaleX = scaleX;
			obj.contentScaleY = scaleY;*/
			scale(obj, [scaleX, scaleY], this.getCenterPoint(), {x: "contentX", y: "contentY", scaleX: "contentScaleX", scaleY: "contentScaleY", rotation: "contentRotation"});
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			
			if (this.zoomingProxy)
			{
 				if (this.zoomingProxy.contentScaleX != this.contentScaleX)
					this.zoomingProxy.contentScaleX = this.contentScaleX;

			 	if (this.zoomingProxy.contentScaleY != this.contentScaleY)
					this.zoomingProxy.contentScaleY = this.contentScaleY;
			}	
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validate():void
		{
			var scaleIsInvalid:Boolean = this.validationState.propertyIsInvalid("contentScaleX") || this.validationState.propertyIsInvalid("contentScaleY");
			super.validate();
			
			if (scaleIsInvalid)
			{
				this.overlayContainer.scaleX = this.contentScaleX;
				this.overlayContainer.scaleY = this.contentScaleY;
				this.mapContent.dispatchEvent(new MapEvent(MapEvent.SCALED));
			}
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function getCenterPoint():Point
		{
			return toCoordinateSpace(new Point(this.mask.width * 0.5, this.mask.height * 0.5), this.mask, this.overlayContainer);
		}
		
		/**
		 * 
		 */
		private function normalizeScale(value:Number):Number
		{
			return Math.min(Math.max(this.minimumZoom, value), this.maximumZoom);
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
			this.mapContent.addEventListener(Event.ENTER_FRAME, this.zoomIn);
			this.mapContent.stage.addEventListener(MouseEvent.MOUSE_UP, this.zoomInButton_mouseUpHandler);
		}

		/**
		 * 
		 */
		private function zoomInButton_mouseUpHandler(event:MouseEvent):void
		{
			this.mapContent.removeEventListener(Event.ENTER_FRAME, this.zoomIn);			
			this.mapContent.stage.removeEventListener(MouseEvent.MOUSE_UP, this.zoomInButton_mouseUpHandler);
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
			this.mapContent.addEventListener(Event.ENTER_FRAME, this.zoomOut);			
			this.mapContent.stage.addEventListener(MouseEvent.MOUSE_UP, this.zoomOutButton_mouseUpHandler);
		}

		/**
		 * 
		 */
		private function zoomOutButton_mouseUpHandler(event:MouseEvent):void
		{
			this.mapContent.removeEventListener(Event.ENTER_FRAME, this.zoomOut);			
			this.mapContent.stage.removeEventListener(MouseEvent.MOUSE_UP, this.zoomOutButton_mouseUpHandler);
		}

	}	
}