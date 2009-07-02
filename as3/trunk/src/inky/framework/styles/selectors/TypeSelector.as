package inky.framework.styles.selectors 
{
	import inky.framework.styles.selectors.ISelector;
	import inky.framework.styles.HTMLElement;


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
	public class TypeSelector implements ISelector
	{
		private var _type:QName;


		/**
		 *	
		 */
		public function TypeSelector(type:Object)
		{
			if (type is String)
				this._type = new QName(null, type);
			else if (type is QName)
				this._type = type as QName;
			else
				throw new ArgumentError();
		}


		/**
		 *	@inheritDoc
		 */
		public function get specificity():uint
		{
			return 1;
		}



		/**
		 * @inheritDoc
		 */
		public function matches(object:Object):Boolean
		{
			var matches:Boolean = false;
			
			if (object is HTMLElement)
			{
// FIXME: How are you actually supposed to compare QNames? The docs say a QName with a null uri should match any, but that doesn't seem to be the case.
				var elementType:QName = HTMLElement(object).type;

				if (elementType)
				{
					if ((this._type.uri == null) || (elementType.uri == null))
						matches = this._type.localName == elementType.localName;
					else
						matches = (this._type.uri == elementType.uri) && (this._type.localName == elementType.localName);
				}
			}
			else
			{
// TODO: What do type selectors mean for non-HTMLElements?
			}
			return matches;
		}


		/**
		 *	@inheritDoc
		 */
		public function toCSSString():String
		{
// TODO: Support namespaces
			return this._type.localName;
		}



	}
}