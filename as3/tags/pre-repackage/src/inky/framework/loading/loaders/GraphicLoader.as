package inky.framework.loading.loaders
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;	
	import flash.utils.getQualifiedClassName;
	import inky.framework.loading.events.AssetLoaderEvent;
	import inky.framework.loading.loaders. AssetLoaderBehavior;
	import inky.framework.loading.loaders.IAssetLoader;


	/**
	 *
	 *  Loads a graphic. The GraphicLoader class is an abstract class that
	 *	is extended by the ImageLoader and SWFLoader classes.
	 *	
	 *	@see inky.framework.loading.loaders.ImageLoader
	 *	@see inky.framework.loading.loaders.SWFLoader
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public class GraphicLoader extends Sprite implements IAssetLoader
	{
		private var _behavior:AssetLoaderBehavior;
		private var _isLoading:Boolean;
		private var _loader:Loader;
		private var _smartLoad:Boolean;


		/**
		 *
		 * Because GraphicLoader is an abstract classs, attempting to
		 * instantiate it will result in an error.
		 *
		 */
		public function GraphicLoader()
		{
			//
			// Prevent class from being instantialized.
			//
			if (getQualifiedClassName(this) == 'inky.framework.loading.loaders::GraphicLoader')
			{
				throw new ArgumentError('Error #2012: GraphicLoader$ class cannot be instantiated.');
			}

			this._isLoading = false;
			this._behavior = new AssetLoaderBehavior(this);
			this._behavior.createLoaderFunction = this._createLoader;
			this._behavior.getLoadArgsFunction = this._getLoadArgs;
			this._behavior.getLoaderInfoFunction = this._getLoaderInfo;
			this._smartLoad = true;
		}




		//
		// accessors
		//


		/**
		 * @copy flash.net.URLLoader#bytesLoaded
		 */
		public function get bytesLoaded():uint
		{
			return this._behavior.bytesLoaded;
		}


		/**
		 * @copy flash.net.URLLoader#bytesTotal
		 */
		public function get bytesTotal():uint
		{
			return this._behavior.bytesTotal;
		}
		

		/**
		 * @inheritDoc
		 */
		public function get content():Object
		{
			return this._behavior.content;
		}


/**
 *	
 */
public function get loaded():Boolean
{
	return this._behavior.loaded;
}


		/**
		 * @inheritDoc
		 */
		public function get preload():Boolean
		{
			return this._behavior.preload;
		}
		/**
		 * @private
		 */
		public function set preload(preload:Boolean):void
		{
			this._behavior.preload = preload;
		}


		/**
		 *
		 * Specifies whether or not the object's <code>load()</code> method
		 * should be automatically called when the object is added to the
		 * stage.
		 *	
		 * @default true
		 *
		 */
		public function get smartLoad():Boolean
		{
			return this._smartLoad;
		}
		/**
		 * @private
		 */
		public function set smartLoad(smartLoad:Boolean):void
		{
			this._smartLoad = smartLoad;
		}


		/**
		 * @inheritDoc
		 */
		public function get source():Object
		{
			return this._behavior.source;
		}
		/**
		 * @private
		 */
		public function set source(source:Object):void
		{
			this._behavior.source = source;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			this._isLoading = false;
			this._behavior.close();
		}


		/**
		 *
		 *	
		 */
		protected function getLoader():Object
		{
			return this._loader;
		}


		/**
		 * @inheritDoc
		 */
		public function load(source:Object = null):void
		{
			this._isLoading = true;
			this._behavior.load.apply(null, arguments);
		}


		/**
		 * @private
		 */
		public function loadAsset():void
		{
			this._isLoading = true;
			this._behavior.loadAsset();
		}


		/**
		 * @inheritDoc
		 */
		public function loadNow(source:Object = null):void
		{
			this._isLoading = true;
			this._behavior.loadNow.apply(null, arguments);
		}


		/**
		 *
		 *	
		 */
		protected function setContent(content:Object):void
		{
			this._behavior.setContent(content);
		}




		//
		// private methods
		//


		/**
		 *
		 * 
		 */
		private function _addedToStageHandler(e:Event):void
		{
			if (this.smartLoad && !this._isLoading && !(this.bytesTotal && (this.bytesLoaded == this.bytesTotal)))
			{
				this.load();
			}
		}


		/**
		 *
		 * 
		 */
		private function _completeHandler(e:Event):void
		{
			this.setContent(this._loader.content);
			this.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.READY));
		}


		/**
		 *
		 * 
		 */
		private function _createLoader():Object
		{
			this._loader = new Loader();
			
			// Configure listeners.
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._completeHandler, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._relayEvent, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this._relayEvent, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(Event.INIT, this._relayEvent, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._relayEvent, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(Event.OPEN, this._relayEvent, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this._relayEvent, false, int.MAX_VALUE, true);
			this._loader.contentLoaderInfo.addEventListener(Event.UNLOAD, this._relayEvent, false, int.MAX_VALUE, true);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler, false, int.MAX_VALUE, true);
			
			this.addChild(this._loader);
			return this._loader;
		}


		/**
		 *
		 */
		private function _getLoaderInfo():Object
		{
			return this._loader ? this._loader.contentLoaderInfo : null;
		}


		/**
		 * 
		 */
		private function _getLoadArgs():Array
		{
			return [this._behavior.getURLRequest(), new LoaderContext(false, ApplicationDomain.currentDomain)];
		}


		/**
		 *
		 */
		private function _relayEvent(e:Event):void
		{
			switch (e.type)
			{
				case Event.COMPLETE:
				case IOErrorEvent.IO_ERROR:
				case Event.UNLOAD:
					this._isLoading = false;
					break;
			}
			this._behavior.relayEvent(e);
		}




	}
}
