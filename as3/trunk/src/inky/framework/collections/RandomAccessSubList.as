package inky.framework.collections
{
	import inky.framework.collections.ICollection;
	import inky.framework.collections.IIterator;
	import inky.framework.collections.IList;
	import inky.framework.collections.IListIterator;
	import inky.framework.collections.ListIterator;
	import inky.framework.utils.EqualityUtil;


	/**
	 *
	 * 
	 *
	 * @author     Matthew Treter
	 * @version    2008.06.21
	 *
	 */
	public class RandomAccessSubList implements IList
	{
		private var _fromIndex:uint;
		private var _list:IList;
		private var _toIndex:uint;




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
		}


		/**
		 * @inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			this._list.addItemsAt(collection, index + this._fromIndex);
			this._toIndex += collection.length;
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
			while (this.length > 0)
			{
				this.removeItemAt(0);
			}
		}


		/**
		 * @inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
			return this.removeItemAt(this.getItemIndex(item));
		}


		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			this._toIndex--;
			return this._list.removeItemAt(index + this._fromIndex);
		}


		/**
		 * @inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this.removeItem(i.next());
			}
		}


		/**
		 * @inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
			this._toIndex--;
			return this._list.replaceItemAt(newItem, index + this._fromIndex);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function retainItems(collection:ICollection):void
		{
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
		public function subList(fromIndex:uint, toIndex:uint):IList
		{
			return new RandomAccessSubList(this, fromIndex, toIndex);
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
		public function toString():String
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




	}
}
