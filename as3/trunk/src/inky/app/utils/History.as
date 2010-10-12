package inky.app.utils
{
	import inky.collections.IQueue;
	import inky.collections.ArrayList;
	import inky.collections.ICollection;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.10.11
	 *
	 */
	public class History extends ArrayList implements IQueue
	{
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function getHeadItem():Object
		{
			return this.length ? super.getItemAt(0) : null;
		}

		/**
		 * @inheritDoc
		 */
		public function offerItem(item:Object):Boolean
		{
			super.addItemAt(item, 0);
			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function removeHeadItem():Object
		{
			return this.length ? super.removeItemAt(0) : null;
		}

		//---------------------------------------
		// ILIST / ICOLLECTION METHODS
		//---------------------------------------

		private static const ADD_ERROR:String = "Cannot add items to history. Use offerItem instead.";
		private static const REMOVE_ERROR:String = "Cannot remove items from history. Use removeHeadItem instead.";
		
		override public function addItem(item:Object):void { throw new Error(ADD_ERROR); }
		override public function addItemAt(item:Object, index:int):void { throw new Error(ADD_ERROR); }
		override public function addItems(collection:ICollection):void { throw new Error(ADD_ERROR); }
		override public function addItemsAt(collection:ICollection, index:int):void { throw new Error(ADD_ERROR); }
		override public function removeAll():void { throw new Error(REMOVE_ERROR); }
		override public function removeItem(item:Object):Object { throw new Error(REMOVE_ERROR); }
		override public function removeItemAt(index:int):Object { throw new Error(REMOVE_ERROR); }
		override public function removeItems(collection:ICollection):void { throw new Error(REMOVE_ERROR); }
		override public function replaceItemAt(newItem:Object, index:int):Object { throw new Error(REMOVE_ERROR); }
		override public function retainItems(collection:ICollection):void { throw new Error(REMOVE_ERROR); }
		
	}
	
}