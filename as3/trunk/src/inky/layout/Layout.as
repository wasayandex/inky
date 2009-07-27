package inky.layout
{
	import flash.geom.Rectangle;


	/**
	 *
	 * Defines a Layout. Layouts associate string ids (usually a
	 * DisplayObject's name) with a Rectangle (specifying a DisplayObject's
	 * placement and size) and a depth. Because layouts associate the bounds
	 * with an id (as opposed to object references), they are not technically
	 * tied to a specific group of DisplayObjects (which makes sense, given the
	 * definition of a layout). In practice, however, you will rarely have two
	 * groups of DisplayObjects with the same names.
	 *
	 */
	public class Layout
	{
// TODO: Update API so it's not in conflict with inky.collections.IList
// TODO: Rename this class? Get rid of it and use a map instead?
		private var _boundsList:Object;
		private var _idList:Array;




		public function Layout()
		{
			this._boundsList = {};
			this._idList = [];
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get length():uint
		{
			return this._idList.length;
		}




		//
		// public methods
		//


		/**
		 *
		 *
		 *
		 */
		public function addItem(id:String, bounds:Rectangle):Rectangle
		{
			if (!id)
			{
				throw new ArgumentError('Parameter id must be non-empty.');
			}
			var index:uint = this.containsId(id) ? this._idList.length - 1 : this._idList.length;
			return this.addItemAt(id, bounds, index);
		}


		/**
		 *
		 *
		 * @throws RangeError    Thrown if the index position does not exist in
		 *                       the layout list or if the index position would
		 *                       not exist after a replacement.
		 *
		 */
		public function addItemAt(id:String, bounds:Rectangle, index:uint):Rectangle
		{
			if (!id)
			{
				throw new ArgumentError('Parameter id must be non-empty.');
			}

			var replacedItem:Rectangle = this._boundsList[id];

			if (index && index < 0 || index > this.length - (replacedItem ? 1 : 0))
			{
				throw new RangeError('The supplied index is out of bounds.');
			}

			if (replacedItem)
			{
				this.removeItemById(id);
			}

			this._boundsList[id] = bounds;
			this._idList.splice(index, 0, id);
			return replacedItem;
		}


		/**
		 *
		 *
		 *
		 */
		public function getItemById(id:String):Rectangle
		{
			return this._boundsList[id];
		}


		/**
		 *
		 *
		 *
		 */
		public function getItemAt(index:uint):Rectangle
		{
			return this._boundsList[this._idList[index]];
		}


		/**
		 *
		 *
		 *
		 */
		public function removeItemById(id:String):Rectangle
		{
			if (!this._boundsList[id])
			{
				throw new ArgumentError('The supplied id is not present in layout.');
			}

			var index:uint = this._idList.indexOf(id);
			return this._removeItemAt(index);
		}


		/**
		 *
		 *
		 *
		 */
		public function removeItemAt(index:uint):Rectangle
		{
			if (index && index < 0 || index >= this.length)
			{
				throw new RangeError('The supplied index is out of bounds.');
			}

			return this._removeItemAt(index);
		}


		/**
		 *
		 *
		 *
		 */
		private function _removeItemAt(index:uint):Rectangle
		{
			// Remove the id from the list of ids.
			var id:String = this._idList.splice(index, 1)[0];

			// Remove the item's bounds from the list of bounds.
			var removedItem:Rectangle = this._boundsList[id];
			delete this._boundsList[id];

			return removedItem;
		}


		/**
		 *
		 *
		 *
		 */
		public function containsId(id:String):Boolean
		{
			return this._boundsList[id] ? true : false;
		}


		/**
		 *
		 *
		 *
		 */
		public function getItemIndex(id:String):uint
		{
			var index:int = this._idList.indexOf(id);
			if (index == -1)
			{
				throw new ArgumentError('The supplied id is not present in layout.');
			}
			return index;
		}


		/**
		 *
		 *
		 *
		 */
		public function getItemId(index:uint):String
		{
			return this._idList[index];
		}




	}
}
