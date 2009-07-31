package  
{
	import flash.display.Sprite;
	import inky.layout.LayoutEngine;
	import Box;


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
			var b:Box = new Box(200, 200);
			b.name = "b";
			var c:Box = new Box(50, 50);
			c.name = "c";
			
			this.addChild(a);
			a.addChild(b);
			b.addChild(c);
			
			b.width =
			b.height = 250;
		}



		
	}
	
}