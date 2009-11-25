package inky.loading 
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import inky.loading.utils.toURLRequest;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.25
	 *
	 */
	public class RuntimeLibraryLoader extends AbstractAssetLoader
	{
		private var _loader:Loader;
		private var _loaderContext:LoaderContext;


		/**
		 * @inheritDoc
		 */
		override public function get asset():Object
		{
			return null;
		}


		/**
		 * @inheritDoc
		 */
		override protected function getLoadArguments():Array
		{
			return [toURLRequest(this.source), this._getLoaderContext()];
		}
		

		/**
		 * @inheritDoc
		 */
		override protected function getLoader():Object
		{
			return this._loader || (this._loader = new Loader());
		}


		/**
		 * @inheritDoc
		 */
		override protected function getLoaderInfo():Object
		{
			return this.getLoader().contentLoaderInfo;
		}


		/**
		 * 
		 */
		private function _getLoaderContext():LoaderContext
		{
			return this._loaderContext || (this._loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain));
		}




	}
}