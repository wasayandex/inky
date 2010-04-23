package  
{
	import flash.display.Sprite;
	import inky.cursors.CursorManager;
	import inky.cursors.CursorToken;
	import flash.events.Event;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.23
	 *
	 */
	public class CursorManagerExample extends Sprite
	{
		private var cursorManager:CursorManager;
		private var cursor1Token:CursorToken;
		private var cursor2Token:CursorToken;
		
		private static const CUSTOM_CURSOR_1:String = "customCursor1";
		private static const CUSTOM_CURSOR_2:String = "customCursor2";
		
		/**
		 *
		 */
		public function CursorManagerExample()
		{
			// Create the cursor manager and register our custom cursors (at
			// the highest priority).
			this.cursorManager = CursorManager.getInstance(this.stage);
			this.cursorManager.registerCursor(CUSTOM_CURSOR_1, CustomCursor1, false);
			this.cursorManager.registerCursor(CUSTOM_CURSOR_2, CustomCursor2, true);

			this.cursor1Button.addEventListener(Event.CHANGE, this.cursor1Button_clickHandler);
			this.cursor2Button.addEventListener(Event.CHANGE, this.cursor2Button_clickHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function cursor1Button_clickHandler(event:Event):void
		{
			if (event.currentTarget.selected && !this.cursor1Token)
			{
				this.cursor1Token = this.cursorManager.setCursor(CUSTOM_CURSOR_1);
			}
			else if (!event.currentTarget.selected && this.cursor1Token)
			{
				this.cursor1Token.remove();
				this.cursor1Token = null;
			}
		}

		/**
		 * 
		 */
		private function cursor2Button_clickHandler(event:Event):void
		{
			if (event.currentTarget.selected && !this.cursor2Token)
			{
				this.cursor2Token = this.cursorManager.setCursor(CUSTOM_CURSOR_2);
			}
			else if (!event.currentTarget.selected && this.cursor2Token)
			{
				this.cursor2Token.remove();
				this.cursor2Token = null;
			}
		}
		
	}
	
}