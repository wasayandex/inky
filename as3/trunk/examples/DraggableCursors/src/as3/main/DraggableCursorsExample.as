package
{
	import flash.display.Sprite;
	import inky.cursors.CursorManager;
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.DraggableCursors;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.20
	 *
	 */
	public class DraggableCursorsExample extends Sprite
	{
		/**
		 *
		 */
		public function DraggableCursorsExample()
		{
			// Register the cursors for our application. Note that the order is
			// important because it dictates priority. If you want to use the
			// system cursor for the default or pointer, pass null as the
			// second argument.
			var cursorManager:CursorManager = CursorManager.getInstance(this.stage);
			cursorManager.registerCursor(CursorManager.DEFAULT, "DefaultCursor");
			cursorManager.registerCursor(DraggableCursors.DRAGGABLE_CURSOR, "DraggableCursor");
			cursorManager.registerCursor(CursorManager.POINTER, "PointerCursor");
			cursorManager.registerCursor(DraggableCursors.DRAGGING_CURSOR, "DraggingCursor");			

			// Create draggables and then give them cursors (using the default DraggableCursors ids).
			new DraggableCursors(new Draggable(this.redBox));
			new DraggableCursors(new Draggable(this.blueBox));
			
			// Set the button mode of the button sprite to demonstrate the pointer.
			this.button.buttonMode = true;
		}

	}
	
}