package inky.styles 
{
	import inky.styles.IStyleable;
	import flash.utils.Dictionary;


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
		private var _parent:Object;
		private var _xml:XML;
		



		/**
		 *
		 */
		public function HTMLElement(xml:XML, parent:Object = null)
		{
			this._xml = xml;
			this._parent = parent;
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
			return {}; 
		}



		
	}
}