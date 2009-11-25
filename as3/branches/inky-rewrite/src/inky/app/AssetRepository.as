package inky.app 
{
	import inky.loading.IAsset;
	
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
		public function putAsset(id:String, asset:IAsset):void
		{
			this._assets[id] = asset;
		}
		
		
		/**
		 * 
		 */
		public function getAssetById(id:String):IAsset
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