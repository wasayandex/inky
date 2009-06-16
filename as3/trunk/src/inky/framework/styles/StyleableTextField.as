package inky.framework.styles 
{
	import inky.framework.styles.IStyleable;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2009.06.11
	 *
	 */
	public class StyleableTextField implements IStyleable
	{
		private var _textField:TextField;


		/**
		 *
		 */
		public function StyleableTextField(textField:TextField)
		{
			this._textField = textField;
		}


		public function get parent():DisplayObjectContainer
		{
			return this._textField.parent;
		}


		/**
		 *	@inheritDoc
		 */
		public function setStyle(property:String, value:Object):void
		{
			if (property == "color")
				this._textField.textColor = parseInt(String(value));
		}




	}
}