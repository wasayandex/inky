package  
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public class Ball extends Sprite
	{
		
		/**
		 *
		 */
		public function Ball(color:uint, radius:Number = 10)
		{
			var g:Graphics = this.graphics;
			g.beginFill(color);
			g.drawCircle(-radius/2, -radius/2, radius);
			g.endFill();
		}



		
	}
	
}