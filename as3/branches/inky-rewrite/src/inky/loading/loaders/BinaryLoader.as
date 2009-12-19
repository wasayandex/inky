package inky.loading.loaders
{
	import inky.loading.AbstractAssetLoader;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	
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
	public class BinaryLoader extends AbstractAssetLoader
	{
		private var _asset:ByteArray;
		private var _loader:URLLoader;


		/**
		 * @inheritDoc
		 */
		override public function get asset():Object
		{
			return this._asset || (this._asset = new ByteArray());
		}


		/**
		 * @inheritDoc
		 */
		override protected function getLoaderInfo():Object
		{
			return this.getLoader();
		}


		/**
		 * @inheritDoc
		 */
		override protected function getLoader():Object
		{
			if (!this._loader)
			{
				this._loader = new URLLoader();
				this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			return this._loader;
		}



		/**
		 * @inheritDoc
		 */
		override protected function onComplete():void
		{
			var bytes:ByteArray = this._loader.data;
			if (!this._asset)
				this._asset = bytes;
			else
				this._asset.writeBytes(bytes);
			this._asset.position = 0;
		}




	}
	
}