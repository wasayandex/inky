package inky.components.map.view.helpers 
{
	import inky.components.map.view.events.MapEvent;
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.DraggableCursors;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.binding.utils.BindingUtil;
	
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
		private var _verticalPan:Number;
		private var watchers:Array;
		
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

			if (this.watchers)
			{
				while (this.watchers.length)
					this.watchers.pop().unwatch();
			}

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
			
			this.watchers =
			[
				/*BindingUtil.bindProperty(this, "horizontalPan", this.info.map, "horizontalPan"),
				BindingUtil.bindProperty(this, "verticalPan", this.info.map, "verticalPan"),*/
				//BindingUtil.bindSetter(this.setPanningProxy, this.info.map, "panningProxy")
				
			];

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
				this.info.contentContainer.x = this.horizontalPan * (this.draggable.bounds.width - this.draggable.bounds.x);
				this.info.contentContainer.y = this.verticalPan * (this.draggable.bounds.height - this.draggable.bounds.y);
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
			var contentBounds:Rectangle = this.info.contentContainer.getRect(this.info.map as DisplayObjectContainer);
			var maskBounds:Rectangle = this.info.mask.getRect(this.info.map as DisplayObjectContainer);
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
		this.proxiedObject.horizontalPan = value / (this.draggable.bounds.width - this.draggable.bounds.x);
	}
	/**
	 * @private
	 */
	public function get x():Number
	{
		return this.proxiedObject.horizontalPan;
	}
	
	/**
	 * 
	 */
	public function set y(value:Number):void
	{
		this.proxiedObject.verticalPan = value / (this.draggable.bounds.height - this.draggable.bounds.y);
	}
	/**
	 * @private
	 */
	public function get y():Number
	{
		return this.proxiedObject.verticalPan;
	}
}