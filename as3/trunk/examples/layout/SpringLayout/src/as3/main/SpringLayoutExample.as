package  
{
	import flash.display.Sprite;
	import Window;
	import inky.layout.SpringLayout;
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
		private var _window:Window;


		/**
		 *
		 */
		public function SpringLayoutExample()
		{
			var window:Window = new Window();
			this.addChild(window);
			this._window = window;

			var layout:SpringLayout = new SpringLayout();
			window.layout = layout;

			// Create and add the components.
			var label:TextField = new TextField();
			label.name = "label";
			label.text = "Label: ";

			var textField:TextField = new TextField();
			textField.name = "textField";
			textField.type = TextFieldType.INPUT;
			textField.border = true;
			textField.text = "Text field";

			window.addChild(label);
			window.addChild(textField);


			layout.putConstraint(SpringLayout.WEST, textField,
			                     5,
			                     SpringLayout.WEST, window);

/*
			// Adjust constraints for the label so it's at (5,5).
			layout.putConstraint(SpringLayout.WEST, label,
			                     5,
			                     SpringLayout.WEST, window);
			layout.putConstraint(SpringLayout.NORTH, label,
			                     5,
			                     SpringLayout.NORTH, window);

			// Adjust constraints for the text field so it's at
			// (<label's right edge> + 5, 5).
			layout.putConstraint(SpringLayout.WEST, textField,
			                     5,
			                     SpringLayout.EAST, label);
			layout.putConstraint(SpringLayout.NORTH, textField,
			                     5,
			                     SpringLayout.NORTH, window);

			// Adjust constraints for the content pane: Its right
			// edge should be 5 pixels beyond the text field's right
			// edge, and its bottom edge should be 5 pixels beyond
			// the bottom edge of the tallest component (which we'll
			// assume is textField).
			layout.putConstraint(SpringLayout.EAST, window,
			                     5,
			                     SpringLayout.EAST, textField);
			layout.putConstraint(SpringLayout.SOUTH, window,
			                     5,
			                     SpringLayout.SOUTH, textField);
*/

// Display the window.
LayoutManager.getInstance().invalidateDisplayList(window);

this.addEventListener("enterFrame", enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			this._window.width = this.mouseX;
			this._window.height = this.mouseY;
			LayoutManager.getInstance().invalidateDisplayList(this.getChildAt(0));
		}




	}
}