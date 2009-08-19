package inky.xml 
{
	import inky.collections.IList;
	import inky.collections.IListIterator;
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.collections.ListIterator;
	import flash.events.EventDispatcher;
	import inky.xml.events.XMLChangeEvent;
	import flash.events.Event;
	import inky.xml.XMLProxyManager;
	import inky.xml.IXMLProxy;
	import inky.xml.IXMLListProxy;




	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.17
	 *
	 */
	internal class DirectXMLListProxy extends EventDispatcher implements IXMLListProxy
	{
		private static var _constructorProperty:QName = new QName("constructor");
	    private var _source:XMLList;
		private static var _proxyManager:XMLProxyManager = XMLProxyManager.getInstance();

//!
// FIXME: This should not affect underlying xml tree. Instead it should form a new list. Also means that these should not be pooled.







		/**
		 *
		 * 
		 *
		 */	
	    public function DirectXMLListProxy(source:XMLList)
	    {
			this._source = source;
	    }




		//
		// accessors
		//


		/**
		 *
		 */
		public function get source():XMLList
		{ 
			return this._source; 
		}




		//
		// list methods
		//


		/**
		 *	@inheritDoc
		 */
		public function addItem(item:Object):void
		{
			this._addItemAt(item, this.length);
		}
		


		/**
		 *	@inheritDoc
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			this._addItemAt(item, index);
		}
		
		
		private function _addItemAt(item:Object, index:uint, dispatchEvent:Boolean = true):Boolean
		{
			if (!(item is IXMLProxy))
				throw new ArgumentError("Argument must be of type IXMLProxy");

			if (index < 0 || index > this.length)
				throw new RangeError("The supplied index (" + index + ") is out of bounds.");
				
			var collectionChanged:Boolean = false;			
			var oldLocation:int = this.getItemIndex(item);
			if (oldLocation != index)
			{
				collectionChanged = true;
				
				// If the object is already in the list, remove it.
				if (oldLocation != -1)
					this.removeItemAt(oldLocation);

				// Update the list.
				var newSource:XMLList = new XMLList();
				for (var i:int = 0; i < this._source.length() + 1; i++)
				{
					if (i < index)
						newSource = newSource + this._source[i];
					else if (index == i)
						newSource = newSource + item.source;
					else
						newSource = newSource + this._source[i - 1];
				}
				this._source = newSource;

				if (dispatchEvent)
				{
					var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, oldLocation, [item]);
					this.dispatchEvent(event);
				}
			}
			return collectionChanged;
		}


		/**
		 *	@inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
			this._addItemsAt(collection, 0);
		}


		/**
		 *	
		 */
		private function _addItemsAt(collection:ICollection, index:uint):void
		{
			var collectionChanged:Boolean = false;
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				var item:Object = i.next();
				collectionChanged = collectionChanged || this._addItemAt(item, index + i, false);
			}
			if (collectionChanged)
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, collection.toArray());
				this.dispatchEvent(event);
			}
		}


		/**
		 *	@inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			this._addItemsAt(collection, index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function containsItem(item:Object):Boolean
		{
			if (!(item is IXMLProxy))
				throw new ArgumentError("Argument must be of type IXMLProxy");

			return this._source.contains(item.source);
		}


		/**
		 *	@inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
throw new Error("not yet implemented");
		}



		/**
		 *	@inheritDoc
		 */
		public function getItemAt(index:uint):Object
		{
			if (index < 0 || index >= this.length)
				throw new RangeError("The supplied index (" + index + ") is out of bounds.");
			return _proxyManager.getProxy(this._source[index]);
		}


		/**
		 *	@inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return this._source.contains(item) ? item.childIndex() : -1;
		}


		/**
		 *	@inheritDoc
		 */
		public function getSubList(fromIndex:uint, toIndex:uint):IList
		{
			if (toIndex > this.length || fromIndex > toIndex || fromIndex < 0)
				throw new RangeError();

			var xml:XMLList = this._source.(childIndex() >= fromIndex && childIndex() < toIndex);
			return _proxyManager.getListProxy(xml, true);
		}


		/**
		 *	@inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return this._source.length() == 0;
		}


		/**
		 *	@inheritDoc
		 */
		public function iterator():IIterator
		{
			return new ListIterator(this);
		}


		/**
		 *	@inheritDoc
		 */
		public function get length():uint
		{
			return this._source.length();
		}


		/**
		 *	@inheritDoc
		 */
		public function listIterator(index:uint = 0):IListIterator
		{
			return new ListIterator(this, index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function removeAll():void
		{
			if (this.length > 0)
			{
				var removedItems:Array = this.toArray();
				
				this._source = new XMLList();

				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, 0, removedItems);
				this.dispatchEvent(event);
			}
		}
		

		/**
		 *	@inheritDoc
		 */		
		public function removeItem(item:Object):Object
		{
			if (!(item is IXMLProxy))
				throw new ArgumentError("Argument must be of type IXMLProxy");

			var index:int = this.getItemIndex(item);
			if (index != -1)
				this._removeItemAt(index, item);

			return item;
		}
		
		
		/**
		 *	
		 */
		private function _removeItemAt(index:int, item:Object = null):Object
		{
			item = item || this.getItemAt(index);

			if (index < 0 || index > this.length)
				throw new RangeError("The supplied index (" + index + ") is out of bounds.");
			
			// Update the list.
			var newSource:XMLList = new XMLList();
			for (var i:int = 0; i < this._source.length() + 1; i++)
			{
				if (i != index)
					newSource = newSource + this._source[i];
			}
			this._source = newSource;
			
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, [item]);
			this.dispatchEvent(event);
			
			return item;
		}
		

		/**
		 *	@inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			return this._removeItemAt(index);
		}


		/**
		 *	@inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */		
		public function retainItems(collection:ICollection):void
		{
throw new Error("not yet implemented");
		}
		

		/**
		 *	@inheritDoc
		 */		
		public function toArray():Array
		{
// TODO: Don't create a new array every time, if possible.
			var result:Array = [];
			var len:int = this.length;
			for (var i:int = 0; i < len; i++)
			{
				result[i] = this.getItemAt(i);
			}
			return result;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc	
		 */
		public function equals(obj:Object):Boolean
		{
			return this == obj;
		}


		/**
		 * @copy Object#toString()
		 */
		override public function toString():String 
		{
			return this._source.toString();
		}




		//
		// xml methods
		//


		/**
		 * @copy XML#toXMLString()
		 */
		public function toXMLString():String 
		{
			return this._source.toXMLString();
		}











	}
}