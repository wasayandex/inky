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
			myStyleSheet.parseCSS(".flash\\.display\\.Stage > .flash\\.display\\.DisplayObjectContainer > .inky\\.framework\\.styles\\.StyleableTextField { color: 0x00ff00; }");

			// Display the parsed style sheet.
			trace(myStyleSheet.toCSSString());

			// Wrap the text field to make it styleable.
			var myTextField:StyleableTextField = new StyleableTextField(this.textField);

			// Create a StyleManager, and register the style sheet and object (order shouldn't matter)
			var myStyleManager:StyleManager = new StyleManager();
			myStyleManager.addStyleSheet(myStyleSheet);
			myStyleManager.registerObject(myTextField);
		}



		public function setStyle(property:String, value:Object):void
		{
			if (property == "color")
				this.textField.textColor = parseInt(String(value));
		}
		
	}
	
}