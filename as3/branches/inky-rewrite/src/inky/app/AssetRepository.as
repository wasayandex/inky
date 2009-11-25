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
	public class AssetRepository
	{
		private var _assets:Object;
		private static var _instance:AssetRepository;
		
		/**
		 *
		 */
		public function AssetRepository()
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
		public function putAsset(id:String, asset:Object):void
		{
			this._assets[id] = asset;
		}
		
		
		/**
		 * 
		 */
		public function getAssetById(id:String):Object
		{
			return this._assets[id];
		}


		/**
		 * 
		 */
		public static function getInstance():AssetRepository
		{
			return _instance || (_instance = new AssetRepository());
		}
		getInstance();



	}
	
}