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
	import inky.dragAndDrop.events.DragEvent;
	
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
		private var isPanning:Boolean = false;
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
			if (isNaN(this._horizontalPan))
				this._horizontalPan = PanHelper.toHorizontalPan(this.info.contentContainer.x);

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
				this.invalidateProperty('horizontalPan');
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
			if (isNaN(this._verticalPan))
				this._verticalPan = PanHelper.toVerticalPan(this.info.contentContainer.y);

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
				this.invalidateProperty('verticalPan');
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
				this.info.map.removeEventListener(MapEvent.OVERLAY_UPDATED, this.map_overlayUpdatedHandler);
				this.info.map.removeEventListener(MapEvent.SCALED, this.map_scaledHandler);
			}
			
			if (this.draggable)
			{
				this.draggable.removeEventListener(DragEvent.DRAG, this.draggable_dragHandler);
				this.draggable.removeEventListener(DragEvent.START_DRAG, this.draggable_startDragHandler);
				this.draggable.removeEventListener(DragEvent.STOP_DRAG, this.draggable_stopDragHandler);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);

			PanHelper.draggable = 
			this.draggable = new Draggable(this.info.contentContainer, false, this.info.getDragBounds());
			this.draggable.addEventListener(DragEvent.START_DRAG, this.draggable_startDragHandler);
			this.draggableCursors = new DraggableCursors(this.draggable);

			this.setPanningProxy(null);

			this.info.map.addEventListener(MapEvent.OVERLAY_UPDATED, this.map_overlayUpdatedHandler);
			this.info.map.addEventListener(MapEvent.SCALED, this.map_scaledHandler);
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
			this.info.contentContainer.x =
			this.info.contentContainer.y = 0;
			this._horizontalPan =
			this._verticalPan = NaN;

			var bounds:Rectangle = this.info.getDragBounds();
			this.draggable.bounds = bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function validate():void
		{
			var positionIsInvalid:Boolean = this.info.layoutValidator.validationState.propertyIsInvalid("horizontalPan") || this.info.layoutValidator.validationState.propertyIsInvalid("verticalPan");
			super.validate();
			
			if (positionIsInvalid)
			{
				this.moveToNormalizedPosition(new Point(PanHelper.toXPosition(this.horizontalPan), PanHelper.toYPosition(this.verticalPan)));
				this.info.map.dispatchEvent(new MapEvent(MapEvent.MOVED));
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function draggable_dragHandler(event:DragEvent):void
		{
			this.isPanning = true;
			event.target.removeEventListener(event.type, arguments.callee);
		}
		
		/**
		 * 
		 */
		private function draggable_startDragHandler(event:DragEvent):void
		{
			event.target.addEventListener(DragEvent.DRAG, this.draggable_dragHandler);
			event.target.addEventListener(DragEvent.STOP_DRAG, this.draggable_stopDragHandler);
		}

		/**
		 * 
		 */
		private function draggable_stopDragHandler(event:DragEvent):void
		{
			this.isPanning = false;
			event.target.removeEventListener(event.type, arguments.callee);
		}

		/**
		 * 
		 */
		private function map_overlayUpdatedHandler(event:MapEvent):void
		{
			this.reset();
		}
		
		/**
		 * 
		 */
		private function moveToNormalizedPosition(position:Point = null):void
		{
			if (!position)
				position = new Point(this.info.contentContainer.x, this.info.contentContainer.y);

			var bounds:Rectangle = this.info.getDragBounds();
			this.draggable.bounds = bounds;

			this.info.contentContainer.x = Math.max(Math.min(position.x, bounds.right), bounds.left);
			this.info.contentContainer.y = Math.max(Math.min(position.y, bounds.bottom), bounds.top);
		}

		/**
		 * 
		 */
		private function map_scaledHandler(event:MapEvent):void
		{
			this.moveToNormalizedPosition();
// TODO: Figure out a better way to eliminate the 'jump' that occurs when zooming and panning tweening overlaps. This solution results in panning not tweening while zooming is happening.
if (!this.isPanning)
{
	this._horizontalPan = NaN;
	this._verticalPan = NaN;
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