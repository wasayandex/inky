package inky.dragAndDrop 
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import inky.dragAndDrop.events.DragEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import inky.utils.getClass;
	import flash.display.DisplayObjectContainer;
	import flash.ui.Mouse;
	import flash.events.Event;
	import inky.display.utils.removeFromDisplayList;
	import flash.display.Stage;
	import inky.dragAndDrop.cursors.DraggingCursor;
	import inky.dragAndDrop.cursors.DraggableCursor;


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
	public class Draggable extends EventDispatcher
	{
		private var _bounds:Rectangle;
		private var currentCursor:DisplayObject;
		private var _draggableCursor:DisplayObject;
		private var draggableCursorOrClass:Object;
		private var _draggingCursor:DisplayObject;
		private var draggingCursorOrClass:Object;
		private var _isDraggable:Boolean;
		private var isDragging:Boolean;
		private var _lockCenter:Boolean;
		private var mouseIsOverTarget:Boolean;
		private var offset:Point;
		private var oldPosition:Point;
		private var sprite:InteractiveObject;
		private var _positionProxy:Object;
		
		
		/**
		 *
		 */
		public function Draggable(sprite:InteractiveObject, lockCenter:Boolean = false, bounds:Rectangle = null, draggingCursorOrClass:* = undefined, draggableCursorOrClass:* = undefined, positionProxy:Object = null)
		{
			if (draggableCursorOrClass === undefined)
				draggableCursorOrClass = DraggableCursor;
			if (draggingCursorOrClass === undefined)
				draggingCursorOrClass = DraggingCursor;
			
			this._isDraggable = true;
			this.draggingCursorOrClass = draggingCursorOrClass;
			this.draggableCursorOrClass = draggableCursorOrClass;
			this.positionProxy = positionProxy;
			this.bounds = bounds;
			this.offset = new Point();
			this.lockCenter = lockCenter;
			this.sprite = sprite;
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);

// TODO: Only add this listener when draggableCursor is provided. (Must add/remove in setter as well)
			sprite.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
			sprite.addEventListener(Event.REMOVED_FROM_STAGE, this.draggedObject_removedFromStageHandler);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * The cursor that will be displayed when mouse is over the object.
		 */
		public function get draggableCursor():DisplayObject
		{
			if (!this._draggableCursor && this.draggableCursorOrClass)
				this._draggableCursor = this.getCursor(this.draggableCursorOrClass);
			return this._draggableCursor; 
		}
		/**
		 * @private
		 */
		public function set draggableCursor(value:DisplayObject):void
		{
			this._draggableCursor = value;
		}

		/**
		 * The object being dragged.
		 */
		public function get draggedObject():InteractiveObject { return this.sprite; }

		/**
		 * The cursor that will be displayed when the object is being dragged.
		 */
		public function get draggingCursor():DisplayObject
		{
			if (!this._draggingCursor && this.draggingCursorOrClass)
				this._draggingCursor = this.getCursor(this.draggingCursorOrClass);
			return this._draggingCursor; 
		}
		/**
		 * @private
		 */
		public function set draggingCursor(value:DisplayObject):void
		{
			this._draggingCursor = value;
		}

		/**
		 *
		 */
		public function get bounds():Rectangle { return this._bounds; }
		/** @private */
		public function set bounds(value:Rectangle):void { this._bounds = value; }

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
			this._isDraggable = value;
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
		private function rollOutHandler(event:Event):void
		{
			this.draggedObject.removeEventListener(MouseEvent.ROLL_OUT, arguments.callee);
			this.draggedObject.stage.removeEventListener(Event.MOUSE_LEAVE, arguments.callee);

			this.mouseIsOverTarget = false;
			if (!this.isDragging)
				this.updateCursor(null);
		}

		/**
		 * 
		 */
		private function draggedObject_removedFromStageHandler(event:Event):void
		{
			this.updateCursor(null);
		}

		/**
		 * 
		 */
		private function cursor_mouseMoveHandler(event:MouseEvent):void
		{
			this.updateCursorPosition(event.stageX, event.stageY);
		}

		/**
		 * 
		 */
		private function updateCursorPosition(x:Number, y:Number):void
		{
			this.currentCursor.x = x;
			this.currentCursor.y = y;
		}

		/**
		 * 
		 */
		private function rollOverHandler(event:MouseEvent):void
		{
			this.mouseIsOverTarget = true;
			this.updateCursor(this.isDragging ? this.draggingCursor : this.draggableCursor);
			this.draggedObject.stage.addEventListener(Event.MOUSE_LEAVE, this.rollOutHandler);
			this.draggedObject.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
		}

		/**
		 * 
		 */
		private function getCursor(cursorOrClass):DisplayObject
		{
			var cursor:DisplayObject;
			if (cursorOrClass is DisplayObject)
			{
				cursor = DisplayObject(cursorOrClass);
			}
			else if (cursorOrClass is String || cursorOrClass is Class)
			{
				var cls:Class = getClass(cursorOrClass);
				if (!cls)
					throw new Error("Couldn't find cursor class " + cursorOrClass);
				cursor = new cls();
				if (!(cursor is DisplayObject))
					throw new Error(cursorOrClass + " does not extend DisplayObject");
			}
			return cursor;
		}

		/**
		 * 
		 */
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (this.isDraggable && this.dispatchEvent(DragEvent.createDragEvent(event, DragEvent.START_DRAG)))
			{
				this.isDragging = true;
				this.updateCursor(this.draggingCursor);

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
			else
			{
				this.updateCursor(null);
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
			var preDragEvent:DragEvent = DragEvent.createDragEvent(event, DragEvent.PRE_DRAG, deltaX, deltaY);

			this.dispatchEvent(preDragEvent)

			if (!preDragEvent.isDefaultPrevented())
			{
				var target:Object = this.positionProxy || this.sprite;
				target.x = p.x;
				target.y = p.y;
				this.dispatchEvent(DragEvent.createDragEvent(event, DragEvent.DRAG, deltaX, deltaY));
			}

			this.oldPosition = p;
		}


		/**
		 * 
		 */
		private function mouseUpHandler(event:MouseEvent):void
		{
			this.isDragging = false;
			this.updateCursor(this.mouseIsOverTarget ? this.draggableCursor : null)
			this.dispatchEvent(DragEvent.createDragEvent(event, DragEvent.STOP_DRAG));
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
		}

		/**
		 * 
		 */
		private function updateCursor(cursor:DisplayObject):void
		{
			var stage:Stage = this.sprite.stage;
			if (cursor && stage)
			{
				if (cursor != this.currentCursor)
				{
					removeFromDisplayList(this.currentCursor);
					this.currentCursor = cursor;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, this.cursor_mouseMoveHandler);
					Mouse.hide();
					stage.addChild(this.currentCursor);
					this.updateCursorPosition(stage.mouseX, stage.mouseY);
					if (cursor is InteractiveObject)
						InteractiveObject(cursor).mouseEnabled = false;
					if (cursor is DisplayObjectContainer)
						DisplayObjectContainer(cursor).mouseChildren = false;
				}
			}
			else
			{
				this.sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.cursor_mouseMoveHandler);
				removeFromDisplayList(this.currentCursor);
				this.currentCursor = null;
				Mouse.show();
			}			
		}


	}
	
}