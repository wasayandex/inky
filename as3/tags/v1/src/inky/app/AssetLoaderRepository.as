package inky.app 
{
	import inky.utils.EqualityUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.24
	 *
	 */
	public class AssetLoaderRepository
	{
		private var _assets:Object;
		private static var _instance:AssetLoaderRepository;
		
		/**
		 *
		 */
		public function AssetLoaderRepository()
		{
			if (_instance)
				throw new ArgumentError();
			this._assets = {};
		}
		
		
		/**
		 * 
		 */
		public function containsItem(asset:Object):Boolean
		{
			for each (var item:Object in this._assets)
			{
				if (EqualityUtil.objectsAreEqual(asset, item))
					return true;
			}
			return false;
		}
		
		/**
		 * 
		 */
		public function putLoader(id:String, asset:Object):void
		{
			this._assets[id] = asset;
		}
		
		
		/**
		 * 
		 */
		public function getLoaderById(id:String):Object
		{
			return this._assets[id];
		}


		/**
		 * 
		 */
		public static function getInstance():AssetLoaderRepository
		{
			return _instance || (_instance = new AssetLoaderRepository());
		}
		getInstance();



	}
	
}