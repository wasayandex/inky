package inky.dragAndDrop 
{
	import inky.dragAndDrop.events.DragEvent;
	import flash.display.Stage;
	import inky.dragAndDrop.Draggable;
	import inky.cursors.CursorManager;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import inky.cursors.CursorToken;
	import inky.cursors.graphics.StandardDragCursors;
	import inky.utils.UIDUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.21
	 *
	 */
	public class DraggableCursors
	{
		public static const DRAGGING_CURSOR:String = "draggingCursor";
		public static const DRAGGABLE_CURSOR:String = "draggableCursor";
		private var cursorsToRegister:Object;
		private var draggable:Draggable;
		private var _draggingCursorId:String;
		private var draggingCursorToken:CursorToken;
		private var _draggableCursorId:String;
		private var draggableCursorToken:CursorToken;
		private var isInitialized:Boolean;
		
		/**
		 * Creates new cursor identity for a draggable object.
		 * @param	draggable	 The draggable to get cursors
		 * @param	draggingCursorIdOrCursor	 Either a cursor id or a cursor display object (or class) to use for the dragging state. If a display object is provided, a cursor id will be automatically generated and the display object will be registered with it.
		 * @param	draggableCursorIdOrCursor	 Either a cursor id or a cursor display object (or class) to use for the over state. If a display object is provided, a cursor id will be automatically generated and the display object will be registered with it.
		 */
		public function DraggableCursors(draggable:Draggable, draggingCursorIdOrCursor:Object = "draggingCursor", draggableCursorIdOrCursor:Object = "draggableCursor")
		{
			this.draggable = draggable;
			var draggableCursor:Object;
			var draggingCursor:Object;
			
			if (draggableCursorIdOrCursor is String)
			{
				this.draggableCursorId = String(draggableCursorIdOrCursor);
			}
			else
			{
				this.draggableCursorId = "inky.dragAndDrop.DraggableCursors:draggable:" + UIDUtil.getUID(this);
				draggableCursor = draggableCursorIdOrCursor;
			}

			if (draggingCursorIdOrCursor is String)
			{
				this.draggingCursorId = String(draggingCursorIdOrCursor);
			}
			else
			{
				this.draggingCursorId = "inky.dragAndDrop.DraggableCursors:dragging:" + UIDUtil.getUID(this);
				draggingCursor = draggingCursorIdOrCursor;
			}

			this.cursorsToRegister = {
				dragging: {
					id: this.draggingCursorId,
					cursor: draggingCursor || StandardDragCursors.draggingCursor
				},
				draggable: {
					id: this.draggableCursorId,
					cursor: draggableCursor || StandardDragCursors.draggableCursor
				}
			}

			this.draggable.addEventListener(DragEvent.START_DRAG, this.startDragHandler);
			this.draggable.addEventListener(DragEvent.STOP_DRAG, this.stopDragHandler);
			this.draggable.draggedObject.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
			this.draggable.draggedObject.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
			this.draggable.draggedObject.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get draggableCursorId():String
		{ 
			return this._draggableCursorId; 
		}
		/**
		 * @private
		 */
		public function set draggableCursorId(value:String):void
		{
			this._draggableCursorId = value;
		}
		
		/**
		 *
		 */
		public function get draggingCursorId():String
		{ 
			return this._draggingCursorId; 
		}
		/**
		 * @private
		 */
		public function set draggingCursorId(value:String):void
		{
			this._draggingCursorId = value;
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function initialize(stage:Stage):void
		{
			var cursorManager:CursorManager = CursorManager.getInstance(stage);
			var pointerPriority:int = cursorManager.getPriority(CursorManager.POINTER);
			if (pointerPriority == -1)
				pointerPriority == 0;

			// Register the custom cursor with the cursor id (if one is not already registered)
			if (cursorManager.getPriority(this.cursorsToRegister.dragging.id) == -1)
				cursorManager.registerCursor(this.cursorsToRegister.dragging.id, this.cursorsToRegister.dragging.cursor, pointerPriority + 1);
			if (cursorManager.getPriority(this.cursorsToRegister.draggable.id) == -1)
				cursorManager.registerCursor(this.cursorsToRegister.draggable.id, this.cursorsToRegister.draggable.cursor, pointerPriority);

			this.cursorsToRegister = null;
			this.isInitialized = true;
		}
		
		/**
		 * 
		 */
		private function removedFromStageHandler(event:Event):void
		{
			if (this.draggingCursorToken)
				this.draggingCursorToken.remove();
			if (this.draggableCursorToken)
				this.draggableCursorToken.remove();
			this.draggingCursorToken = null;
			this.draggableCursorToken = null;
		}

		/**
		 * 
		 */
		private function rollOutHandler(event:MouseEvent):void
		{
			if (this.draggableCursorToken)
			{
				this.draggableCursorToken.remove();
				this.draggableCursorToken = null;
			}
		}

		/**
		 * 
		 */
		private function rollOverHandler(event:MouseEvent):void
		{
			if (this.draggableCursorToken)
				this.draggableCursorToken.remove();
			if (this.draggable.isDraggable)
				this.draggableCursorToken = this.setCursor(this.draggableCursorId);
		}

		/**
		 * 
		 */
		private function setCursor(cursorId:String):CursorToken
		{
			var stage:Stage = (this.draggable && this.draggable.draggedObject && this.draggable.draggedObject.stage) as Stage;
			var token:CursorToken;
			if (stage)
			{
				if (!this.isInitialized)
					this.initialize(stage);
				token = CursorManager.getInstance(stage).setCursor(cursorId)
			}
			return token;
		}

		/**
		 * 
		 */
		private function stopDragHandler(event:DragEvent):void
		{
			if (this.draggingCursorToken)
			{
				this.draggingCursorToken.remove();
				this.draggingCursorToken = null;
			}
		}

		/**
		 * 
		 */
		private function startDragHandler(event:DragEvent):void
		{
			if (this.draggingCursorToken)
				this.draggingCursorToken.remove();
			if (this.draggable.isDraggable)
				this.draggingCursorToken = this.setCursor(this.draggingCursorId);
		}
		
	}
	
}