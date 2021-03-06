﻿package inky.framework.managers 
{
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.IIterator;
	import inky.framework.collections.IList;
	import inky.framework.components.progressBar.views.IProgressBar;
	import inky.framework.components.progressBar.ProgressBarMode;
	import inky.framework.loading.events.LoadQueueEvent;
	import inky.framework.utils.URLUtil;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import inky.framework.core.Section;
	import inky.framework.core.inky;
	import inky.framework.core.inky_internal;
	import inky.framework.core.SPath;
	import inky.framework.core.SectionInfo;
	import inky.framework.loading.LoadQueue;
	import inky.framework.loading.loaders.IAssetLoader;
	import inky.framework.loading.loaders.SWFLoader;


	/**
	 *
	 *	Handles the loading for a section. This class should be considered an
	 *	implementation detail and is subject to change.
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

		private static var _data:XML;
		private static var _dataLoadCompleteCallback:Function;
		private static var _includeLoaders2xml:Dictionary;
		private static var _masterLoadQueue:LoadQueue = new LoadQueue();
		private static var _xmlLoader:URLLoader;

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
		 * @see inky.framework.loading.loaders.IAssetLoader#close()
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
		 * @see inky.framework.loading.loaders.IAssetLoader#load()
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
		 * @see inky.framework.loading.loaders.IAssetLoader#loadNow()
		 * 
		 */
		public function fetchAssetNow(asset:Object, callback:Function = null):void
		{
			this._fetchAsset(asset, callback, true);
		}


		/**
		 *
		 * 	
		 * 
		 */
		public function loadData(request:URLRequest, callback:Function):void
		{
			LoadManager._xmlLoader = new URLLoader();
			LoadManager._xmlLoader.addEventListener(Event.OPEN, this._dataOpenHandler);
			LoadManager._xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, LoadManager._doNothing);

			LoadManager._dataLoadCompleteCallback = callback;

			LoadManager._masterLoadQueue.addItem(LoadManager._xmlLoader);
			LoadManager._masterLoadQueue.setLoadArguments(LoadManager._xmlLoader, request);
			LoadManager._masterLoadQueue.load();
		}


		/**
		 * 
		 * @private
		 *	
		 * Initiates preloading for a gotoSection call. 
		 * Invoked by NavigationManager to preload all of the pending
		 * subsections during the gotoSection process.
		 *	
		 * @see inky.framework.managers.NavigationManager#gotoSection()
		 * @see inky.framework.core.Section#gotoSection()
		 *	
		 * @param target
		 *     The series of subsections to be preloaded, as represented by
		 *	   an SPath object or SPath string.
		 * @see inky.framework.core.SPath
		 *	
		 */
		public function preload(target:Object):void
		{
			// Make sure that we don't re-preload sections that are already loaded.
			var sPath:SPath = target.clone() as SPath;
			var leafSPath:SPath = this._section.sPath;

			// Create LoadQueues for each section that needs to be preloaded and add them to a master LoadQueue.
			while (sPath.length && !sPath.equals(leafSPath))
			{
				var lq:LoadQueue = this._createPreloadLoadQueue(sPath);
				if (lq && lq.numItems)
				{
					this._loadQueue.addItemAt(lq, 0);
				}
				sPath = sPath.clone() as SPath;
				sPath.removeItemAt(sPath.length - 1);
			}

			if (this._loadQueue.numItems)
			{
				var itemLoadingProgressBar:DisplayObject = this._getItemLoadingProgressBar();
				var cumulativeLoadingProgressBar:DisplayObject = this._getCumulativeLoadingProgressBar();

				if (cumulativeLoadingProgressBar)
				{
					var progressBar:IProgressBar = cumulativeLoadingProgressBar as IProgressBar;
					if (progressBar)
					{
						progressBar.source = this._loadQueue;
						progressBar.maximum = LoadManager._getCumulativeLoadQueueNumItems(this._loadQueue);
					}
					Section.getSection(cumulativeLoadingProgressBar).addCumulativeLoadingProgressBar(cumulativeLoadingProgressBar);
				}

				if (itemLoadingProgressBar)
				{
					Section.getSection(itemLoadingProgressBar).addItemLoadingProgressBar(itemLoadingProgressBar);
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

		
		/**
		 *
		 * @private
		 *	
		 * Initiates removing progress bars. 
		 * Invoked by NavigationManager to remove any currently displayed
		 * progress bars during the gotoSection process.
		 *	
		 * @see inky.framework.managers.NavigationManager#gotoSection()
		 * @see inky.framework.core.Section#gotoSection()
		 *	
		 */
		public function removeProgressBars():void
		{
			var itemLoadingProgressBar:DisplayObject = this._getItemLoadingProgressBar();
			var cumulativeLoadingProgressBar:DisplayObject = this._getCumulativeLoadingProgressBar();
			
			if (itemLoadingProgressBar)
			{
				Section.getSection(itemLoadingProgressBar).removeItemLoadingProgressBar(itemLoadingProgressBar);
				itemLoadingProgressBar.addEventListener(Event.REMOVED_FROM_STAGE, this._removeProgressBarCompleteHandler);
			}
			
			if (cumulativeLoadingProgressBar)
			{
				Section.getSection(cumulativeLoadingProgressBar).removeCumulativeLoadingProgressBar(cumulativeLoadingProgressBar);
				cumulativeLoadingProgressBar.addEventListener(Event.REMOVED_FROM_STAGE, this._removeProgressBarCompleteHandler);
			}
			
			if ((!itemLoadingProgressBar || !itemLoadingProgressBar.parent) && (!cumulativeLoadingProgressBar || !cumulativeLoadingProgressBar.parent))
			{
				this._removeProgressBarCompleteHandler();
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
		private function _createPreloadLoadQueue(sPath:SPath):LoadQueue
		{
			// Get the section's data.
			var info:SectionInfo = this._section.inky_internal::getInfo().getSectionInfoBySPath(sPath);
			var data:XML = info.inky_internal::getData();

			// Create the preload asset list.
// TODO: Only grab inky namespaced nodes.
			var preloadAssetList:XMLList = (data..RuntimeLibraryLoader + data..AssetLoader + data..SWFLoader + data..ImageLoader + data..XMLLoader + data..SoundLoader).((attribute('preload') == 'true') || (attribute('preload') == '{true}'));
			var excludeAssets:XMLList = data.Section..RuntimeLibraryLoader + data.Section..AssetLoader + data.Section..SWFLoader + data.Section..ImageLoader + data.Section..XMLLoader + data.Section..SoundLoader;
			var preloadAssets:Array = [];
			var loader:Object;

			// If the section is external, create a SWFLoader to load it.
			if (info.source)
			{
				loader = new SWFLoader();
				loader.source = info.source;
				preloadAssets.push(loader);
			}

			// Create AssetLoaders.
			for each (var asset:XML in preloadAssetList)
			{
				if (!excludeAssets.contains(asset))
				{
					loader = this._section.master.markupObjectManager.createMarkupObject(asset);
					preloadAssets.push(loader);
				}
			}

			// Make a LoadQueue containing the preload assets.
			var lq:LoadQueue;
			if (preloadAssets.length)
			{
				lq = new LoadQueue();
				for each (loader in preloadAssets)
				{
					lq.addItem(loader);
				}
			}

			return lq;
		}


		/**
		 *
		 * Called when the data is successfully opened.
		 *
		 */		 		 		 		
		private function _dataOpenHandler(e:Event):void
		{
			var section:Section = this._section.master;
			var itemLoadingProgressBar:IProgressBar = section.itemLoadingProgressBar as IProgressBar;
			if (itemLoadingProgressBar)
			{
				itemLoadingProgressBar.mode = ProgressBarMode.MANUAL;
			}

			e.currentTarget.addEventListener(ProgressEvent.PROGRESS, this._dataProgressHandler);
			e.currentTarget.addEventListener(Event.COMPLETE, this._dataProgressHandler);
			section.loaderInfo.addEventListener(ProgressEvent.PROGRESS, this._dataProgressHandler);
			section.loaderInfo.addEventListener(Event.COMPLETE, this._dataProgressHandler);
		}


		/**
		 *
		 * 	
		 * 
		 */
		private function _dataProgressHandler(e:Event):void
		{
			var section:Section = this._section.master;
			var xmlLoader:URLLoader = LoadManager._xmlLoader;
			var maximum:Number = section.loaderInfo.bytesTotal + xmlLoader.bytesTotal;
			var value:Number = section.loaderInfo.bytesLoaded + xmlLoader.bytesLoaded;
			var itemLoadingProgressBar:IProgressBar = section.itemLoadingProgressBar as IProgressBar;

			if (itemLoadingProgressBar)
			{
				itemLoadingProgressBar.setProgress(value, maximum);
			}

			if (e.type == Event.COMPLETE && value == maximum)
			{
				section.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, this._dataProgressHandler);
				section.loaderInfo.removeEventListener(Event.COMPLETE, this._dataProgressHandler);
				xmlLoader.removeEventListener(ProgressEvent.PROGRESS, this._dataProgressHandler);
				xmlLoader.removeEventListener(Event.COMPLETE, this._dataProgressHandler);

				LoadManager._data = new XML(xmlLoader.data);
				this._loadXMLIncludes(LoadManager._data);
				LoadManager._xmlLoader = undefined;
			}
		}


		/**
		 *
		 * Suppresses unhandled error event warnings.
		 * 
		 */
		private static function _doNothing(e:Event):void
		{
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
		 *	
		 *	
		 */
		private function _getCumulativeLoadingProgressBar():DisplayObject
		{
			return this._getProgressBar('cumulativeLoadingProgressBar');
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _getItemLoadingProgressBar():DisplayObject
		{
			return this._getProgressBar('itemLoadingProgressBar');
		}


		/**
		 *
		 * returns a the progress bar specified by type. If
		 * this loadManager's section does not have that type
		 * of progress bar, it will will look up the owner chain.
		 *	
		 */
		private function _getProgressBar(type:String):DisplayObject
		{
			var progressBar:DisplayObject;
			var section = this._section;
			while (!progressBar && section)
			{
				progressBar = section[type] as DisplayObject;
				section = Section.getSection(section);
			}
			return progressBar;
		}


		/**
		 *
		 * 	
		 * 
		 */
		private function _includeCompleteHandler(e:Event):void
		{
			// Replace the include node with the loaded data.
			var incl:XML = LoadManager._includeLoaders2xml[e.currentTarget];
			incl.parent().replace(incl.childIndex(), new XML(e.currentTarget.data));
	
			// Remove the loader from the list of loading loaders. If the list
			// is empty (i.e. all the data is loaded), kick of the initialization
			// process.
			delete LoadManager._includeLoaders2xml[e.currentTarget];
		}


		/**
		 *
		 * 	
		 * 
		 */
		private function _includeQueueCompleteHandler(e:Event = null):void
		{
			var itemLoadingProgressBar:IProgressBar = this._section.master.itemLoadingProgressBar as IProgressBar;
			if (itemLoadingProgressBar)
			{
				itemLoadingProgressBar.mode = ProgressBarMode.EVENT;
			}

			LoadManager._dataLoadCompleteCallback.apply(this._section.master, [LoadManager._data]);
			LoadManager._dataLoadCompleteCallback = undefined;
			LoadManager._data = undefined;
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _loadXMLIncludes(data:XML):void
		{
			var includeQueue:LoadQueue = new LoadQueue();

			LoadManager._includeLoaders2xml = new Dictionary(true);

			for each (var incl:XML in data.descendants(new QName(inky, 'include')))
			{
				var loader:URLLoader = new URLLoader();
				var source:String = incl.@source;

				// Get the base.
				var tmp:XML = incl;
				while (tmp)
				{
					if (tmp.@inky::base.length())
					{
						source = URLUtil.getFullURL(tmp.@inky::base, source);
					}
					tmp = tmp.parent();
				}
				LoadManager._includeLoaders2xml[loader] = incl;
				includeQueue.addItem(loader);
				includeQueue.setLoadArguments(loader, new URLRequest(source));
				loader.addEventListener(Event.COMPLETE, this._includeCompleteHandler);
			}

			if (includeQueue.numItems)
			{
				includeQueue.addEventListener(Event.COMPLETE, this._includeQueueCompleteHandler);
				LoadManager._masterLoadQueue.addItem(includeQueue);
				LoadManager._masterLoadQueue.load();
			}
			else
			{
				this._includeQueueCompleteHandler();
			}
		}
		
		
		/**
		 *
		 * Updates the itemLoadingProgressBar when an asset in the preload queue is opened.
		 * 
		 */
		private function _preloadAssetOpenHandler(e:LoadQueueEvent):void
		{
			var itemLoadingProgressBar:IProgressBar = this._getItemLoadingProgressBar() as IProgressBar;
			if (itemLoadingProgressBar && !(e.loader is LoadQueue))
			{
				itemLoadingProgressBar.source = e.loader;
			}
		}


		/**
		 *
		 * Updates the cumulativeLoadingProgressBar when an asset in the preload queue is complete.
		 * 
		 */
		private function _preloadAssetCompleteHandler(e:LoadQueueEvent):void
		{
			var cumulativeLoadingProgressBar:IProgressBar = this._getCumulativeLoadingProgressBar() as IProgressBar;
			if (cumulativeLoadingProgressBar && !(e.loader is LoadQueue))
			{
				cumulativeLoadingProgressBar.value++;
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


		/**
		 *
		 * When a progress bar is removed, this handler will dispatch the
		 * removeProgressBarsComplete event if there are no other progress
		 * bars to be removed.
		 *	
		 */
		private function _removeProgressBarCompleteHandler(e:Event = null)
		{
			var cumulativeRemoved:Boolean = false;
			var itemRemoved:Boolean = false;

			var itemLoadingProgressBar:DisplayObject = this._getItemLoadingProgressBar();
			var cumulativeLoadingProgressBar:DisplayObject = this._getCumulativeLoadingProgressBar();

			if (e)
			{
				e.target.removeEventListener(e.type, arguments.callee);

				if (e.target == cumulativeLoadingProgressBar)
				{
					cumulativeRemoved = true;
				}
				else if (e.target == itemLoadingProgressBar)
				{
					itemRemoved = true;
				}
			}

			if (!itemLoadingProgressBar || !itemLoadingProgressBar.parent)
			{
				itemRemoved = true;
			}

			if (!cumulativeLoadingProgressBar || !cumulativeLoadingProgressBar.parent)
			{
				cumulativeRemoved = true;
			}

			if (cumulativeRemoved && itemRemoved)
			{
				this.dispatchEvent(new Event('removeProgressBarsComplete'));
			}
		}
		
				
	}
}
