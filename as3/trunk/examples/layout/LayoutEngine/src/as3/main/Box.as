package  
{
	import flash.display.Sprite;
	import inky.layout.LayoutComponent;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.31
	 *
	 */
	public class Box extends LayoutComponent
	{
		private var _instanceIndex:int;
		private static var _count:int = 0;


		/**
		 *
		 */
		public function Box(width:Number = 100, height:Number = 100)
		{
			// Draw something so we can see this.
			var color:uint = [0xff0000, 0x00ff00, 0x0000ff][_count++ % 3];
			this.graphics.beginFill(color, 0.5);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}



		
	}
	
}