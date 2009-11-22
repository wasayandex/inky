package 
{
	import RedBox;
	import GreenBox;
	import BlueBox;
	import flash.display.DisplayObjectContainer;
	import inky.layout.GridLayout;
	import flash.display.Sprite;
	import flash.display.DisplayObject;


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
	public class GridLayoutExample extends Sprite
	{
		
		/**
		 *
		 */
		public function GridLayoutExample()
		{
			// Add some squares.
			for (var i:int = 0; i < 15; i++)
			{
				var box:DisplayObject = this._createBox();
				this.addChild(box);
			}

			var layout:GridLayout = new GridLayout(4);
			layout.register(this);
		}


		/**
		 *	Creates a box.
		 */
		private function _createBox():DisplayObject
		{
			var boxClass:Class;
			var randomNumber:int = Math.floor(Math.random() * 3);
			switch (randomNumber)
			{
				case 0:
				{
					boxClass = RedBox;
					break;
				}
				case 1:
				{
					boxClass = GreenBox;
					break;
				}
				case 2:
				{
					boxClass = BlueBox;
					break;
				}
			}
			
			return new boxClass();
		}



		
	}
	
}