package
{
	import flash.display.Sprite;
	import inky.framework.styles.StyleSheet;
	import inky.framework.styles.StyleManager;
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
			myStyleSheet.parseCSS(".com\.blah\.Hey { layout: grid; color: 0xff0000; } crap{hey:    5;}");

			// Display the parsed style sheet.
			trace(myStyleSheet.toCSSString());

			// Wrap the text field to make it styleable.
			var myTextField:StyleableTextField = new StyleableTextField(this.textField);

			// Create a StyleManager, and register the style sheet and object (order shouldn't matter)
			var myStyleManager:StyleManager = new StyleManager();
			myStyleManager.addStyleSheet(myStyleSheet);
			myStyleManager.registerObject(myTextField);
		}



		
	}
	
}