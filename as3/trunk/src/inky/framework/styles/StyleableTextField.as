package inky.framework.styles 
{
	import inky.framework.styles.IStyleable;
	import inky.framework.styles.StyleObject;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import inky.framework.binding.events.PropertyChangeEvent;


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
		private var _style:Object;


		/**
		 *
		 */
		public function StyleableTextField(textField:TextField)
		{
			this._textField = textField;

			this._style = new StyleObject();
			this._style.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._styleChangeHandler);
			
		}


		/**
		 * @inheritDoc
		 */
		public function get style():Object
		{
			return this._style;
		}


		public function get parent():DisplayObjectContainer
		{
			return this._textField.parent;
		}


		private function _styleChangeHandler(event:PropertyChangeEvent):void
		{
			if (event.property == "color")
				this._textField.textColor = parseInt(String(event.newValue || 0));
		}




	}
}