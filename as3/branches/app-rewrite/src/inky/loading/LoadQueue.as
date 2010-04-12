package inky.loading
{
	import inky.loading.events.LoadQueueEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLLoader;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;


	/**
	 *
	 *  Defines a LoadQueue, which allows you to defer the loading of objects.
	 *
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter (matthew@exanimo.com)
	 *	@author Eric Eldredge
	 *	@since  2007.10.03
	 *
	 */
	public class LoadQueue extends EventDispatcher
	{
		private var _currentItems:Array;
		private var _isLoading:Boolean;
		private var _isOpen:Boolean;
// FIXME: Don't use dictionary to store load args. (dict[key] = {prop: key} will prevent garbage collection)
		private var _loadArgsList:Dictionary;
		private var _loadNextTimeoutID:uint;
		private var _maxConnections:int;
		private var _parent:Object;
		private var _queue:Array;


		/**
		 *
		 * Constructs a new LoadQueue.
		 *
		 */
		public function LoadQueue()
		{
			this._currentItems = [];
			this._queue = [];
			this._loadArgsList = new Dictionary(true);
			this._maxConnections = -1;
		}




		//
		// accessors
		//


		/**
		 *
		 * The number of files that this queue is allowed to load
		 * simultaneously. If this LoadQueue belongs to another, the default
		 * number of maximum connections will be as many as the parent queue
		 * allows. Otherwise, the default is one.		 		 
		 *
		 */
		public function get maxConnections():int
		{
			return this._maxConnections;
		}
		/**
		 * @private
		 */		 		
		public function set maxConnections(maxConnections:int):void
		{
// TODO: test this. I think it's broken.
			if (maxConnections < -1)
				throw new RangeError('LoadQueue.maxConnections must be greater than or equal to -1.');

			this._maxConnections = maxConnections;
			
			if (this._isLoading)
				this._loadNext();
		}


		/**
		 * The number of files currently being loaded.
		 * 
		 * @default 0	
		 */
		public function get numConnections():uint
		{
			var numConnections:uint = 0;
			var item:Object;
			for (var i:uint = 0; i < this.numItems; i++)
			{
				item = this.getItemAt(i);
				numConnections += item is LoadQueue ? item.numConnections : this._currentItems.indexOf(item) == - 1 ? 0 : 1;
			}
			return numConnections;
		}


		/**
		 * The total number of assets in this LoadQueue tree. This number is
		 * calculated by adding the number of non-LoadQueue items in this queue
		 * to the number of non-LoadQueue items in all descendant queues.
		 * 
		 * @default 0
		 */
		public function get numAssets():int
		{
			return this._getNumAssets(this);
		}


		/**
		 * The number of items in the queue. This number includes child
		 * LoadQueues, so it may be misleading. For example, a LoadQueue may
		 * contain another LoadQueue which in turn contains 10 URLLoaders. The
		 * parent's <code>numItems</code> is 1.
		 * 
		 * @default 0
		 *		 		 
		 * @see #numAssets
		 */
		public function get numItems():int
		{
			return this._queue.length;
		}


		/**
		 * The LoadQueue to which this one belongs.
		 * 
		 * @default null
		 */
		public function get parent():Object
		{
			return this._parent;
		}




		//
		// public methods
		//


		/**
		 * @throws ArgumentError
		 *     thrown if item does not implement <code>load</code> and
		 *     <code>close</code> methods
		 *
		 * @inheritDoc
		 */
		public function addItem(item:Object, ...loadArgs:Array):void
		{
			this._addItemAt(item, this.numItems, loadArgs);
		}


		/**
		 * @throws ArgumentError
		 *     thrown if item does not implement <code>load</code> and
		 *     <code>close</code> methods
		 *
		 * @inheritDoc
		 */
		public function addItemAt(item:Object, index:int, ...loadArgs:Array):void
		{
			this._addItemAt(item, index, loadArgs);
		}


		/**
		 * Stops the loading process. The <code>close()</code> method will be
		 * called on all loading items in the queue.
		 */
		public function close():void
		{
			this._isLoading = false;
			while (this._currentItems.length)
			{
				var item:Object = this._currentItems.pop();
				try
				{
					item.close();
				}
				catch (error:Error)
				{
					// The item hasn't been opened yet.
// TODO: When the item opens, close it.
				}
			}
			clearTimeout(this._loadNextTimeoutID);
		}


		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
			if (index >= this.numItems || index < 0)
			{
				throw new RangeError('The specified index is greater than or equal to the number of items in the LoadQueue.');
			}
			return this._queue[index];
		}


		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return this._getItemIndex(item);
		}


		/**
		 * Gets the load arguments for the specified loader object.
		 * 
		 * @see #setLoadArguments		 		 
		 *	
		 * @return
		 *     An array containing all of the arguments that were assigned to
		 *     this object using <code>setLoadArguments</code>		 		 		 
		 */
		public function getLoadArguments(item:Object):Array
		{
			return this._loadArgsList[item] ? this._loadArgsList[item].concat() : null;
		}


		/**
		 * Begins loading the queue.
		 */
		public function load():void
		{
			if (this._isLoading) return;
			this._isLoading = true;
			this._loadNext();
		}


		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			while (this.numItems)
				this.removeItemAt(0);
		}


		/**
		 * @inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
			var itemIndex:int = this._getItemIndex(item)

			if (itemIndex == -1)
			{
				throw new ArgumentError('The item you are attempting to remove is not present in the LoadQueue.');
			}

			return this._removeItemAt(itemIndex);
		}


		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:int):Object
		{
			if (index >= this.numItems || index < 0)
			{
				throw new RangeError('The supplied index is out of bounds.');
			}

			return this._removeItemAt(index);
		}


		/**
		 * @inheritDoc
		 */
		public function replaceItem(newItem:Object, oldItem:Object):Object
		{
			return this.replaceItemAt(newItem, this.getItemIndex(oldItem));
		}


		/**
		 * @inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
			var oldItem:Object = this.removeItemAt(index);
			this.addItemAt(newItem, index);
			return oldItem;
		}


		/**
		 * @inheritDoc
		 */
		public function setItemAt(item:Object, index:int):Object
		{
// TODO: implement this method!
			return {};
		}


		/**
		 * Sets the load arguments for the specified loader object. These
		 * arguments will be passed to the items's <code>load</code> method
		 * when it comes time to load the item.	Typically, the load arguments
		 * will include a URLRequest, however it may not if the item is a
		 * custom loader object.		 		 	 		 
		 * 
		 * @see #getLoadArguments		 		 
		 *
		 * @param item
		 *     The loader object to set the load arguments for.
		 * @param loadArgs
		 *     A list of arguments to be passed to the item's <code>load</code>
		 *     method.
		 */
		public function setLoadArguments(item:Object, loadArgs:Array):void
		{
			this._loadArgsList[item] = loadArgs;
		}


		/**
		 * @inheritDoc	
		 */
		public function toArray():Array
		{
			return this._queue.slice();
		}




		//
		// private methods
		//


		/**
		 * Common implementation for adding items. All functions that add items
		 * to the queue do so by calling this method.
		 */
		private function _addItemAt(item:Object, index:uint, loadArgs:Array):void
		{
			// Make sure that the object implements load() and close().
			if (!(item.hasOwnProperty('load') && (typeof item.load == 'function') && item.hasOwnProperty('close') && (typeof item.close == 'function')))
				throw new ArgumentError('You cannot add an item to the LoadQueue unless it implements load() and close().');

			// Make sure that the index isn't out of bounds.
			if ((index < 0) || (index > this.numItems))
				throw new RangeError('The specified index does not exist in the LoadQueue.');

			// If you were loading when you added the item, you should resume
			// loading after it's added.
			var continueLoading:Boolean = this._isLoading;

			// If the item is a LoadQueue, point its parent property to this
			// LoadQueue. If it already has a parent, remove it from that
			// first.
			var lq:LoadQueue;
			if ((lq = item as LoadQueue))
			{
				if (lq.parent && (lq.parent != this))
				{
					lq.parent.removeItem(lq);
				}
				lq._parent = this;
			}

			// Remove the item if it already exists in the queue.
			var currentIndex:int = this._getItemIndex(item);
			if (currentIndex != -1)
			{
				if (currentIndex == index) return;
				this._removeItemAt(currentIndex, false);
			}

			// Add the item to the queue.
			this._queue.splice(index, 0, item);

			// Set the load args.
			if (loadArgs && loadArgs.length)
				this.setLoadArguments(item, loadArgs);

			if (continueLoading)
			{
				this._scheduleLoadNext();
			}
		}


		/**
		 * Called when a loader finishes loading.
		 *
		 * @param event
		 *     the event that triggered the handler
		 */
		private function _loaderCompleteHandler(event:Event):void
		{
			this._processCompleteEvent(event);
		}


		/**
		 * Removes the loaded item from the queue and calls _loadNext to
		 * continue the loading process. Called when an item in the queue
		 * finishes loading.
		 *
		 * @param event
		 *     the event that triggered the handler
		 */
		private function _processCompleteEvent(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);

			var item:Object = event.currentTarget is LoaderInfo ? event.currentTarget.loader : event.currentTarget;
			delete this._loadArgsList[item];
			this.removeItem(item);
			
			// "Bubble" the ASSET_COMPLETE event
			var tmp:LoadQueue = this;
			while (tmp)
			{
				tmp.dispatchEvent(new LoadQueueEvent(LoadQueueEvent.ASSET_COMPLETE, false, false, item, this));
				tmp = tmp._parent as LoadQueue;
			}
			
			if (!this.numItems)
			{
				// All the items in the queue have completed.
				this._isLoading = false;
				this._isOpen = false;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}

			this._loadNext();
		}


		/**
		 * Removes the loaded item from the queue and calls _loadNext to
		 * continue the loading process. Called when an item in the queue
		 * errors.
		 *
		 * @param e:Event
		 *     the event that triggered the handler
		 */
		private function _errorHandler(e:Event):void
		{
// TODO: Better error handling than just skipping the item!!
// TODO: This code is duplicated in _loaderCompleteHandler. Centralize!
trace(e['text'] || e);

			var item:Object;

			try
			{
				item = e.currentTarget is LoaderInfo ? e.currentTarget.loader : e.currentTarget;
			}
			catch (error:Error)
			{
				// The loader could not be accessed. Search the LoadQueue.
				for (var i:uint = 0; i < this.numItems; i++)
				{
					var tmp:Loader;
					if ((tmp = this.getItemAt(i) as Loader) && (tmp.contentLoaderInfo == e.currentTarget))
					{
						item = tmp;
						break;
					}
				}
			}
			delete this._loadArgsList[item];
			this.removeItem(item);

			if (!this.numItems)
			{
				// All the items in the queue have completed.
				this._isLoading = false;
				this._isOpen = false;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}

			this._loadNext();
		}


		/**
		 * Gets the event dispatcher that dispatches the COMPLETE event for the
		 * provided object. This is necessary because Loader objects don't
		 * dispatch their own events.		 		 
		 *
		 * @param item
		 *     the object whose dispatcher to get
		 *
		 * @return IEventDispatcher
		 *     the IEventDispatcher that will dispatch a COMPLETE event when the
		 *     supplied object has finished loading.
		 */
		private function _getDispatcher(item:Object):IEventDispatcher
		{
			return (item is Loader ? item.contentLoaderInfo : item) as IEventDispatcher;
		}


		/**
		 *
		 */
		private function _getItemIndex(item:Object):int
		{
			return this._queue.indexOf(item);
		}
		
		
		/**
		 *	
		 */
		private function _getNumAssets(lq:LoadQueue):uint
		{
			var numAssets:int = 0;
			for (var i:uint = 0; i < lq.numItems; i++)
			{
				var item:Object = lq.getItemAt(i);
				numAssets += item is LoadQueue ? this._getNumAssets(item as LoadQueue) : 1;
			}
			return numAssets;
		}


		/**
		 * Returns the number of connections that are currently allowed.
		 */
		private function _getNumAllowedConnections():uint
		{
			var numAllowedConnections:uint;
			
			if (!this.parent)
			{
				numAllowedConnections = Math.max(0, (this.maxConnections == -1 ? 1 : this.maxConnections) - this.numConnections);
			}
			else
			{
				var parentsNumAllowedConnections:uint = this.parent._getNumAllowedConnections();
				numAllowedConnections = Math.min((this.maxConnections == -1 ? uint.MAX_VALUE : this.maxConnections), parentsNumAllowedConnections);
			}

			return numAllowedConnections;
		}


		/**
		 * Loads the next asset in the tree.
		 */
		private function _loadNext():void
		{
			// Make sure this queue is loading before trying to load the next
			// loader. (This method may be called on a non-loading queue if the
			// loader is also in another, loading queue)
			if (!this._isLoading)
				return;

			for each (var item:Object in this._queue)
			{
				if (!this._getNumAllowedConnections())
				{
					break;
				}

				var doLoad:Boolean = item is LoadQueue;

				if (this._currentItems.indexOf(item) == -1)
				{
					this._currentItems.push(item);
					doLoad = true;
				}

				if (doLoad)
				{
					// Add listeners
					var dispatcher:IEventDispatcher = this._getDispatcher(item);
					dispatcher.addEventListener(Event.COMPLETE, this._loaderCompleteHandler, false, 0, true);
					dispatcher.addEventListener(IOErrorEvent.IO_ERROR, this._errorHandler, false, 0, true);
					dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._errorHandler, false, 0, true);

					// Load the item.
					var args:Array = this.getLoadArguments(item) || [];
					item.load.apply(null, args);

					if (!this._isOpen)
					{
						// Dispatch an OPEN event on the LoadQueue.
						this._isOpen = true;
						this.dispatchEvent(new Event(Event.OPEN));
					}
				
					// "Bubble" the ASSET_OPEN event
					var tmp:LoadQueue = this;
					while (tmp)
					{
						tmp.dispatchEvent(new LoadQueueEvent(LoadQueueEvent.ASSET_OPEN, false, false, item, this));
						tmp = tmp._parent as LoadQueue;
					}
				}
			}
		}


		/**
		 * Common implementation for removing items. All functions that remove
		 * items do so by calling this function.
		 */
		private function _removeItemAt(index:int, continueLoading:Boolean = true):Object
		{
			// Remove the item from the queue.
			var item:Object = this.getItemAt(index);
			continueLoading = continueLoading && this._isLoading;
			var dispatcher:IEventDispatcher = this._getDispatcher(item);
			this._queue.splice(index, 1);

			// Remove the item from the list of current items.
			var itemIndex:int = this._currentItems.indexOf(item);
			if (itemIndex != -1)
			{
				this._currentItems.splice(itemIndex, 1);
			}

// If the item is a LoadQueue, null its parent property.
var lq:LoadQueue;
if ((lq = item as LoadQueue))
{
	lq._parent = null;
}

			dispatcher.removeEventListener(Event.COMPLETE, this._loaderCompleteHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, this._errorHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this._errorHandler);

			if (continueLoading)
				this._loadNext();

			// "Bubble" the ASSET_REMOVED event
			var tmp:LoadQueue = this;
			while (tmp)
			{
				tmp.dispatchEvent(new LoadQueueEvent(LoadQueueEvent.ASSET_REMOVED, false, false, item, this));
				tmp = tmp._parent as LoadQueue;
			}

			return item;
		}


		/**
		 * Schedules the next item in the queue for loading. This is done to
		 * give the user time to set the load arguments using setLoadArguments()
		 */
		private function _scheduleLoadNext():void
		{
			if (!this._isLoading)
				return;
			this._loadNextTimeoutID = setTimeout(this._loadNext, 0);
		}




	}
}
