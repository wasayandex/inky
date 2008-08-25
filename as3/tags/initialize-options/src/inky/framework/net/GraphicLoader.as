package inky.framework.net
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
	import inky.framework.core.Section;
	import inky.framework.events.AssetLoaderEvent;
	import inky.framework.net.AssetLoaderBehavior;
	import inky.framework.net.IAssetLoader;


	/**
	 *
	 *  Loads a graphic. The GraphicLoader class is an abstract class that
	 *	is extended by the ImageLoader and SWFLoader classes.
	 *	
	 *	@see inky.framework.net.ImageLoader
	 *	@see inky.framework.net.SWFLoader
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
			if (getQualifiedClassName(this) == 'inky.framework.net::GraphicLoader')
			{
				throw new ArgumentError('Error #2012: GraphicLoader$ class cannot be instantiated.');
			}

			this._behavior = new AssetLoaderBehavior(this);
			this._behavior.createLoaderFunction = this._createLoader;
			this._behavior.getLoadArgsFunction = this._getLoadArgs;
			this._behavior.getLoaderInfoFunction = this._getLoaderInfo;
			this._smartLoad = true;
var t = this;
this.addEventListener('removedFromStage', function(e)
{
e.currentTarget.removeEventListener(e.type, arguments.callee);
import flash.utils.setTimeout;
setTimeout(function(){
if (parent) parent.removeChild(t);}, 0);
});
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
			this._behavior.close();
		}


		/**
		 * @inheritDoc
		 */
		public function load(source:Object = null):void
		{
			this._behavior.load.apply(null, arguments);
		}


		/**
		 * @private
		 */
		public function loadAsset():void
		{
			this._behavior.loadAsset();
		}


		/**
		 * @inheritDoc
		 */
		public function loadNow(source:Object = null):void
		{
			this._behavior.loadNow.apply(null, arguments);
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
			if (this.smartLoad)
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
			this._behavior.setContent(this._loader.content);
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
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._completeHandler, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._behavior.relayEvent, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this._behavior.relayEvent, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(Event.INIT, this._behavior.relayEvent, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this._behavior.relayEvent, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(Event.OPEN, this._behavior.relayEvent, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this._behavior.relayEvent, false, 0, true);
			this._loader.contentLoaderInfo.addEventListener(Event.UNLOAD, this._behavior.relayEvent, false, 0, true);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
			
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




	}
}
