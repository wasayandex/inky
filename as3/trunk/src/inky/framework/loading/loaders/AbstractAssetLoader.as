package inky.framework.loading.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import inky.framework.core.Section;
	import inky.framework.events.AssetLoaderEvent;
	import inky.framework.loading.loaders. AssetLoaderBehavior;
	import inky.framework.loading.loaders.IAssetLoader;


	/**
	 *
	 * Defines base functionality for an asset loader class.
	 * AbstractAssetLoader uses the AssetLoaderBehavior decorator for its
	 * functionality.
	 * 
	 * @see inky.framework.loading.loaders. AssetLoaderBehavior
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public class AbstractAssetLoader extends EventDispatcher implements IAssetLoader
	{
		private var _behavior:AssetLoaderBehavior;
		private var _content:Object;


		/**
		 *
		 * Because this class is abstract, the constructor may not be called directly.
		 *
		 */
		public function AbstractAssetLoader()
		{
			//
			// Prevent class from being instantialized.
			//
			if (getQualifiedClassName(this) == 'inky.framework.loading.loaders::AbstractAssetLoader')
			{
				throw new ArgumentError('Error #2012: AbstractAssetLoader$ class cannot be instantiated.');
			}

			this._behavior = new AssetLoaderBehavior(this);
			this._behavior.createLoaderFunction = this.createLoader;
			this._behavior.getLoadArgsFunction = this.getLoadArgs;
			this._behavior.getLoaderInfoFunction = this.getLoaderInfo;
			
			this.createLoader();
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return this._behavior.bytesLoaded;
		}


		/**
		 * @inheritDoc
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
		// protected methods
		//


		/**
		 * @private
		 */
		protected function createLoader():Object
		{
			throw new Error('The AbstractAssetLoader.createLoader method must be overridden by its subclass.');
		}


		/**
		 * @private
		 */
		protected function getLoaderInfo():Object
		{
			throw new Error('The AbstractAssetLoader.getLoaderInfo method must be overridden by its subclass.');
		}


		/**
		 * @private
		 */
		protected function getLoadArgs():Array
		{
			throw new Error('The AbstractAssetLoader.getLoadArgs method must be overridden by its subclass.');
		}


		/**
		 * @private
		 */
		protected function getURLRequest():URLRequest
		{
			return this._behavior.getURLRequest();
		}


		/**
		 * @private
		 */
		protected function relayEvent(e:Event):void
		{
			this._behavior.relayEvent(e);
		}


		/**
		 * @private
		 */
		protected function setContent(content:Object):void
		{
			this._behavior.setContent(content);
		}




	}
}
