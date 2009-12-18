package inky.loading 
{
	import inky.loading.IAssetLoader;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import inky.net.utils.toURLRequest;

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
	public class AbstractAssetLoader extends EventDispatcher implements IAssetLoader
	{
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		private var _loaded:Boolean;
		private var _loading:Boolean;
		private var _source:Object;


		/** @inheritDoc */
		public function get bytesTotal():uint { return this._bytesTotal; }

		
		/** @inheritDoc */
		public function get bytesLoaded():uint { return this._bytesLoaded; }


		/** @inheritDoc */
		public function get source():Object { return this._source; }
		/** @private */
		public function set source(value:Object):void { this._source = value; }


		/**
		 * @inheritDoc
		 */
		public function get asset():Object
		{
			throw new Error("You must override get asset()");
		}


		/**
		 * @inheritDoc
		 */
		public function load():void
		{
			if (this._loading || this._loaded)
				return;

			this._loading = true;
			this._loaded = false;

			var loader:Object = this.getLoader();
			var loaderInfo:Object = this.getLoaderInfo();
			
			loaderInfo.addEventListener(Event.COMPLETE, this._completeHandler, false, 0, true);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, this._progressHandler, false, 0, true);
			
			loader.load.apply(null, this.getLoadArguments());
		}



protected function getLoadArguments():Array
{
	return [toURLRequest(this.source)];
}


/**
 * Returns the object with the load() method.
 */
protected function getLoader():Object
{
	throw new Error("You must override getLoader()");
}


/**
 * Returns the objec that dispatches PROGRESS and COMPLETE events.
 */
protected function getLoaderInfo():Object
{
	throw new Error("You must override getLoaderInfo()");
}


/**
 * 
 */
protected function onComplete():void
{
}


		//
		// private methods
		//


		/**
		 * 
		 */
		private function _completeHandler(event:Event):void
		{
			this._loading = false;
			this._loaded = true;
			
			this.onComplete();
			
			// Relay the event.
			this.dispatchEvent(event);
		}


		/**
		 * 
		 */
		private function _progressHandler(event:ProgressEvent):void
		{
			this._bytesLoaded = event.bytesLoaded;
			this._bytesTotal = event.bytesTotal;
			
			// Relay the event.
			this.dispatchEvent(event);
		}
		

		
	}
	
}