package inky.framework.net
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import inky.framework.events.AssetLoaderEvent;
	import inky.framework.net.AbstractAssetLoader;


	/**
	 *
	 *  Loads a sound asset.
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public class SoundLoader extends AbstractAssetLoader
	{
		private var _loader:Sound;


		/**
		 *
		 * Creates a new SoundLoader instance.
		 * 
		 */
		public function SoundLoader()
		{
			this.createLoader();
		}




		//
		// public methods
		//


		/**
		 * @private
		 */
		override public function loadAsset():void
		{
			super.loadAsset();
			this.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.READY));
		}




		//
		// protected methods
		//


		/**
		 * @private
		 */
		override protected function createLoader():Object
		{
			this._loader = new Sound();
			
			// Configure listeners.
			this._loader.addEventListener(Event.COMPLETE, this.relayEvent);
			this._loader.addEventListener(Event.ID3, this.relayEvent);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.relayEvent);
			this._loader.addEventListener(Event.OPEN, this.relayEvent);
			this._loader.addEventListener(ProgressEvent.PROGRESS, this.relayEvent);
			
			this.setContent(this._loader);
			return this._loader;
		}


		/**
		 * @private
		 */
		override protected function getLoaderInfo():Object
		{
			return this._loader;
		}


		/**
		 * @private
		 */
		override protected function getLoadArgs():Array
		{
			return [this.getURLRequest()];
		}




	}
}
