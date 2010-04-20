package inky.dragAndDrop.cursors
{
	import flash.display.Sprite;
	import flash.display.Bitmap;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.19
	 *
	 */
	public class DraggableCursor extends Sprite
	{
		[Embed(source='draggableCursor.png')]
		private var cursorBitmapClass:Class;
		
		/**
		 *
		 */
		public function DraggableCursor()
		{
			var bmp:Bitmap = new this.cursorBitmapClass();
			bmp.x =
			bmp.y = -8;
			this.addChild(bmp);
		}
		
	}
	
}