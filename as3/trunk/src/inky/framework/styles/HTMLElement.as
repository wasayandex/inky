package inky.framework.styles 
{
	import inky.framework.styles.IStyleable;
	import flash.utils.Dictionary;
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.IIterator;
	import inky.framework.styles.StyleObject;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.06.24
	 *
	 */
	public class HTMLElement implements IStyleable
	{
		private var _children:IList;
		private var _parent:Object;
		private var _style:Object;
		private var _xml:XML;
		



		/**
		 *
		 */
		public function HTMLElement(xml:XML, parent:Object = null)
		{
			this._xml = xml;
			this._parent = parent;
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


		public function get className():String
		{
			var attr:XMLList = this._xml.attribute("class");
			return attr.length() ? attr[0] : null;
		}
		
		public function get type():QName
		{
			return this._xml.name();
		}

		public function get parent():Object
		{
			return this._parent;
		}
		

		/**
		 *
		 */
		public function get style():Object
		{
			if (!this._style)
				this._style = new StyleObject();
			return this._style; 
		}



public function toHTMLString():String
{
	var str:String;
	var i:IIterator;

	if (this._xml.name() == null)
	{
		// text node
		str = this._xml.toString();
	}
	else if (this.children.length > 0)
	{
		var contents:String = ""
		for (i = this.children.iterator(); i.hasNext(); )
		{
			contents += i.next().toHTMLString();
		}
		str = this._formatHTMLString(contents);
	}
	else
	{
		// If there's no content, there's no reason to include the element in the formatted string at all.
		str = "";
	}

	return str;
}



private function _formatHTMLString(contents:String):String
{
	var openingTags:Array = [];
	var closingTags:Array = [];

	// Font tag.
// TODO: Implement face (font-family)
	if ((this.style.color != null) || (this.style.fontSize != null))
	{
		// TODO: Be smarter about color values.
		var colorAttr:String = this.style.color == null ? "" : ' color="' + this.style.color + '"';
		var sizeAttr:String = this.style.fontSize == null ? "" : ' size="' + this.style.fontSize + '"';
		openingTags.push("<font" + colorAttr + sizeAttr + ">");
		closingTags.push("</font>");
	}
	
	return openingTags.join("") + contents + closingTags.join("");
}





		
	}
}