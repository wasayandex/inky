package inky.managers 
{
	import com.exanimo.events.LoadQueueEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.core.Section;
	import inky.core.inky;
	import inky.core.inky_internal;
	import inky.data.SectionInfo;
	import inky.net.LoadQueue;
	import inky.net.IAssetLoader;
	import inky.utils.SPath;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2008.06.27
	 *
	 */
	public class LoadManager extends EventDispatcher
	{
		private var _loadQueue:LoadQueue;
		private var _section:Section;
		private static var _masterSection:Section;
		private static var _masterLoadQueue:LoadQueue = new LoadQueue();

		use namespace inky;
		

		/**
		 *
		 * Creates a new load manager for the specified section.
		 *	
		 * @param section
		 *     The section to which this LoadManager belongs.
		 *     Subsections of this section will delegate 
		 *	   load-related tasks to this LoadManager.
		 *	
		 */
		public function LoadManager(section:Section)
		{
			this._loadQueue = new LoadQueue();
			this._section = section;

// TODO: how else to get master section?? Is this good??
LoadManager._masterSection = LoadManager._masterSection || section;

		}




		//
		// public methods
		//


		/**
		 *
		 * @private
		 * 
		 * Cancels the loading of an asset. In general, this method should not
		 * be called directly. Instead, use the <code>close</code> method on the
		 * AssetLoader instance.
		 * 
		 * @param asset
		 *     The asset whose loading you wish to cancel.
		 * 
		 * @see #fetchAsset()
		 * @see #fetchAssetNow()
		 * @see inky.net.IAssetLoader#close()
		 *
		 */		 		 		 		
		public function cancelFetchAsset(asset:Object):void
		{
			// Close the item.
			try
			{
				asset.close();
			}
			catch (error:Error)
			{
			}

			// Remove the item from the queue.
			if (this._loadQueue.getItemIndex(asset) > -1)
			{
				this._loadQueue.removeItem(asset);
			}
		}



		/**
		 * @private
		 *	
		 * 
		 * 
		 */
		public function destroy():void
		{
			this._loadQueue.removeEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler);
			this._loadQueue.removeEventListener(LoadQueueEvent.ASSET_OPEN, this._preloadAssetOpenHandler);
			this._loadQueue.removeEventListener(Event.COMPLETE, this._preloadAssetsCompleteHandler);

			this._loadQueue = undefined;
			this._section = undefined;
		}


		/**
		 *
		 * @private
		 * 
		 * Pushes an asset onto the end of the current loading queue. In
		 * general, this method should not be called directly. Instead, use the
		 * <code>load</code> method on the AssetLoader instance.
		 *
		 * @param asset
		 *     The asset you wish to fetch.
		 * @param callback
		 *     A method to be called once the asset fetch process is
		 *     complete.
		 *	
		 * @see #fetchAssetNow()
		 * @see #cancelFetchAsset()
		 * @see inky.net.IAssetLoader#load()
		 * 
		 */
		public function fetchAsset(asset:Object, callback:Function = null):void
		{
			this._fetchAsset(asset, callback, false);
		}


		/**
		 *
		 * @private
		 * 
		 * Pushes an asset at the front of the current loading queue. In
		 * general, this method should not be called directly. Instead, use the
		 * <code>loadNow</code> method on the AssetLoader instance.
		 *
		 * @param asset
		 *     The asset you wish to fetch.
		 * @param callback
		 *     A method to be called once the asset fetch process is
		 *     complete.
		 *	
		 * @see #fetchAsset()
		 * @see #cancelFetchAsset()
		 * @see inky.net.IAssetLoader#loadNow()
		 * 
		 */
		public function fetchAssetNow(asset:Object, callback:Function = null):void
		{
			this._fetchAsset(asset, callback, true);
		}


		/**
		 * 
		 * @private
		 *	
		 * Initiates preloading for a gotoSection call. 
		 * Invoked by NavigationManager to preload all of the pending
		 * subsections during the gotoSection process.
		 *	
		 * @see inky.managers.NavigationManager#gotoSection()
		 * @see inky.core.Section#gotoSection()
		 *	
		 * @param target
		 *     The series of subsections to be preloaded, as represented by
		 *	   an SPath object or SPath string.
		 * @see inky.utils.SPath
		 *	
		 */
		public function preload(target:Object):void
		{
			// Make sure that we don't re-preload sections that are already loaded.
			var sPath:SPath = target.clone() as SPath;
			var leafSPath:SPath = this._section.sPath;

			while (sPath.length && !sPath.equals(leafSPath))
			{
				var lq:LoadQueue = LoadManager._createPreloadLoadQueue(this._section, sPath);
				if (lq && lq.numItems)
				{
					this._loadQueue.addItemAt(lq, 0);
				}
				sPath = sPath.clone() as SPath;
				sPath.removeItemAt(sPath.length - 1);
			}

			if (this._loadQueue.numItems)
			{
				if (this._section.cumulativeProgressBar)
				{
					this._section.cumulativeProgressBar.source = this._loadQueue;
					this._section.cumulativeProgressBar.maximum = LoadManager._getCumulativeLoadQueueNumItems(this._loadQueue);
					this._section.addCumulativeProgressBar(this._section.cumulativeProgressBar);
				}

				if (this._section.itemProgressBar)
				{
					this._section.addItemProgressBar(this._section.itemProgressBar);
				}

				this._loadQueue.addEventListener(LoadQueueEvent.ASSET_OPEN, this._preloadAssetOpenHandler);
				this._loadQueue.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler);
				this._loadQueue.addEventListener(Event.COMPLETE, this._preloadAssetsCompleteHandler);

				LoadManager._masterLoadQueue.addItemAt(this._loadQueue, 0);
				LoadManager._masterLoadQueue.load();
			}
			else
			{
				this.dispatchEvent(new Event('preloadComplete'));
			}
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 *	
		 */	
		private static function _createPreloadLoadQueue(context:Object, target:Object):LoadQueue
		{
			var sPath:SPath = target as SPath;

			// Get the section's info.
			var info:SectionInfo = context.getInfo().getSectionInfoBySPath(sPath);

			// Get the section's data.
			var data:XML = info.inky_internal::getData();

			// Create the preload load queue.
			var lq:LoadQueue = new LoadQueue();
			var preloadAssetList:XMLList = (data..RuntimeLibraryLoader + data..Asset + data..SWFLoader + data..ImageLoader + data..XMLLoader + data..SoundLoader).((attribute('preload') == 'true') || (attribute('preload') == '{true}'));
			var excludeAssets:XMLList = data.section.RuntimeLibraryLoader + data.Section..Asset + data.Section..SWFLoader + data.Section..ImageLoader + data.Section..XMLLoader + data.Section..SoundLoader;
			var loader:Object;

			for each (var asset:XML in preloadAssetList)
			{
				if (!excludeAssets.contains(asset))
				{
					loader = context.markupObjectManager.createMarkupObject(asset);
					lq.addItem(loader);
				}
			}

			if (info.source)
			{
				loader = new Loader();
				var request:URLRequest = new URLRequest(info.source);
				lq.addItemAt(loader, 0);
				lq.setLoadArguments(loader, request, new LoaderContext(false, ApplicationDomain.currentDomain));
			}

			return lq.numItems ? lq : null;
		}


		/**
		 *
		 *
		 *
		 */		 		 		 		
		private function _fetchAsset(asset:Object, callback:Function = null, loadNow:Boolean = false):void
		{
			var loader:Object;
			var args:Array;
			var dispatcher:Object;

			// Get the loader.
			if (asset is IAssetLoader)
			{
				loader =
				dispatcher = asset;
			}
			else
			{
				throw new Error('You can only fetch IAssetLoaders right now.');
			}

			// Handle the callback.

			if (dispatcher.bytesTotal && (dispatcher.bytesLoaded == dispatcher.bytesTotal))
			{
				callback && callback();
			}
			else
			{
				// Load the item.
				if (callback != null)
				{
					var completeHandler:Function = function(e:Event):void
					{
						e.currentTarget.removeEventListener(e.type, arguments.callee);
						callback();
					}
					dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				}

				// Put the item in the master queue.
				if (loadNow)
				{
					this._loadQueue.addItemAt(loader, 0);
				}
				else
				{
					this._loadQueue.addItem(loader);
				}

				// Set the load args.
				if (args && args.length)
				{
					args.unshift(loader);
					this._loadQueue.setLoadArguments.apply(null, args);
				}

				// Load the queue.
				LoadManager._masterLoadQueue.addItemAt(this._loadQueue, 0);
				LoadManager._masterLoadQueue.load();
			}
		}


		/**
		 *
		 * Adds up the number of items in the specified load queue, 
		 * including nested load queues. This gives a cumulative count
		 * of how many items need to be loaded before this load queue
		 * completes.
		 * 
		 */
		private static function _getCumulativeLoadQueueNumItems(lq:LoadQueue):int
		{
			var numItems:int = 0;
			var item:Object;

			if (lq && lq.numItems)
			{
				for (var i:uint = 0; i < lq.numItems; i++)
				{
					item = lq.getItemAt(i);
					if (item is LoadQueue)
					{
						numItems += LoadManager._getCumulativeLoadQueueNumItems(item as LoadQueue);
					}
					else numItems++;
				}
			}

			return numItems;
		}


		/**
		 *
		 * Updates the itemProgressBar when an asset in the preload queue is opened.
		 * 
		 */
		private function _preloadAssetOpenHandler(e:LoadQueueEvent):void
		{
			if (this._section.itemProgressBar && !(e.loader is LoadQueue))
			{
				this._section.itemProgressBar.source = e.loader;
			}
		}


		/**
		 *
		 * Updates the cumulativeProgressBar when an asset in the preload queue is complete.
		 * 
		 */
		private function _preloadAssetCompleteHandler(e:LoadQueueEvent):void
		{
			if (this._section.cumulativeProgressBar && !(e.loader is LoadQueue))
			{
				this._section.cumulativeProgressBar.value++;
			}
		}


		/**
		 *
		 * When the preload queue completes, remove listeners and dispatch
		 * 'preloadComplete' event.
		 * 
		 */
		private function _preloadAssetsCompleteHandler(e:Event):void
		{
			var lq:LoadQueue = e.target as LoadQueue;
			
			e.target.removeEventListener(e.type, arguments.callee);

			lq.removeEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler);
			lq.removeEventListener(LoadQueueEvent.ASSET_OPEN, this._preloadAssetOpenHandler);

			this.dispatchEvent(new Event('preloadComplete'));
		}

	}
}
