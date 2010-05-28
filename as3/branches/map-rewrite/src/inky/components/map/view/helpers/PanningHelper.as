package inky.components.map.view.helpers 
{
	import inky.components.map.view.events.MapEvent;
	import inky.components.map.view.helpers.PanHelper;
	import inky.components.map.view.helpers.DragProxy;
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.DraggableCursors;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.utils.toCoordinateSpace;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
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
	public class PanningHelper extends BaseMapHelper
	{
		protected var draggable:Draggable;
		protected var draggableCursors:DraggableCursors;
		private var _horizontalPan:Number;
		private var _panningProxy:Object;
		private var _verticalPan:Number;
		
		/**
		 *
		 */
		public function PanningHelper()
		{
			this._horizontalPan =
			this._verticalPan = 0;
		}
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get horizontalPan():Number
		{ 
			return this._horizontalPan; 
		}
		/**
		 * @private
		 */
		public function set horizontalPan(value:Number):void
		{
			var oldValue:Number = this._horizontalPan;
			if (value != oldValue)
			{
				this._horizontalPan = value;
				this.info.contentContainer.x = PanHelper.toXPosition(value);
				this.info.map.dispatchEvent(new MapEvent(MapEvent.MOVED));
//				this.invalidateProperty('horizontalPan');
			}
		}
		
		/**
		 *
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
			if (value != this._panningProxy)
			{
				this._panningProxy = value;
				this.setPanningProxy(value);
			}
		}

		/**
		 *
		 */
		public function get verticalPan():Number
		{ 
			return this._verticalPan; 
		}
		/**
		 * @private
		 */
		public function set verticalPan(value:Number):void
		{
			var oldValue:Number = this._verticalPan;
			if (value != oldValue)
			{
				this._verticalPan = value;
				this.info.contentContainer.y = PanHelper.toYPosition(value);
				this.info.map.dispatchEvent(new MapEvent(MapEvent.MOVED));
//				this.invalidateProperty('verticalPan');
			}
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

			if (this.info)
			{
				this.info.map.removeEventListener(MapEvent.OVERLAY_UPDATED, this.content_boundsChangeHandler);
				this.info.map.removeEventListener(MapEvent.SCALED, this.content_boundsChangeHandler);
			}
		}
		
		/**
		 * 
		 */
		public function getDragBounds():Rectangle
		{
			return this.calculateDragBounds();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);

			PanHelper.draggable = 
			this.draggable = new Draggable(this.info.contentContainer, false, this.getDragBounds());
			this.draggableCursors = new DraggableCursors(this.draggable);

			this.setPanningProxy(null);

			this.info.map.addEventListener(MapEvent.OVERLAY_UPDATED, this.content_boundsChangeHandler);
			this.info.map.addEventListener(MapEvent.SCALED, this.content_boundsChangeHandler);
		}
		
		/**
		 * Moves the map so that the provided point rests as close to the center of the visible bounds 
		 * of the map as possible without exceeding the draggable boundaries.
		 * 
		 * @param point
		 * 		The point (in the coordinate space of the placemark container) to move to center.
		 */
		public function moveToCenter(point:Point):void
		{
			var map:DisplayObjectContainer = this.info.map as DisplayObjectContainer;
			var maskBounds:Rectangle = this.info.mask.getRect(map);
			point = toCoordinateSpace(point, this.info.placemarkContainer, map);
			var offset:Point = point.subtract(new Point(maskBounds.right / 2, maskBounds.bottom / 2));
			var dragBounds:Rectangle = this.draggable.bounds;

			var x:Number = Math.max(dragBounds.left, Math.min(dragBounds.right, this.info.contentContainer.x - offset.x));
			var y:Number = Math.max(dragBounds.top, Math.min(dragBounds.bottom, this.info.contentContainer.y - offset.y));

			var target:Object = this.panningProxy || this;
			target.horizontalPan = PanHelper.toHorizontalPan(x);
			target.verticalPan = PanHelper.toVerticalPan(y);
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
			
			/*if (this.panningProxy)
			{
				if (this.panningProxy.contentX != this.contentX)
					this.panningProxy.contentX = this.contentX;

				if (this.panningProxy.contentY != this.contentY)
					this.panningProxy.contentY = this.contentY;
			}*/
		}

		/**
		 * @inheritDoc
		 */
		/*override protected function validate():void
		{
			var positionIsInvalid:Boolean = this.info.layoutValidator.validationState.propertyIsInvalid("horizontalPan") || this.info.layoutValidator.validationState.propertyIsInvalid("verticalPan");
			super.validate();
			
			if (positionIsInvalid)
			{
				this.info.contentContainer.x = PanHelper.toXPosition(this.horizontalPan);
				this.info.contentContainer.y = PanHelper.toYPosition(this.verticalPan);
				this.info.map.dispatchEvent(new MapEvent(MapEvent.MOVED));
			}
		}*/
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function calculateDragBounds():Rectangle
		{
			var map:DisplayObjectContainer = this.info.map as DisplayObjectContainer;
			var contentBounds:Rectangle = this.info.contentContainer.getRect(map);
			var maskBounds:Rectangle = this.info.mask.getRect(map);
			var contentBounds2:Rectangle = this.info.contentContainer.getRect(this.info.contentContainer);

			var p:Point = new Point(this.info.contentContainer.x, this.info.contentContainer.y);
			p = toCoordinateSpace(p, this.info.contentContainer.parent, map);
			p.x = contentBounds.x - p.x;
			p.y = contentBounds.y - p.y;

			var bounds:Rectangle = new Rectangle(
				maskBounds.width - contentBounds.width - p.x,
				maskBounds.height - contentBounds.height - p.y,
				contentBounds.width - maskBounds.width,
				contentBounds.height - maskBounds.height
			);
			return bounds;
		}

		/**
		 * 
		 */
		private function content_boundsChangeHandler(event:MapEvent):void
		{
			var bounds:Rectangle = this.getDragBounds();
			this.draggable.bounds = bounds;
			
			// Correct the position when zoomed.
			if (event.type == MapEvent.SCALED)
			{
				var contentContainer:DisplayObject = this.info.contentContainer;
				this.draggable.positionProxy.x =
			 	contentContainer.x = Math.max(Math.min(contentContainer.x, bounds.x + bounds.width), bounds.x);
				this.draggable.positionProxy.y =
				contentContainer.y = Math.max(Math.min(contentContainer.y, bounds.y + bounds.height), bounds.y);

				/*var target:Object = this.panningProxy || this;
				target.horizontalPan = PanHelper.toHorizontalPan(contentContainer.x);
				target.verticalPan = PanHelper.toVerticalPan(contentContainer.y);*/
			}
		}

		/**
		 * @inheritDoc
		 */
		private function setPanningProxy(value:Object):void
		{
			this.draggable.positionProxy = value ? new DragProxy(value, this.draggable) : new DragProxy(this, this.draggable);
		}

	}
	
}