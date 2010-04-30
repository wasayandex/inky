package inky.components.map.view.helpers 
{
	import inky.components.map.view.events.MapEvent;
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.DraggableCursors;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.utils.toCoordinateSpace;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
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

			this.draggable = new Draggable(this.info.contentContainer, false, this.getDragBounds());
			this.draggableCursors = new DraggableCursors(this.draggable);

			this.setPanningProxy(null);

			this.info.map.addEventListener(MapEvent.OVERLAY_UPDATED, this.content_boundsChangeHandler);
			this.info.map.addEventListener(MapEvent.SCALED, this.content_boundsChangeHandler);
		}
		
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
		override protected function validate():void
		{
			var positionIsInvalid:Boolean = this.info.layoutValidator.validationState.propertyIsInvalid("horizontalPan") || this.info.layoutValidator.validationState.propertyIsInvalid("verticalPan");
			super.validate();
			
			if (positionIsInvalid)
			{
				this.info.contentContainer.x = this.horizontalPan * this.draggable.bounds.x;
				this.info.contentContainer.y = this.verticalPan * this.draggable.bounds.y;
				this.info.map.dispatchEvent(new MapEvent(MapEvent.MOVED));
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
				contentContainer.x = Math.max(Math.min(contentContainer.x, bounds.x + bounds.width), bounds.x);
				contentContainer.y = Math.max(Math.min(contentContainer.y, bounds.y + bounds.height), bounds.y);
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


class DragProxy
{
	private var proxiedObject:Object;
	private var draggable:Object;
	
	/**
	 *
	 */
	public function DragProxy(proxiedObject:Object, draggable:Object)
	{
		this.proxiedObject = proxiedObject;
		this.draggable = draggable;
	}
	
	/**
	 * 
	 */
	public function set x(value:Number):void
	{
		this.proxiedObject.horizontalPan = value / this.draggable.bounds.x;
	}
	/**
	 * @private
	 */
	public function get x():Number
	{
trace('returning ' + (this.proxiedObject.horizontalPan * this.draggable.bounds.x));
		return this.proxiedObject.horizontalPan * this.draggable.bounds.x;
	}
	
	/**
	 * 
	 */
	public function set y(value:Number):void
	{
		this.proxiedObject.verticalPan = value / this.draggable.bounds.y;
	}
	/**
	 * @private
	 */
	public function get y():Number
	{
		return this.proxiedObject.verticalPan * this.draggable.bounds.x;
	}
}