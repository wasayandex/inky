package  
{
	import flash.display.Sprite;
	import inky.layout.LayoutEngine;
	import Box;
	import inky.layout.GridLayout;
	import flash.events.Event;


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
		
		/**
		 *
		 */
		public function LayoutEngineExample()
		{
			var layoutEngine:LayoutEngine = LayoutEngine.getInstance(this.stage);
			
			
			var a:Box = new Box(300, 300);
			a.name = "a";
			a.layoutManager = new GridLayout(4);
			
			for (var i:int = 0; i < 5; i++)
			{
				var b:Box = new Box(100, 100);
				a.addChild(b);
			}
			
			this.addChild(a);
			
this.addEventListener(Event.ENTER_FRAME, this._enterFrameHandler);
		}

private function _enterFrameHandler(event:Event):void
{
	this.getChildByName("a").width = this.mouseX;
}

		
	}
	
}