package inky.cursors.graphics
{
	import flash.display.Sprite;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.19
	 *
	 */
	public class CharacterEncodedCursor extends Sprite
	{
		/**
		 * Maps characters to colors. Use NaN for transparent pixels.
		 */
		protected var colorMap:Object =
		{
			" ": NaN,
			".": 0xffffff,
			"X": 0x000000
		}

		/**
		 *
		 */
		public function CharacterEncodedCursor(source:String, width:int = 16, height:int = 16, x0:int = -8, y0:int = -8, colorMap:Object = null)
		{
			colorMap = colorMap || this.colorMap;

			for (var x:int = 0; x < width; x++)
			{
				for (var y:int = 0; y < height; y++)
				{
					var i:int = y * width + x;
					var char:String = source.charAt(i);
					var color:Number = colorMap[char];

					if (!isNaN(color))
					{
						this.graphics.beginFill(color);
						this.graphics.drawRect(x0 + x, y0 + y, 1, 1);
					}
				}
			}
		}

	}
	
}
