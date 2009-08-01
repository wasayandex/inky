package  
{
	import flash.display.Sprite;
	import inky.layout.LayoutComponent;
	import inky.layout.LayoutEngine;

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
		private var _color:uint;


		/**
		 *
		 */
		public function Box(width:Number = 100, height:Number = 100)
		{
			this._color = [0xff0000, 0x00ff00, 0x0000ff][_count++ % 3];
			this.width = width;
			this.height = height;
		}


		private function _redraw(width:Number, height:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(this._color, 0.5);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}



		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			LayoutEngine.getInstance().invalidateDisplayList(this);			
		}




		override public function validateSize():void
		{
trace("validateSize()\t\t" + this.name + "\t\t" + this.width + ", " + this.height);
			this._redraw(this.width, this.height);
		}


		
	}
	
}