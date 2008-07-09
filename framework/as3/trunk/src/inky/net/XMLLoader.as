package inky.net
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import inky.events.AssetLoaderEvent;
	import inky.net.AbstractAssetLoader;


	/**
	 *
	 *  Loads an external XML file.
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public class XMLLoader extends AbstractAssetLoader
	{
		private var _loader:URLLoader;




		//
		// private methods
		//


		/**
		 *
		 * Sets the content once the data has been loaded.
		 * 
		 */
		private function _completeHandler(e:Event):void
		{
			this.setContent(new XML(e.currentTarget.data));
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
			this._loader = new URLLoader();

			// Configure listeners
			this._loader.addEventListener(Event.COMPLETE, this._completeHandler);
			this._loader.addEventListener(Event.COMPLETE, this.relayEvent);
			this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.relayEvent);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.relayEvent);
			this._loader.addEventListener(Event.OPEN, this.relayEvent);
			this._loader.addEventListener(ProgressEvent.PROGRESS, this.relayEvent);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.relayEvent);

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
