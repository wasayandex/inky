package  
{
	import flash.display.Sprite;
	import inky.layout.LayoutEngine;
	import inky.layout.GridLayout;
	import flash.events.Event;
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
	public class LayoutEngineExample extends Sprite
	{
		private var _parentWindow:Window;


		/**
		 *
		 */
		public function LayoutEngineExample()
		{
			this._parentWindow = new Window();
			this.addChild(this._parentWindow);
			
			// Add nested windows.
			for (var i:int = 0; i < 4; i++)
			{
				var nestedWindow:Window = new Window();
				this._parentWindow.addNestedWindow(nestedWindow);
			}
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
		}
		
		
		/**
		 *	
		 */
		private function _mouseMoveHandler(event:MouseEvent):void
		{
			this._parentWindow.width = this.mouseX;
		}




	}
}