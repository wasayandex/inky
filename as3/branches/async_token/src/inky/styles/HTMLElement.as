package inky.styles 
{
	import inky.styles.IStyleable;
	import flash.utils.Dictionary;
	import inky.collections.IList;
	import inky.collections.ArrayList;
	import inky.collections.IIterator;
	import inky.styles.StyleObject;


	/**
	 *
	 *  Represents an HTMLElement (or text node)
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
		public function HTMLElement(xml:XML = null, parent:Object = null)
		{
			this._xml = xml;
			this._parent = parent;
		}




		//
		// accessors
		//


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
		public function get className():String
		{
			var attr:XMLList = this._xml.attribute("class");
			return attr.length() ? attr[0] : null;
		}
		
		
		/**
		 *	
		 */
		public function get id():String
		{
// FIXME: why is this necessary? Is this the right
// implementation of an HTMLElement's id?
if (!this._xml)	return null;
			var attr:XMLList = this._xml.attribute("id");
			return attr.length() ? attr[0] : null;
		}


		/**
		 *	The parent element. May not be another HTMLElement. For example, could be a StyleableTextField
		 */	
		public function get parent():Object
		{
			return this._parent;
		}


		/**
		 * @inheritDoc
		 */
		public function get style():Object
		{
			if (!this._style)
				this._style = new StyleObject();
			return this._style; 
		}


		/**
		 *	The type of the element.
		 */
		public function get type():QName
		{
			return this._xml.name();
		}




		//
		// public methods
		//


		/**
		 *	Returns a string version of this element formatted for use with the TextField.htmlText property
		 */
		public function toHTMLString():String
		{
			var str:String;

			if (this._xml && (this._xml.name() == null))
			{
				// text node
				str = this._xml.toString();
			}
// TODO: for things like br tags, something should be rendered here--what other tags?
			else if (this._xml && (this._xml.name() == 'br'))
			{
				str = this._formatHTMLString('');
			}
			else if (this.children.length > 0)
			{
				var contents:String = ""
				for (var i:IIterator = this.children.iterator(); i.hasNext(); )
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




		//
		// private methods
		//


		/**
		 *
		 * Helper function for toHTMLString that adds the necessary tags to the contents.
		 * 	
		 */
		private function _formatHTMLString(contents:String):String
		{
			var openingTags:Array = [];
			var closingTags:Array = [];

			// Font tag.
			var fontAttrs:Array = [];
			for each (var info:Array in [["color", "color"], ["fontSize", "size"], ["fontFamily", "face"], ["letterSpacing", "letterSpacing"]])
			{
				var property:String = info[0];
				var attr:String = info[1];
				var value:String = this.style[property];
		
				if (value != null)
				{
					fontAttrs.push(attr + '="' + value + '"');
				}
			}
	
			if (fontAttrs.length)
			{
				openingTags.push("<font " + fontAttrs.join(" ") + ">");
				closingTags.push("</font>");
			}

			// TextFormat tag
			var formatAttrs:Array = [];
			for each (info in [["lineHeight", "leading"], ["marginLeft", "leftmargin"], ["marginRight", "rightmargin"]])
			{
				property = info[0];
				attr = info[1];
				value = this.style[property];
				
				if (value != null)
				{
					formatAttrs.push(attr + '="' + value + '"');
				}
			}
			
			if (formatAttrs.length)
			{
				openingTags.unshift("<textformat " + formatAttrs.join(" ") + ">");
				closingTags.push("</textformat>");
			}

			// add tags to elements that require them
			// TODO: should this be all tags except ones that are replaced by textformat or font?
			if (this.type && this.type.toString().match(/b|a/))
			{
				openingTags.push(this._xml.toXMLString().replace(/>.*/, '>'));
				closingTags.unshift("</" + this.type.toString() + ">");
			}

			// add line break if this is a block element
			// TODO: what other tags should break by default?
			if ((this.style.display && this.style.display == "block") || (this.type && this.type.toString().match(/p|h\d/)))
			{
				contents += '\n';
			}

			// margins
			if (this.style.marginTop)
			{
				openingTags.unshift("<textformat leading=\"" + this.style.marginTop + "\"><font size=\"0\">\n</font></textformat>");
			}
			
			if (this.style.marginBottom)
			{
				openingTags.unshift("<textformat leading=\"" + this.style.marginBottom + "\"><font size=\"0\">\n</font></textformat>");
			}
			
//trace(openingTags.join("") + contents + closingTags.join(""));
			return openingTags.join("") + contents + closingTags.join("");
		}



		
	}
}