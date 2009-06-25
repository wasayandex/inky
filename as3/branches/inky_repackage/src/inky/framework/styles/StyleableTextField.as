package inky.framework.styles 
{
	import inky.framework.styles.IStyleable;
	import inky.framework.styles.StyleObject;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;


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
		private var _elements:Array;
		private var _htmlText:String;
		private var _html:XML;
		private var _textField:TextField;
		private var _style:Object;

// TODO: Should be IStyleableProxy. Rules should never reference IStyleableProxies. Instead rules that target the proxied object should be applied to this object.
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
		 *
		 */
		public function get elements():IList
		{ 
// TODO: Don't recreate this list every time!
// FIXME: Should this include all descendant elements? Or should it be a tree structure.
			return new ArrayList(this._elements);
		}


		/**
		 *
		 */
		public function get htmlText():String
		{ 
			return this._htmlText; 
		}
		/**
		 * @private
		 */
		public function set htmlText(value:String):void
		{
			this._htmlText = value;
			this._html = new XML("<root>" + value + "</root>");
			
			// Get a list of elements.
			this._elements = this._getElements(this._html, this, []);

			this._textField.htmlText = value;
		}


		private function _getElements(xmlParent:XML, realParent:Object, list:Array):Array
		{
			for each (var el:XML in xmlParent.elements())
			{
				var htmlElement:HTMLElement = new HTMLElement(el, realParent);
				list.push(htmlElement);
				this._getElements(el, htmlElement, list);
			}
			return list;
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