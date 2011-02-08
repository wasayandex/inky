package inky.dragAndDrop 
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import inky.dragAndDrop.events.DragEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	/**
	 *
	 *  Designed to work even if two Draggable instances use the same sprite instance (as long as they have the same lockCenter value)
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.01.25
	 *
	 */
	public class Draggable implements IEventDispatcher
	{
		private var _bounds:Rectangle;
		private var _eventDispatcher:IEventDispatcher;
		private var _isDraggable:Boolean;
		private var isDragging:Boolean;
		private var _lockCenter:Boolean;
		private var offset:Point;
		private var oldPosition:Point;
		private var sprite:InteractiveObject;
		private var _positionProxy:Object;
		
		/**
		 *
		 */
		public function Draggable(sprite:InteractiveObject, lockCenter:Boolean = false, bounds:Rectangle = null, eventDispatcher:IEventDispatcher = null, positionProxy:Object = null)
		{
			this._isDraggable = true;
			this.eventDispatcher = eventDispatcher || new EventDispatcher(this);
			this.positionProxy = positionProxy;
			this.bounds = bounds;
			this.offset = new Point();
			this.lockCenter = lockCenter;
			this.sprite = sprite;
			this.sprite.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * The object being dragged.
		 */
		public function get draggedObject():InteractiveObject { return this.sprite; }

		/**
		 *
		 */
		public function get bounds():Rectangle { return this._bounds; }
		/** @private */
		public function set bounds(value:Rectangle):void { this._bounds = value; }

		/**
		 * The object to which this instance's IEventDispatcher functions
		 * should be delegated. For example, if you set this value to the
		 * draggedObject, DragEvents will be dispatched on the draggedObject
		 * and listeners will be added to it.
		 */
		public function get eventDispatcher():IEventDispatcher { return this._eventDispatcher; }
		/** @private */
		public function set eventDispatcher(value:IEventDispatcher):void { this._eventDispatcher = value; }

		/**
		 *
		 */
		public function get isDraggable():Boolean
		{ 
			return this._isDraggable; 
		}
		/**
		 * @private
		 */
		public function set isDraggable(value:Boolean):void
		{
			if (value != this._isDraggable)
			{
				this._isDraggable = value;
				this.dispatchEvent(new Event("isDraggableChange"));
			}
		}

		/**
		 *
		 */
		public function get lockCenter():Boolean { return this._lockCenter; }
		/** @private */
		public function set lockCenter(value:Boolean):void { this._lockCenter = value; }
		
		/**
		 *
		 */
		public function get positionProxy():Object { return this._positionProxy; }
		/** @private */
		public function set positionProxy(value:Object):void { this._positionProxy = value; }

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function dispatch(type:String, event:MouseEvent, deltaX:Number = NaN, deltaY:Number = NaN):Boolean
		{
			var dispatched:Boolean = true;
			if (this.willTrigger(type))
				dispatched = this.dispatchEvent(DragEvent.createDragEvent(event, type, deltaX, deltaY));
			return dispatched;
		}

		/**
		 * 
		 */
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (this.isDraggable && this.dispatch(DragEvent.START_DRAG, event))
			{
				this.isDragging = true;

				this.oldPosition = this.sprite.parent.globalToLocal(new Point(event.stageX, event.stageY));
				if (!this.lockCenter)
				{
					this.offset.x = this.sprite.x - this.sprite.parent.mouseX;
					this.offset.y = this.sprite.y - this.sprite.parent.mouseY;
				}
				else
				{
					this.offset.x = 0;
					this.offset.y = 0;
				}
				this.sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
				this.sprite.stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			}
		}

		/**
		 * 
		 */
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var p:Point = new Point(this.sprite.parent.mouseX + this.offset.x, this.sprite.parent.mouseY + this.offset.y);
			
			if (this.bounds)
			{
				p.x = Math.max(Math.min(p.x, this.bounds.x + this.bounds.width), this.bounds.x);
				p.y = Math.max(Math.min(p.y, this.bounds.y + this.bounds.height), this.bounds.y);
			}

			var deltaX:Number = p.x - this.oldPosition.x;
			var deltaY:Number = p.y - this.oldPosition.y;

			if (this.dispatch(DragEvent.PRE_DRAG, event, deltaX, deltaY))
			{
				var target:Object = this.positionProxy || this.sprite;
				target.x = p.x;
				target.y = p.y;
				this.dispatch(DragEvent.DRAG, event, deltaX, deltaY);
			}

			this.oldPosition = p;
		}

		/**
		 * 
		 */
		private function mouseUpHandler(event:MouseEvent):void
		{
			this.isDragging = false;
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.dispatch(DragEvent.STOP_DRAG, event);
		}

		//---------------------------------------
		// Event dispatcher methods
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this.eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			this.eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this.eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			return this.eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			return this.eventDispatcher.willTrigger(type);
		}

	}
	
}