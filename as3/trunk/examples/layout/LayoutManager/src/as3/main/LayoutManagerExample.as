package  
{
	import flash.display.Sprite;
	import Window;
	import flash.events.MouseEvent;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.07.30
	 *
	 */
	public class LayoutManagerExample extends Sprite
	{
		private var parentWindow:Window;


		/**
		 *
		 */
		public function LayoutManagerExample()
		{
			this.parentWindow = new Window();
			this.addChild(this.parentWindow);
			
			// Add nested windows.
			for (var i:int = 0; i < 4; i++)
			{
				var nestedWindow:Window = new Window();
				this.parentWindow.addNestedWindow(nestedWindow);
			}
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		}
		
		
		/**
		 *	
		 */
		private function mouseMoveHandler(event:MouseEvent):void
		{
			this.parentWindow.width = this.mouseX;
		}




	}
}