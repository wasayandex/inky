package inky.serialization 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.19
	 *
	 */
	public class ShortNameRegistry
	{
		private static var _instance:ShortNameRegistry;
		private var _types:Object;


		/**
		 *
		 */
		public function ShortNameRegistry()
		{
			if (_instance)
				throw new ArgumentError();
			this._types = {};
		}
		
		
		/**
		 * 
		 */
		public function registerShortName(type:Class, shortName:QName):void
		{
			var nameHash:String = this._getNameHash(shortName);
			this._types[nameHash] = type;
		}
		

		/**
		 * 
		 */
		public function getType(shortName:QName):Class
		{
			var nameHash:String = this._getNameHash(shortName);
			return this._types[nameHash];
		}


		/**
		 * 
		 */
		private function _getNameHash(name:QName):String
		{
			return name.uri + "::" + name.localName;
		}


		/**
		 * 
		 */
		public static function getInstance():ShortNameRegistry
		{
			return _instance || (_instance = new ShortNameRegistry());
		}
		getInstance();



	}
	
}
