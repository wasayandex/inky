package inky.framework.styles 
{
	import inky.framework.styles.IStyleable;
	import inky.framework.styles.StyleObject;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.IIterator;


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
		private var _children:IList;
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
		public function get children():IList
		{ 
			if (!this._children)
				this._children = new ArrayList();
			return this._children;
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
			
			// Get a list of children.
			this._createHTMLTree(this._html, this);
			
			this._updateTextField(null);
		}


		private function _createHTMLTree(xmlParent:XML, realParent:Object):void
		{
			for each (var el:XML in xmlParent.children())
			{
				var htmlElement:HTMLElement = new HTMLElement(el, realParent);
				realParent.children.addItem(htmlElement);
				this._createHTMLTree(el, htmlElement);
				
				// When the element's style changes, update the text field.
				htmlElement.style.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._updateTextField, false, 0, true);
			}
		}



		private function _updateTextField(event:PropertyChangeEvent):void
		{
// TODO: Wait for render event.
			this._textField.htmlText = this.toHTMLString();
		}


public function toHTMLString():String
{
	var str:String = "";
	for (var i:IIterator = this.children.iterator(); i.hasNext(); )
	{
		str += i.next().toHTMLString();
	}
	return str;
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