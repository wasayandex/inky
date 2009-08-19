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
		private var _parent:XML;
	    private var _source:XMLList;
		private static var _proxyManager:XMLProxyManager = XMLProxyManager.getInstance();

//!
// FIXME: This should not affect underlying xml tree. Instead it should form a new list. Also means that these should not be pooled.







		/**
		 *
		 * 
		 *
		 */	
	    public function DirectXMLListProxy(source:XMLList, parent:XML = null)
	    {
			this._source = source;
			this._parent = parent;
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
throw new Error("You can't add items to IXMLListProxies");
			if (!(item is IXMLProxy))
				throw new ArgumentError("Argument must be of type IXMLProxy");

			if (index < 0 || index > this.length)
				throw new RangeError("The supplied index (" + index + ") is out of bounds.");
				
			var parent:XML = this._parent;
			if (parent == null)
			{
				throw new Error("You can only add items to children lists (lists created by calling IXMLProxy.children()) and their subLists.");
			}

			var collectionChanged:Boolean = false;			
			var oldLocation:int = this.getItemIndex(item);
			if (oldLocation != index)
			{
				collectionChanged = true;
				
				// If the object is already in the list, remove it.
				if (oldLocation != -1)
					this.removeItemAt(oldLocation);
				
// FIXME: This isn't going to work. Consider the following:
// var children:IXMLListProxy = xml.children();
// trace(children.length);
// children.addItem(new XMLProxy(<firstttttttttttttttttttttttttttttttt/>));
// trace(children.length);
// The underlying list won't be updated.

				if (parent.children().length() == 0)
					parent.appendChild(item.source);
				else if ((index - 1 > 0) && (index - 1 < parent.children().length()))
				{
					var previousChild:XML = parent.children()[index - 1];
					parent.insertChildAfter(previousChild, item.source);
				}
				else
				{
					var nextChild:XML = parent.children()[index];
					parent.insertChildBefore(nextChild, item.source);
				}
			
				if (dispatchEvent)
				{
					var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, oldLocation, [item]);
					this._dispatchEvent(event);
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
				this._dispatchEvent(event);
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
			return _proxyManager.getListProxy(xml, true, this._parent);
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
				
				var len:int = this._source.length();
				while (len)
				{
					delete this._source[0];
					len--;
				}
					
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, 0, removedItems);
				this._dispatchEvent(event);
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
			{
				delete this._source[index];
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, [item]);
				this._dispatchEvent(event);
			}
			
			return item;
		}
		

		/**
		 *	@inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			if (!(item is IXMLProxy))
				throw new ArgumentError("Argument must be of type IXMLProxy");
			if (index < 0 || index > this.length)
				throw new RangeError("The supplied index (" + index + ") is out of bounds.");

			var item:IXMLProxy = _proxyManager.getProxy(this._source[index]) as IXMLProxy;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, [item]);
			this._dispatchEvent(event);
			return item;
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







		private function _dispatchEvent(changeEvent:Event):void
		{
			// Dispatch this event.
			this.dispatchEvent(changeEvent);

			// Pseudo-bubbling.
			if (this._parent)
			{
				var xml:Object = this._source;
				var proxy:Object = this;
				var event:XMLChangeEvent = new XMLChangeEvent(XMLChangeEvent.CHANGE, this, changeEvent);
				while (xml)
				{
					if (proxy)
					{
						proxy.dispatchEvent(event);
					}
					xml = xml.parent();
					if (xml)
						proxy = _proxyManager.getProxy(xml as XML, false);
				}
			}
		}





	}
}