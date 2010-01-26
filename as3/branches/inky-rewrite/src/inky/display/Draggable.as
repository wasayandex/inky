package inky.display 
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import inky.display.events.DragEvent;
	import flash.events.EventDispatcher;


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
		private var _sprite:InteractiveObject;
		private var _lockCenter:Boolean;
		private var _offset:Point;
		private var _oldPosition:Point;
		
		
		/**
		 *
		 */
		public function Draggable(sprite:InteractiveObject, lockCenter:Boolean = false)
		{
			this._offset = new Point();
			this.lockCenter = lockCenter;
			this._sprite = sprite;
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
		}




		//
		// accessors
		//


		/**
		 *
		 */
		public function get lockCenter():Boolean { return this._lockCenter; }
		/** @private */
		public function set lockCenter(value:Boolean):void { this._lockCenter = value; }




		//
		// private methods
		//


		/**
		 * 
		 */
		private function _mouseDownHandler(event:MouseEvent):void
		{
			if (this.dispatchEvent(DragEvent.createDragEvent(event, DragEvent.START_DRAG)))
			{
				this._oldPosition = this._sprite.parent.globalToLocal(new Point(event.stageX, event.stageY));
				if (!this.lockCenter)
				{
					this._offset.x = this._sprite.x - this._sprite.parent.mouseX;
					this._offset.y = this._sprite.y - this._sprite.parent.mouseY;
				}
				else
				{
					this._offset.x = 0;
					this._offset.y = 0;
				}
				this._sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
				this._sprite.stage.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			}
		}


		/**
		 * 
		 */
		private function _mouseMoveHandler(event:MouseEvent):void
		{
			var p:Point = this._sprite.parent.globalToLocal(new Point(event.stageX, event.stageY));
			var deltaX:Number = p.x - this._oldPosition.x;
			var deltaY:Number = p.y - this._oldPosition.y;
			var preDragEvent:DragEvent = DragEvent.createDragEvent(event, DragEvent.PRE_DRAG, deltaX, deltaY);

			this.dispatchEvent(preDragEvent)

			if (!preDragEvent.isDefaultPrevented())
			{
				this._sprite.x = this._sprite.parent.mouseX + this._offset.x;
				this._sprite.y = this._sprite.parent.mouseY + this._offset.y;
				this.dispatchEvent(DragEvent.createDragEvent(event, DragEvent.DRAG, deltaX, deltaY));
			}

			this._oldPosition = p;
		}


		/**
		 * 
		 */
		private function _mouseUpHandler(event:MouseEvent):void
		{
			this.dispatchEvent(DragEvent.createDragEvent(event, DragEvent.STOP_DRAG));
			this._sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
			this._sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
		}




	}
	
}