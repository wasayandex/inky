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
		private var _masterSection:Section;
		private var _masterLoadQueue:LoadQueue;
		private var _loaders2Contexts:Dictionary;	

		use namespace inky;
		

		/**
		 *
		 * Creates a new load manager for the specified master
		 * section.
		 *	
		 * @param master
		 *     The master section whose subsections should delegate load-
		 *     related tasks to this object.
		 *	
		 */
		public function LoadManager(master:Section)
		{
			this._masterSection = master;
			this._init();
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
		 * @param context
		 *     The section that owns the asset to be canceled.
		 * @param asset
		 *     The asset whose loading you wish to cancel.
		 * 
		 * @see #fetchAsset()
		 * @see #fetchAssetNow()
		 * @see inky.net.IAssetLoader#close()
		 *
		 */		 		 		 		
		public function cancelFetchAsset(context:Object, asset:Object):void
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
			if (this._masterLoadQueue.getItemIndex(asset) > -1)
			{
				this._masterLoadQueue.removeItem(asset);
			}

			// Remove the reference to the asset's context.
			if (this._loaders2Contexts[asset])
			{
				this._loaders2Contexts[asset] = null;
				delete this._loaders2Contexts[asset];
			}
		}


		/**
		 *
		 * @private
		 * 
		 * Pushes an asset onto the end of the current loading queue. In
		 * general, this method should not be called directly. Instead, use the
		 * <code>load</code> method on the AssetLoader instance.
		 *
		 * @param context
		 *     The section that owns the asset to be fetched.
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
		public function fetchAsset(context:Object, asset:Object, callback:Function = null):void
		{
			this._fetchAsset(context, asset, callback, false);
		}


		/**
		 *
		 * @private
		 * 
		 * Pushes an asset at the front of the current loading queue. In
		 * general, this method should not be called directly. Instead, use the
		 * <code>loadNow</code> method on the AssetLoader instance.
		 *
		 * @param context
		 *     The section that owns the asset to be fetched.
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
		public function fetchAssetNow(context:Object, asset:Object, callback:Function = null):void
		{
			this._fetchAsset(context, asset, callback, true);
		}


		/**
		 * 
		 * @private
		 *	
		 * Initiates preloading for a Subsection. 
		 * Typically invoked by the NavigationManager during the gotoSection
		 * process.
		 *	
		 * @see inky.managers.NavigationManager#gotoSection()
		 * @see inky.core.Section#gotoSection()
		 *	
		 * @param context
		 *     The section which owns the subsection to be preloaded.
		 * @param target
		 *     The subsection to be preloaded, as represented by an SPath
		 *     object or SPath string.
		 * @see inky.utils.SPath
		 *	
		 */
		public function preload(context:Object, target:Object):void
		{
			var sPath:SPath = target as SPath;
			var lq:LoadQueue = this._createPreloadLoadQueue(context, sPath);
			if (lq && lq.numItems)
			{
				//Store the load queue's context.
				this._loaders2Contexts[lq] = context;

				if (context.cumulativeProgressBar) 
				{
					context.cumulativeProgressBar.source = lq;
					context.cumulativeProgressBar.maximum = lq.numItems;
					lq.addEventListener(LoadQueueEvent.ASSET_ADDED, this._preloadAssetAddedHandler, false, 0, true);
					lq.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler, false, 0, true);
					context.addCumulativeProgressBar(context.cumulativeProgressBar);
				}
				if (context.itemProgressBar)
				{
					context.itemProgressBar.source = lq.getItemAt(0);
					lq.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler, false, 0, true);
					context.addItemProgressBar(context.itemProgressBar);
				}

				lq.addEventListener(Event.COMPLETE, this._preloadAssetsCompleteHandler, false, 0, true);

				this._masterLoadQueue.addItemAt(lq, 0);
				this._masterLoadQueue.load();
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
		private function _createPreloadLoadQueue(context:Object, sPath:SPath):LoadQueue
		{
			// Get the section's info.
			var info:SectionInfo = this._masterSection.getInfo().getSectionInfoBySPath(sPath);

			// Get the section's data.
			var data:XML = info.inky_internal::getData();

			// Create the preload load queue.
			var lq:LoadQueue;
			var preloadAssetList:XMLList = (data..RuntimeLibraryLoader + data..Asset + data..SWFLoader + data..ImageLoader + data..XMLLoader + data..SoundLoader).((attribute('preload') == 'true') || (attribute('preload') == '{true}'));
			var excludeAssets:XMLList = data.section.RuntimeLibraryLoader + data.Section..Asset + data.Section..SWFLoader + data.Section..ImageLoader + data.Section..XMLLoader + data.Section..SoundLoader;
			var loader:Object;

			for each (var asset:XML in preloadAssetList)
			{
				if (!excludeAssets.contains(asset))
				{
					if (!lq)
					{
						lq = new LoadQueue();
					}

					loader = context.markupObjectManager.createMarkupObject(asset);
					lq.addItem(loader);
				}
			}

			if (info.source)
			{
				if (!lq)
				{
					lq = new LoadQueue();
				}
				loader = new Loader();
				var request:URLRequest = new URLRequest(info.source);
				lq.addItemAt(loader, 0);
				lq.setLoadArguments(loader, request, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			
			return lq;
		}


		/**
		 *
		 *
		 *
		 */		 		 		 		
		private function _fetchAsset(context:Object, asset:Object, callback:Function = null, loadNow:Boolean = false):void
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
						
						// Remove the reference to the loader's context.
						this._loaders2Contexts[e.currentTarget] = null;
						delete this._loaders2Contexts[e.currentTarget];
						
						callback();
					}
					dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				}

				// Put the item in the master queue.
				if (loadNow)
				{
					this._masterLoadQueue.addItemAt(loader, 0);
				}
				else
				{
					this._masterLoadQueue.addItem(loader);
				}

				// Set the load args.
				if (args && args.length)
				{
					args.unshift(loader);
					this._masterLoadQueue.setLoadArguments.apply(null, args);
				}

				// Store loader's context.
				this._loaders2Contexts[loader] = context;

				// Load the queue.
				this._masterLoadQueue.load();
			}
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _init():void
		{
			this._loaders2Contexts = new Dictionary(true);
			this._masterLoadQueue = new LoadQueue();
		}


		/**
		 *
		 * Updates the cumulativeProgressBar when an asset is added to the preload queue.
		 * 
		 */
		private function _preloadAssetAddedHandler(e:LoadQueueEvent):void
		{
			var context:Section = this._loaders2Contexts[e.target];
			if (!context.cumulativeProgressBar) return;
			context.cumulativeProgressBar.maximum++;
		}


		/**
		 *
		 * Updates the cumulativeProgressBar when an asset in the preload queue is complete.
		 * 
		 */
		private function _preloadAssetCompleteHandler(e:Event):void
		{
			var context:Section = this._loaders2Contexts[e.target];
			var lq:LoadQueue = e.target as LoadQueue;
			if (context.itemProgressBar && lq.numItems)
			{
				context.itemProgressBar.source = lq.getItemAt(0);
			}
			if (context.cumulativeProgressBar)
			{
				context.cumulativeProgressBar.value++;
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
			var context:Section = this._loaders2Contexts[e.target];
			var lq:LoadQueue = e.target as LoadQueue;
			
			e.target.removeEventListener(e.type, arguments.callee);
			if (context.cumulativeProgressBar || context.itemProgressBar)
			{
				lq.removeEventListener(LoadQueueEvent.ASSET_ADDED, this._preloadAssetAddedHandler);
				lq.removeEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler);
			}

			// Remove the reference to the load queue's context.
			this._loaders2Contexts[e.target] = null;
			delete this._loaders2Contexts[e.target];
			this.dispatchEvent(new Event('preloadComplete'));
		}




	}
}
