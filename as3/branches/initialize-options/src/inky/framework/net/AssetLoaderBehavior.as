package inky.framework.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import inky.framework.core.Section;
	import inky.framework.events.AssetLoaderEvent;
	import inky.framework.events.PropertyChangeEvent;
	import inky.framework.net.IAssetLoader;


	/**
	 *
	 *  A decorator that encapsulates the functionality of an asset loader.
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public class AssetLoaderBehavior
	{
		private var _content:Object;
		private var _createLoaderFunction:Function;
		private var _getLoadArgsFunction:Function;
		private var _getLoaderInfoFunction:Function;
		private var _loader:Object;
		private var _preload:Boolean;
		private var _request:URLRequest;
		private var _section:Object;
		private var _source:Object;
		private var _target:IAssetLoader;


		/**
		 *
		 * Decorates an IAssetLoader. The createLoaderFunction,
		 * getLoadArgsFunction, and getLoaderInfoFunction properties must also
		 * be set.
		 *
		 */
		public function AssetLoaderBehavior(target:IAssetLoader)
		{
			this._preload = false;
			this._target = target;
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get content():Object
		{
			return this._content;
		}


		/**
		 *
		 * 
		 */
		public function get createLoaderFunction():Function
		{
			return this._createLoaderFunction;
		}
		/**
		 * @private
		 */
		public function set createLoaderFunction(createLoaderFunction:Function):void
		{
			this._createLoaderFunction = createLoaderFunction;
		}


		/**
		 *
		 * 
		 */
		public function get getLoadArgsFunction():Function
		{
			return this._getLoadArgsFunction;
		}
		/**
		 * @private
		 */
		public function set getLoadArgsFunction(getLoadArgsFunction:Function):void
		{
			this._getLoadArgsFunction = getLoadArgsFunction;
		}


		/**
		 *
		 * 
		 */
		public function get getLoaderInfoFunction():Function
		{
			return this._getLoaderInfoFunction;
		}
		/**
		 * @private
		 */
		public function set getLoaderInfoFunction(getLoaderInfoFunction:Function):void
		{
			this._getLoaderInfoFunction = getLoaderInfoFunction;
		}


		/**
		 * @copy flash.net.URLLoader#bytesLoaded
		 */
		public function get bytesLoaded():uint
		{
			var loaderInfo:Object = this.getLoaderInfoFunction();
			return loaderInfo ? loaderInfo.bytesLoaded : 0;
		}


		/**
		 * @copy flash.net.URLLoader#bytesTotal
		 */
		public function get bytesTotal():uint
		{
			var loaderInfo:Object = this.getLoaderInfoFunction();
			return loaderInfo ? loaderInfo.bytesTotal : 0;
		}


		/**
		 *
		 * Specifies whether the Asset should be preloaded by the Application
		 * before its containing section is created.
		 * 
		 * @default false
		 * 
		 */
		public function get preload():Boolean
		{
			return this._preload;
		}
		/**
		 * @private
		 */
		public function set preload(preload:Boolean):void
		{
			this._preload = preload;
		}


		/**
		 *
		 * The file to load. URLs (Strings) and URLRequests are valid values.
		 *
		 * @default null
		 * 
		 */
		public function get source():Object
		{
			return this._source;
		}
		/**
		 * @private
		 */
		public function set source(source:Object):void
		{
			if (source is String)
			{
				this.getURLRequest().url = source as String;
			}
			else if (source is URLRequest)
			{
				this._request = source as URLRequest;
			}
			else
			{
				throw new Error('An AssetLoader\'s source property may only be set to a String or URLRequest');
			}
			this._source = source;
		}




		//
		// public methods
		//


		/**
		 * @copy flash.net.URLLoader#close()
		 */
		public function close():void
		{
			// If this loader belongs to a section, delegate the loading to it.
			var section:Object = Section.getSection(this._target);
			if (section)
			{
				section.cancelFetchAsset(this._target);
			}
			else if (this._loader)
			{
				this._loader.close();
			}
			else
			{
				throw new Error('Error #2029: This URLStream object does not have a stream opened.');
			}
		}


		/**
		 *
		 */
		public function getURLRequest():URLRequest
		{
			if (!this._request)
			{
				this._request = new URLRequest();
			}
			return this._request;
		}


		/**
		 *
		 * 	
		 */
		public function load(source:Object = null):void
		{
			this._load(source, false);
		}


		/**
		 * @private	
		 */
		public function loadAsset():void
		{
			var loader:Object = this._getLoader();
			var loadArgs:Array = this.getLoadArgsFunction();
			loader.load.apply(null, loadArgs);
		}


		/**
		 *
		 * 
		 * 
		 */
		public function loadNow(source:Object = null):void
		{
			this._load(source, true);
		}


		/**
		 *
		 * 
		 * 
		 */
		public function relayEvent(e:Event):void
		{
			this._target.dispatchEvent(e);
		}


		/**
		 *
		 * 
		 * 
		 */
		public function setContent(content:Object):void
		{
			if (content != this._content)
			{
				var oldValue:Object = this._content;
				this._content = content;
				this._target.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this._target, 'content', oldValue, this._content));
			}
		}




		//
		// private methods
		//


		/**
		 * @private
		 */
		private function _getLoader():Object
		{
			if (!this._loader)
			{
				this._loader = this.createLoaderFunction();
			}
			return this._loader;
		}


		/**
		 *
		 * 
		 */
		private function _load(source:Object = null, loadNow:Boolean = false):void
		{
			if (source)
			{
				this.source = source;
			}
			else if (!this.source)
			{
				throw new Error('An AssetLoader cannot be loaded until its source property is set.');
			}
			
			var info:Object = this.getLoaderInfoFunction();
			if (info && info.bytesTotal && (info.bytesLoaded == info.bytesTotal))
			{
				this._target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.READY));
				return;
			}

			// If this loader belongs to a section, delegate the loading to it.
			var section:Object = Section.getSection(this._target);
			if (section)
			{
				if (loadNow)
				{
					section.fetchAssetNow(this._target);
				}
				else
				{
					section.fetchAsset(this._target);
				}
			}
			else
			{
				this.loadAsset();
			}
		}




	}
}
