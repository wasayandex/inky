package inky.collections
{
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import inky.collections.ISearchableList;
	import inky.collections.IListIterator;
	import inky.collections.ListIterator;
	import inky.collections.RandomAccessSubList;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.utils.EqualityUtil;
	import flash.events.EventDispatcher;


	/**
	 *
	 * An implementation of the List interface.
	 *
	 * @author     Matthew Treter
	 * @version    2008.06.21
	 *
	 */
	public class AbstractList extends EventDispatcher implements ISearchableList
	{
// TODO: Throw errors on concurrent modifications. (Esp. where subLists are concerned)
// TODO: Protect from instantiation?
// FIXME: Event locations aren't correct.
		private var _list:Array;




 	 	/**
		 *
		 * Creates a new ArrayList collection.
		 *
		 */
		public function AbstractList(array:Array = null)
		{
			this._list = array || [];
		}

		
		
		
		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return this._list.length;
		}




		//
		// public methods
		//
		

		/**
		 * @inheritDoc
		 */
		public function addItem(item:Object):void
		{
			this._list.push(item);
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, [item]));
		}

		/**
		 * @inheritDoc
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			if (index && (index < 0 || index > this.length))
			{
				throw new RangeError("The supplied index (" + index + ") is out of bounds.");
			}
			this._list.splice(index, 0, item);
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, [item]));
		}


		/**
		 * @inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			var p:int = index;
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this._list.splice(p, i, i.next());
				p++;
			}
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, collection.toArray()));
		}


		/**
		 * @inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
// TODO: check for null value
			var index:int = this.length;
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this._list.push(i.next());
			}
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, collection.toArray()));
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
			var contains:Boolean = true;
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				if (this._list.indexOf(i.next()) == -1)
				{
					contains = false;
					break;
				}
			}
			return contains;
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
			if (index >= this.length)
			{
				throw new RangeError("The supplied index (" + index +") is out of bounds.");
			}
			return this._list[index];
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
			return this._list.length == 0;
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
			this._list = [];
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, removedItems));
		}


		/**
		 * @inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
			var index:int = this.getItemIndex(item);
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, [item]));
			return item;
		}


		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			var item:Object = this._list[index];
			this._list.splice(index, 1);
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, [item]));
			return item;
		}


		/**
		 * @inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this._removeItem(i.next());
			}
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, -1, collection.toArray()));
		}


		/**
		 * @inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
			if (index > this.length)
			{
				throw new RangeError('The supplied index is out of bounds.');
			}
			
			var oldItem:Object = this._list[index];
			this._list[index] = newItem;
// FIXME: Dispatch replace event!
			return oldItem;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function retainItems(collection:ICollection):void
		{
			for (var i:int = 0; i < this._list.length; i++)
			{
				var item:Object = this._list[i];
				if (!collection.containsItem(item))
				{
					this._list.splice(i--, 1);
				}
			}
// TODO: Dispatch REMOVE (?) event.
		}

		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return this._list.slice();
		}


		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return '[' + this._list.toString() + ']';
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

			for (var i:uint = 0; i < this._list.length; i++)
			{
				if (EqualityUtil.objectsAreEqual(this._list[i], item))
				{
					index = i;
					break;
				}
			}

			return index;
		}


		/**
		 *
		 *
		 *
		 */		 		 		 		
		private function _removeItem(item:Object):Object
		{
			for (var i:Number = 0; i < this._list.length; i++)
			{
				if (this._list[i] == item)
				{
					this._list.splice(i, 1);
					return item;
				}
			}
			
			// The item wasn't found. Don't do anything.
			return null;
		}




	}
}
