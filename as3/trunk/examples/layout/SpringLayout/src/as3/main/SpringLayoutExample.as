package  
{
	import flash.display.Sprite;
	import Window;
	import inky.layout.layouts.springLayout.SpringLayout;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import inky.layout.LayoutManager;
	import flash.events.Event;


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
	public class SpringLayoutExample extends Sprite
	{
		// This object should be whatever size the window is.
		override public function get width():Number { return this.stage.stageWidth; };
		override public function get height():Number { return this.stage.stageHeight; };

		/**
		 *
		 */
		public function SpringLayoutExample()
		{
			var window:Window = new Window();
			window.name = "window";
			this.addChild(window);

			// Create and add the components.
			/*var label:TextField = new TextField();
			label.name = "label";
			label.text = "Label: ";
			window.addChild(label);*/

			var textField:TextField = new TextField();
			textField.name = "textField";
			textField.type = TextFieldType.INPUT;
			textField.border = true;
			textField.text = "Text field";
			this.addChild(textField);

			var layout:SpringLayout = new SpringLayout();
			layout.putConstraint(SpringLayout.EAST, window,
								SpringLayout.EAST, this,
								0);
			layout.putConstraint(SpringLayout.WEST, textField,
								SpringLayout.WEST, window,
								0);
			layout.layoutContainer(this);
		}





	}
}