﻿package inky.framework.collections
{
	import inky.framework.collections.ICollection;
	import inky.framework.collections.IIterator;
	import inky.framework.collections.IList;
	import inky.framework.collections.IListIterator;
	import inky.framework.collections.ListIterator;
	import inky.framework.collections.RandomAccessSubList;
	import inky.framework.utils.EqualityUtil;
	import flash.events.EventDispatcher;


	/**
	 *
	 * An implementation of the List interface.
	 *
	 * @author     Matthew Treter
	 * @version    2008.06.21
	 *
	 */
	public class AbstractList extends EventDispatcher implements IList
	{
// TODO: Throw errors on concurrent modifications. (Esp. where subLists are concerned)
// TODO: Protect from instantiation?
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
		}


		/**
		 * @inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this._list.splice(index, i, i.next());
			}
		}


		/**
		 * @inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
// TODO: check for null value
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				this._list.push(i.next());
			}
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
			this._list = [];
		}


		/**
		 * @inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
			return this._removeItem(item);
		}


		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			var item:Object = this._list[index];
			this._list.splice(index, 1);
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
