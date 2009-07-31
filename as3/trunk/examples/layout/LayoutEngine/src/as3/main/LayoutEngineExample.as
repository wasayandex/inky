package  
{
	import flash.display.Sprite;
	import inky.layout.LayoutEngine;
	import inky.layout.LayoutComponent;


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
			
			
			var a:LayoutComponent = new LayoutComponent();
			a.name = "a";
			var b:LayoutComponent = new LayoutComponent();
			b.name = "b";
			var c:LayoutComponent = new LayoutComponent();
			c.name = "c";
			
			this.addChild(a);
			a.addChild(b);
			b.addChild(c);
			
			b.width = 500;
			b.height = 500;
		}



		
	}
	
}