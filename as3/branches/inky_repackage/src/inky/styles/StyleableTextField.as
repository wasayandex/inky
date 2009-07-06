package inky.styles 
{
	import inky.styles.IStyleable;
	import inky.styles.StyleObject;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.IList;
	import inky.collections.ArrayList;
	import inky.collections.IIterator;
	import inky.styles.HTMLElement;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	import inky.styles.IStyleableProxy;


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
	public class StyleableTextField extends HTMLElement implements IStyleableProxy
	{
		private var _children:IList;
		private var _htmlText:String;
		private var _html:XML;
		private var _invalid:Boolean;
		private var _textField:TextField;
		private var _style:Object;


		/**
		 *
		 */
		public function StyleableTextField(textField:TextField)
		{
			this._textField = textField;
			this.style.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._invalidateContents, false, 0, true);
		}


		/**
		 *	@inheritDoc
		 */
		override public function get className():String
		{
			return getQualifiedClassName(this).replace(/:+/g, ".");
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
// TODO: Should probably UNREGISTER all current descendants here, before creating the new ones.
			// Get a list of children.
			this._createHTMLTree(this._html, this);
			
			this._invalidateContents(null);
		}


		/**
		 *	@inheritDoc
		 */
		override public function get parent():Object
		{
			return this._textField.parent;
		}


		/**
		 *	@inheritDoc
		 */
		override public function get type():QName
		{
// FIXME: What to return here?
			return null;
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _createHTMLTree(xmlParent:XML, realParent:Object):void
		{
			for each (var el:XML in xmlParent.children())
			{
				var htmlElement:HTMLElement = new HTMLElement(el, realParent);
				realParent.children.addItem(htmlElement);
				this._createHTMLTree(el, htmlElement);
				
				// When the element's style changes, update the text field.
				htmlElement.style.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._invalidateContents, false, 0, true);
			}
		}


		/**
		 *	
		 */
		private function _invalidateContents(event:Event):void
		{
			if (event)
				event.currentTarget.removeEventListener(event.type, arguments.callee);
			
			if (!this._invalid)
			{
				this._invalid = true;
				
				if (this._textField.stage)
				{
					this._textField.stage.addEventListener(Event.RENDER, this._renderHandler, false, 0, true);
					this._textField.stage.invalidate();
				}
				else
				{
					this._textField.addEventListener(Event.ADDED_TO_STAGE, this._invalidateContents);
				}
			}
		}


		/**
		 *	
		 */
		private function _renderHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			
			// Update the text field.
			if (this._invalid)
			{
				this._textField.htmlText = this.toHTMLString();
				this._invalid = false;
			}
		}




	}
}