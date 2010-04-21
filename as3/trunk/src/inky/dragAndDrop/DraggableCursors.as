package inky.dragAndDrop 
{
	import flash.events.IEventDispatcher;
	import inky.dragAndDrop.events.DragEvent;
	import flash.display.Stage;
	import inky.dragAndDrop.Draggable;
	import inky.cursors.CursorManager;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import inky.cursors.CursorToken;
	
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
		private var draggable:Draggable;
		private var draggingCursorId:String;
		private var draggingCursorToken:CursorToken;
		private var draggableCursorId:String;
		private var draggableCursorToken:CursorToken;
		
		/**
		 *
		 */
		public function DraggableCursors(draggable:Draggable, draggingCursorId:String = "draggingCursor", draggableCursorId:String = "draggableCursor")
		{
			this.draggable = draggable;
			this.draggableCursorId = draggableCursorId;
			this.draggingCursorId = draggingCursorId;
			this.draggable.addEventListener(DragEvent.START_DRAG, this.startDragHandler);
			this.draggable.addEventListener(DragEvent.STOP_DRAG, this.stopDragHandler);
			this.draggable.draggedObject.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
			this.draggable.draggedObject.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
			this.draggable.draggedObject.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
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
				token = CursorManager.getInstance(stage).setCursor(cursorId)
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