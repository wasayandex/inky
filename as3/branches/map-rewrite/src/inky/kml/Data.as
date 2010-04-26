package inky.kml 
{
	import inky.kml.kml;
	import inky.utils.IEquatable;
	import inky.utils.EqualityUtil;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.26
	 *
	 */
	public class Data implements IEquatable
	{
		private var _xml:XML;

		/**
		 *
		 */
		public function Data(xml:XML)
		{
			this._xml = xml;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get displayName():String
		{
			var displayName:String = this.xml.displayName;
			if (!displayName.length)
				displayName = this.name;
			return displayName;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return this.xml.attribute('name').toString();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get value():String
		{
			return this.xml.kml::value.toString();
		}

		/**
		 * @inheritDoc
		 */
		public function get xml():XML
		{
			return this._xml;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return this.value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function valueOf():Object
		{
			return this.value;
		}
		
		//---------------------------------------
		// IEQUATABLE IMPLEMENTATION
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function equals(object:Object):Boolean
		{
			if (object is Data)
				return EqualityUtil.propertiesAreEqual(this, object);
			else
				return EqualityUtil.objectsAreEqual(this, object);
		}

	}
	
}