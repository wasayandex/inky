package
{
	import flash.display.Sprite;
	import inky.styles.StyleSheet;
	import inky.styles.StyleManager;
	import inky.styles.StyleableTextField;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;


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
	public class StylesExample extends Sprite
	{
		private var cssLoader:URLLoader


		/**
		 *
		 */
		public function StylesExample()
		{
			// Load the stylesheet.
			this.cssLoader = new URLLoader();
			this.cssLoader.addEventListener(Event.COMPLETE, this.cssLoader_completeHandler);
			this.cssLoader.load(new URLRequest("example.css"));
		}


		/**
		 *	Applies the styles once the style sheet is loaded.
		 */
		private function cssLoader_completeHandler(event:Event):void
		{
			// Create a new stylesheet.
			var myStyleSheet:StyleSheet = new StyleSheet();
			myStyleSheet.parseCSS(event.currentTarget.data);

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