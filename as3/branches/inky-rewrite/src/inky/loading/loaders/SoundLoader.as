package inky.loading.loaders
{
	import inky.loading.AbstractAssetLoader;
	import flash.media.Sound;
	
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
	public class SoundLoader extends AbstractAssetLoader
	{
		private var _asset:Sound;


		/**
		 * @inheritDoc
		 */
		override public function get asset():Object
		{
			return this._asset || (this._asset = new Sound());
		}


		/**
		 * @inheritDoc
		 */
		override protected function getLoaderInfo():Object
		{
			return this.asset;
		}


		/**
		 * @inheritDoc
		 */
		override protected function getLoader():Object
		{
			return this.asset;
		}




	}
	
}