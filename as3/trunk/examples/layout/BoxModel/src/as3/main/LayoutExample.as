package  
{
	import flash.display.Sprite;
	import inky.layout.layouts.boxModel.BoxModelLayout;
	import inky.layout.layouts.boxModel.BoxModelLayoutConstraints;
	import inky.layout.layouts.boxModel.BoxModelLayoutPosition;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.27
	 *
	 */
	public class LayoutExample extends Sprite
	{
	
		/**
		 *
		 */
		public function LayoutExample()
		{
			var boxModelLayout:BoxModelLayout = new BoxModelLayout();

			// Set the constraints
			boxModelLayout.setConstraints(this.redBox, new BoxModelLayoutConstraints({position: BoxModelLayoutPosition.ABSOLUTE, top: 10, left: 10}));
			boxModelLayout.setConstraints(this.greenBox, new BoxModelLayoutConstraints({position: BoxModelLayoutPosition.ABSOLUTE, top: 20, left: 20}));
			boxModelLayout.setConstraints(this.blueBox, new BoxModelLayoutConstraints({position: BoxModelLayoutPosition.ABSOLUTE, top: 30, left: 30}));
			
			boxModelLayout.layoutContainer(this);
		}
		
	}
	
}