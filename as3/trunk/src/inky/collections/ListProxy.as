package inky.collections 
{
import flash.events.Event;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.20
	 *
	 */
	public class ListProxy implements IList
	{
		private var _list:IList;
		
		
		/**
		 *
		 */
		public function ListProxy(list:IList)
		{
			this._list = list;
		}




		//
		// list methods
		//


		/**
		 *	@inheritDoc
		 */
		public function addItem(item:Object):void
		{
			this._list.addItem(item);
		}



		/**
		 *	@inheritDoc
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			this._list.addItemAt(item, index);
		}


		/**
		 *	@inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
			this._list.addItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			this._list.addItemsAt(collection, index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function containsItem(item:Object):Boolean
		{
			return this._list.containsItem(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
			return this._list.containsItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function equals(obj:Object):Boolean
		{
			return this._list.equals(obj);
		}


		/**
		 *	@inheritDoc
		 */
		public function getItemAt(index:uint):Object
		{
			return this._list.getItemAt(index);
		}


		/**
		 *	@inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return this._list.getItemIndex(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function getSubList(fromIndex:uint, toIndex:uint):IList
		{
			return this._list.getSubList(fromIndex, toIndex);
		}


		/**
		 *	@inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return this._list.isEmpty();
		}


		/**
		 *	@inheritDoc
		 */
		public function iterator():IIterator
		{
			return this._list.iterator();
		}


		/**
		 *	@inheritDoc
		 */
		public function get length():uint
		{
			return this._list.length;
		}


		/**
		 *	@inheritDoc
		 */
		public function listIterator(index:uint = 0):IListIterator
		{
			return this._list.listIterator(index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function removeAll():void
		{
			this._list.removeAll();
		}


		/**
		 *	@inheritDoc
		 */		
		public function removeItem(item:Object):Object
		{
			return this._list.removeItem(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			return this._list.removeItemAt(index);
		}


		/**
		 *	@inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			return this._list.removeItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
			return this._list.replaceItemAt(newItem, index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function retainItems(collection:ICollection):void
		{
			return this._list.retainItems(collection);
		}


		/**
		 *	@inheritDoc
		 */		
		public function toArray():Array
		{
			return this._list.toArray();
		}




		//
		// event dispatcher methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._list.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._list.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._list.hasEventListener(type);
		}


		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._list.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._list.willTrigger(type);
		}



		
	}
}