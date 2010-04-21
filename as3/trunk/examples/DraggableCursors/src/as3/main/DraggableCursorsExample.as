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
		private var cursorManager:CursorManager;
		
		/**
		 *
		 */
		public function DraggableCursorsExample()
		{
			// Register the cursors for our application.
			this.cursorManager = CursorManager.getInstance(this.stage);
			this.cursorManager.registerCursors([
				{id: CursorManager.DEFAULT, cursor: "DefaultCursor"},
				{id: DraggableCursors.DRAGGABLE_CURSOR, cursor: "DraggableCursor"},
				{id: CursorManager.POINTER, cursor: "PointerCursor"},
				{id: DraggableCursors.DRAGGING_CURSOR, cursor: "DraggingCursor"}
			]);

			// Create draggables and then give them cursors.
			new DraggableCursors(new Draggable(this.redBox));
			new DraggableCursors(new Draggable(this.blueBox));
			
			// Set the button mode of the button sprite to demonstrate the pointer.
			this.button.buttonMode = true;
		}

	}
	
}