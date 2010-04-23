package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import inky.utils.IDestroyable;
	import inky.components.map.view.events.MapEvent;
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.DraggableCursors;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import inky.components.map.view.IInteractiveMap;
	import flash.geom.Rectangle;
	import inky.utils.toCoordinateSpace;
	import flash.geom.Point;
	
	/**
	 *
	 *  An IMap view helper that provides basic 'panning' (or 'dragging') functionality.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.12
	 *
	 */
	public class PanningHelper extends MaskedMapViewHelper implements IDestroyable
	{
		protected var draggable:Draggable;
		private var _panningProxy:Object;
		protected var draggableCursors:DraggableCursors;
		
		/**
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 * 
		 * @param panningProxy
		 * 		An object that stands in for the contentContainer in panning manipulation methods.
		 */
		public function PanningHelper(map:IInteractiveMap, layoutValidator:LayoutValidator, mask:DisplayObject, contentContainer:DisplayObjectContainer, panningProxy:Object = null)
		{
			super(map, layoutValidator, mask, contentContainer);
			this.draggable = new Draggable(this.contentContainer, false, this.getDragBounds());
			this.draggableCursors = new DraggableCursors(this.draggable);

			this.panningProxy = panningProxy;
			
			this.mapContent.addEventListener(MapEvent.OVERLAY_UPDATED, this.content_boundsChangeHandler);
			this.mapContent.addEventListener(MapEvent.SCALED, this.content_boundsChangeHandler);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		
		/**
		 *
		 */
		public function get contentX():Number
		{ 
			var contentContainerProxy:Object = this.getContentContainerProxy();
			var value:Number = contentContainerProxy.x;
			if (isNaN(value))
			{
				value =
				contentContainerProxy.x =
				this.contentContainer.x;
			}
			return this.normalizeX(value);
		}
		/**
		 * @private
		 */
		public function set contentX(value:Number):void
		{
			var oldValue:Number = this.contentX;
			if (value != oldValue)
			{
				this.getContentContainerProxy().x = this.normalizeX(value);
				this.invalidateProperty('contentX');
			}
		}
		
		/**
		 *
		 */
		public function get contentY():Number
		{ 
			var contentContainerProxy:Object = this.getContentContainerProxy();
			var value:Number = contentContainerProxy.y;
			if (isNaN(value))
			{
				value =
				contentContainerProxy.y =
				this.contentContainer.y;
			}
			return this.normalizeY(value);
		}
		/**
		 * @private
		 */
		public function set contentY(value:Number):void
		{
			var oldValue:Number = this.contentY;
			if (value != oldValue)
			{
				this.getContentContainerProxy().y = this.normalizeY(value);
				this.invalidateProperty('contentY');
			}
		}

		/**
		 * An object that stands in for the contentContainer in panning manipulation methods.
		 * For example, setting this value to a GTween proxy will let you have easing pretty easily.
		 * 
		 * @default null
		 */
		public function get panningProxy():Object
		{ 
			return this._panningProxy; 
		}
		/**
		 * @private
		 */
		public function set panningProxy(value:Object):void
		{
			this._panningProxy = value;
			this.draggable.positionProxy = value ? new DragProxy(value) : new DragProxy(this.map);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			this.mapContent.removeEventListener(MapEvent.OVERLAY_UPDATED, this.content_boundsChangeHandler);
			this.mapContent.removeEventListener(MapEvent.SCALED, this.content_boundsChangeHandler);
		}
		
		/**
		 * 
		 */
		public function getDragBounds():Rectangle
		{
			return this.calculateDragBounds();
		}
		
		/**
		 * Moves the map content.
		 * 
		 * @param x
		 *     The x coordinate to which the content should be moved
		 * @param y
		 *     The y coordinate to which the content should be moved		 		 		 		 		 		 		 
		 */
		public function moveContent(x:Number, y:Number):void
		{
			var obj:Object = this.panningProxy || this.map;
			obj.contentX = x;
			obj.contentY = y;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			
			/*if (this.panningProxy)
			{
				this.panningProxy.contentX = this.contentX;
				this.panningProxy.contentY = this.contentY;
			}*/
		}

		/**
		 * @inheritDoc
		 */
		override public function validate():void
		{
			var positionIsInvalid:Boolean = this.validationState.propertyIsInvalid("contentX") || this.validationState.propertyIsInvalid("contentY");
			super.validate();
			
			if (positionIsInvalid)
			{
				this.contentContainer.x = this.contentX;
				this.contentContainer.y = this.contentY;
				this.mapContent.dispatchEvent(new MapEvent(MapEvent.MOVED));
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function calculateDragBounds():Rectangle
		{
			var contentBounds:Rectangle = this.contentContainer.getRect(this.mapContent);
			var maskBounds:Rectangle = this.mask.getRect(this.mapContent);
			var bounds:Rectangle = new Rectangle(maskBounds.width - contentBounds.width, maskBounds.height - contentBounds.height, contentBounds.width - maskBounds.width, contentBounds.height - maskBounds.height);
			return bounds;
		}

		/**
		 * 
		 */
		private function content_boundsChangeHandler(event:MapEvent):void
		{
			this.draggable.bounds = this.getDragBounds();
		}

		/**
		 * 
		 */
		private function normalizeX(value:Number):Number
		{
			var dragBounds:Rectangle = this.getDragBounds();
			return Math.max(Math.min(dragBounds.right, value), dragBounds.left);
		}
		
		/**
		 * 
		 */
		private function normalizeY(value:Number):Number
		{
			var dragBounds:Rectangle = this.getDragBounds();
			return Math.max(Math.min(dragBounds.bottom, value), dragBounds.top);
		}

	}
	
}


class DragProxy
{
	private var proxiedObject:Object;
	
	/**
	 *
	 */
	public function DragProxy(proxiedObject:Object)
	{
		this.proxiedObject = proxiedObject;
	}
	
	/**
	 * 
	 */
	public function set x(value:Number):void
	{
		this.proxiedObject.contentX = value;
	}
	/**
	 * @private
	 */
	public function get x():Number
	{
		return this.proxiedObject.contentX;
	}
	
	/**
	 * 
	 */
	public function set y(value:Number):void
	{
		this.proxiedObject.contentY = value;
	}
	/**
	 * @private
	 */
	public function get y():Number
	{
		return this.proxiedObject.contentY;
	}
}