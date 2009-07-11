package inky.collections
{
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import inky.collections.IList;
	import inky.collections.IListIterator;
	import inky.collections.ListIterator;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.utils.EqualityUtil;
	import flash.events.EventDispatcher;


	/**
	 *
	 * 
	 *
	 * @author     Matthew Treter
	 * @version    2008.06.21
	 *
	 */
	public class RandomAccessSubList extends EventDispatcher implements ISearchableList
	{
		private var _fromIndex:uint;
		private var _list:IList;
		private var _toIndex:uint;
// FIXME: Event locations aren't correct.


 	 	/**
		 *
		 *
		 *
		 */
		public function RandomAccessSubList(list:IList, fromIndex:uint, toIndex:uint)
		{
			this._list = list;
			this._fromIndex = fromIndex;
			this._toIndex = toIndex;
		}

		
		
		
		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return this._toIndex - this._fromIndex;
		}




		//
		// public methods
		//
		

		/**
		 * @inheritDoc
		 */
		public function addItem(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * @inheritDoc
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			this._list.addItemAt(item, index + this._fromIndex);
			this._toIndex++;
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, [item]));
		}


		/**
		 * @inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			this._list.addItemsAt(collection, index + this._fromIndex);
			this._toIndex += collection.length;
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, collection.toArray()));
		}


		/**
		 * @inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
			this.addItemsAt(collection, this.length);
		}


		/**
		 * @inheritDoc
		 */
		public function containsItem(item:Object):Boolean
		{
			return this._getItemIndex(item) != -1;
		}


		/**
		 * @inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
// TODO: check for null value
			var containsItems:Boolean = true;
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				if (!this.containsItem(i.next()))
				{
					containsItems = false;
					break;
				}
			}
			return containsItems;
		}


		/**
		 * @inheritDoc
		 */
		public function equals(o:Object):Boolean
		{
			var isEqual:Boolean = true;
			if (!(o is IList))
			{
				isEqual = false;
			}
			else if (o.length != this.length)
			{
				isEqual = false;
			}
			else
			{
				var i:IIterator = this.iterator();
				var j:IIterator = o.iterator();
				while (isEqual && i.hasNext())
				{
					isEqual = EqualityUtil.objectsAreEqual(i.next(), j.next());
				}
			}
			return isEqual;
		}


		/**
		 *	@inheritDoc
		 */
		public function find(restrictions:Object):ICollection
		{
			return this._find(restrictions);
		}


		/**
		 *	@inheritDoc
		 */
		public function findFirst(restrictions:Object):Object
		{
			var list:ArrayList = this._find(restrictions, true) as ArrayList;
			return list.length > 0 ? list.getItemAt(0) : null;
		}


		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:uint):Object
		{
			return this._list.getItemAt(index + this._fromIndex);
		}


		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return this._getItemIndex(item);
		}


		/**
		 * @inheritDoc
		 */
		public function getSubList(fromIndex:uint, toIndex:uint):IList
		{
			return new RandomAccessSubList(this, fromIndex, toIndex);
		}


		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return this.length == 0;
		}


		/**
		 * @inheritDoc
		 */
		public function iterator():IIterator
		{
			return new ListIterator(this);
		}


		/**
		 * @inheritDoc
		 */
		public function listIterator(index:uint = 0):IListIterator
		{
			return new ListIterator(this, index);
		}


		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			var removedItems:Array = this.toArray();
			while (this.length > 0)
			{
				this._removeItemAt(0);
			}
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, removedItems));
		}


		/**
		 * @inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
			var removedItem:Object = this._removeItemAt(this.getItemIndex(item));
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, [removedItem]));
			return removedItem;
		}


		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			var removedItem:Object = this._removeItemAt(index);
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, [removedItem]));
			return removedItem;
		}


		/**
		 * @inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this._removeItemAt(this.getItemIndex(i.next()));
			}
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, collection.toArray()));			
		}


		/**
		 * @inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
// FIXME: Dispatch events
			this._toIndex--;
			return this._list.replaceItemAt(newItem, index + this._fromIndex);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function retainItems(collection:ICollection):void
		{
// FIXME: Dispatch events
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				if (!collection.containsItem(i.next()))
				{
					i.removeRetrievedItem();
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return this._list.toArray().slice(this._fromIndex, this._toIndex);
		}


		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return '[' + this.toArray().toString() + ']';
		}	




		//
		// private methods
		//


		/**
		 *	
		 *	
		 *	
		 */
		private function _find(restrictions:Object, stopOnFirstMatch:Boolean = false):ICollection
		{
// TODO: This is copy and pasted from AbstractList. Centralize it!
			var result:ArrayList = new ArrayList();
			var testValue:Object;

			for (var i:IIterator = this.iterator(); i.hasNext();)
			{
				var addToList:Boolean = true;
				var testObject:Object = Object(i.next());
				for (var prop:String in restrictions)
				{
					testValue = restrictions[prop];
					if (testValue is Function)
					{
						addToList = testValue(testObject[prop]);
					}
					else if (testValue is RegExp && testObject[prop] is String)
					{
						addToList = testValue.test(testObject[prop]);
					}
					else
					{
						addToList = EqualityUtil.objectsAreEqual(testValue, testObject[prop]);
					}
					
					if (!addToList)
					{
						break;
					}
				}

				if (addToList)
				{
					result.addItem(testObject);
					if (stopOnFirstMatch)
					{
						break;
					}
				}
			}
			return result;
		}


		/**
		 *
		 *
		 *
		 */
		private function _getItemIndex(item:Object):int
		{
			var index:int = -1;
			var i:IListIterator = this._list.listIterator(this._fromIndex);
			for (var j:int = this._fromIndex; j < this._toIndex; j++)
			{
				if (EqualityUtil.objectsAreEqual(item, i.next()))
				{
					index = j;
					break;
				}
			}

			return index;
		}

		
		/**
		 *
		 *	
		 */
		private function _removeItemAt(index:int):Object
		{
			this._toIndex--;
			return this._list.removeItemAt(index + this._fromIndex);
		}




	}
}
