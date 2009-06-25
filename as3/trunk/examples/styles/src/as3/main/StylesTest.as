package
{
	import flash.display.Sprite;
	import inky.framework.styles.StyleSheet;
	import inky.framework.styles.StyleManager;
	import inky.framework.styles.IStyleable;
	import inky.framework.styles.StyleableTextField;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.06.11
	 *
	 */
	public class StylesTest extends Sprite
	{
		
		/**
		 *
		 */
		public function StylesTest()
		{
			// Create a new stylesheet.
			var myStyleSheet:StyleSheet = new StyleSheet();
			myStyleSheet.parseCSS(".flash\\.display\\.Stage > .flash\\.display\\.DisplayObjectContainer > .inky\\.framework\\.styles\\.StyleableTextField { color: 0x00ff00; } .special > b { color: 0xff0000; }");

			// Display the parsed style sheet.
			trace(myStyleSheet.toCSSString());

			// Wrap the text field to make it styleable.
			var myTextField:StyleableTextField = new StyleableTextField(this.textField);
			myTextField.htmlText = "Lorem ipsum dolor sit amet, <span class=\"special\">consectetur adipisicing elit, sed do eiusmod <b>tempor</b></span> incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

			// Create a StyleManager, and register the style sheet and object (order shouldn't matter)
			var myStyleManager:StyleManager = new StyleManager();
			myStyleManager.styleSheets.addItem(myStyleSheet);
			myStyleManager.registerObject(myTextField);
		}

		
	}
	
}