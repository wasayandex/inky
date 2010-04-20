package inky.dragAndDrop.cursors 
{
	import flash.display.Sprite;
	import inky.dragAndDrop.cursors.CharacterEncodedCursor;

	/**
	 *
	 *  The standard dragging cursors. The cursors are stored in a kind of
	 *  ascii art. We could use PNGs and Embed tags, but that would require
	 *  the Flex SDK.
	 * 
	 * @see	inky.dragAndDrop.cursors.CharacterEncodedCursor
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.19
	 *
	 */
	public class StandardDragCursors
	{
		/**
		 * The "encoded" dragging cursor.
		 * @see	inky.dragAndDrop.cursors.CharacterEncodedCursor
		 */
		private static const DRAGGING_CURSOR_SOURCE:String =
		  "                "
		+ "                "
		+ "                "
		+ "                "
		+ "    XX XX XX    "
		+ "   X..X..X..XX  "
		+ "   X........X.X "
		+ "    X.........X "
		+ "   XX.........X "
		+ "  X...........X "
		+ "  X...........X "
		+ "  X..........X  "
		+ "   X.........X  "
		+ "    X.......X   "
		+ "     X......X   "
		+ "     X......X   ";
		
		/**
		 * The "encoded" draggable cursor.
		 * @see	inky.dragAndDrop.cursors.CharacterEncodedCursor
		 */
		private static const DRAGGABLE_CURSOR_SOURCE:String =
		  "       XX       "
		+ "   XX X..XXX    "
		+ "  X..XX..X..X   "
		+ "  X..XX..X..X X "
		+ "   X..X..X..XX.X"
		+ "   X..X..X..X..X"
		+ " XXXX.......X..X"
		+ "X..XX..........X"
		+ "X...X.........X "
		+ " X............X "
		+ "  X...........X "
		+ "  X..........X  "
		+ "   X.........X  "
		+ "    X.......X   "
		+ "     X......X   "
		+ "     X......X   ";

		private static var _draggableCursor:Sprite;
		private static var _draggingCursor:Sprite;
		
		/**
		 * The cursor to show when the mouse is over a draggable object.
		 */
		public static function get draggableCursor():Sprite
		{
			if (!_draggableCursor)
				_draggableCursor = new CharacterEncodedCursor(DRAGGABLE_CURSOR_SOURCE);
			return _draggableCursor;
		}
		
		/**
		 * The cursor to show when dragging.
		 */
		public static function get draggingCursor():Sprite
		{
			if (!_draggingCursor)
				_draggingCursor = new CharacterEncodedCursor(DRAGGING_CURSOR_SOURCE);
			return _draggingCursor;
		}

	}
	
}