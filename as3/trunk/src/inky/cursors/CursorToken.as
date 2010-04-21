package inky.cursors 
{
	import inky.cursors.CursorManager;
	
	/**
	 *
	 *  Represents an active cursor.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.21
	 *
	 */
	public class CursorToken
	{
		public var cursorId:String;
		private var manager:CursorManager;
		
		/**
		 * Used internally to create a CursorToken. This constructor should
		 * not be called by the user; instead use CursorToken.setCursor
		 * 
		 * @see	inky.cursors.CursorManager#setCursor()
		 */
		public function CursorToken(manager:CursorManager, cursorId:String)
		{
			this.manager = manager;
			this.cursorId = cursorId;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Remove the cursor. The current cursor will be reevaluted by the
		 * manager (which may or may not result in the updating of the view,
		 * depending on what other tokens are active).
		 */
		public function remove():void
		{
			this.manager.removeCursor(this);
		}

		
	}
	
}