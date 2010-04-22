package 
{
	import RedBox;
	import GreenBox;
	import BlueBox;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import GridLayoutExample;
	import inky.layout.layouts.gridLayout.GridLayout;


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
				var box:DisplayObject = this.createBox();
				this.addChild(box);
			}

			new GridLayout(4).layoutContainer(this);
		}


		/**
		 *	Creates a box.
		 */
		private function createBox():DisplayObject
		{
			var boxClass:Class = [RedBox, GreenBox, BlueBox][Math.floor(Math.random() * 3)];
			return new boxClass();
		}

	}
	
}