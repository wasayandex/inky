﻿package inky.xml 
{
	import inky.collections.IList;
	import inky.collections.IListIterator;
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.collections.ListIterator;
	import flash.events.EventDispatcher;
	import inky.xml.XMLProxyManager;
	import inky.xml.IXMLProxy;
	import inky.xml.IXMLListProxy;
	import inky.xml.XMLListProxy;




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
	public class XMLListProxy extends EventDispatcher implements IXMLListProxy
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
	    public function XMLListProxy(source:XMLList = null)
	    {
			this.setSource(source || new XMLList());
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
		public function addItemAt(item:Object, index:int):void
		{
			this._addItemAt(item, index);
		}
		
		
		private function _addItemAt(item:Object, index:int, dispatchEvent:Boolean = true):Boolean
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
		private function _addItemsAt(collection:ICollection, index:int):void
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
		public function addItemsAt(collection:ICollection, index:int):void
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
		public function getItemAt(index:int):Object
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
			if (item is IXMLProxy)
				item = item.source;
			else if (!(item is XML))
				throw new ArgumentError();

			var index:int = -1;
			if (this._source.contains(item))
			{
				// Determine the item's index. (Can't use childIndex() because we need the position in this list, not the items children list.)
				var len:int = this._source.length();
				for (var i:int = 0; i < len; i++)
				{
					if (this._source[i] === item)
					{
						index = i;
						break;
					}
				}
			}

			return index;
		}


		/**
		 *	@inheritDoc
		 */
		public function getSubList(fromIndex:int, toIndex:int):IList
		{
			if (toIndex > this.length || fromIndex > toIndex || fromIndex < 0)
				throw new RangeError();

			var xml:XMLList = this._source.(childIndex() >= fromIndex && childIndex() < toIndex);
			return new XMLListProxy(xml);
		}


		/**
		 *	@inheritDoc
		 */
		public function get isEmpty():Boolean
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
		public function get length():int
		{
			return this._source.length();
		}


		/**
		 *	@inheritDoc
		 */
		public function listIterator(index:int = 0):IListIterator
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
			for (var i:int = 0; i < this._source.length(); i++)
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
		public function removeItemAt(index:int):Object
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
		public function replaceItemAt(newItem:Object, index:int):Object
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




		//
		// protected methods
		//


		/**
		 *	
		 */
		protected function setSource(source:XMLList):void
		{
			this._source = source;
		}




	}
}