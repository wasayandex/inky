package inky.collections
{
	import inky.collections.IList;
	import inky.collections.IListIterator;


	/**
	 *
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.06.21
	 *
	 */
    public class AbstractListIterator implements IListIterator
    {
// TODO: Protect from instantiation?
    	private var _allowRemove:Boolean;
		private var _index:int;
		private var _removeOffset:int;
		protected var _target:Object;


		/**
		 *
		 *
		 */
		public function AbstractListIterator(target:Object, index:int = 0)
		{
			this._target = target;
			this._index = index;
			
			if ((index < 0) || (index > this.getLength()))
			{
				throw new ArgumentError('Index out of bounds. Index: ' + index);
			}
		}		 		 		




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get nextIndex():int
		{
			return this._index;
		}


		/**
		 * @inheritDoc
		 */
		public function get previousIndex():int
		{
			return this._index - 1;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */	 		 		
		public function addItem(item:Object):void
		{
			this._allowRemove = false;
			this.addItemAt(item, this._index++);
		}


		/**
		 * @inheritDoc
		 */
		public function hasNext():Boolean
		{
			return this._index < this.getLength();
		}


		/**
		 * @inheritDoc
		 */
		public function hasPrevious():Boolean
		{
			return this._index != 0;
		}


		/**
		 * @inheritDoc
		 */
		public function next():Object
		{
			if (!this.hasNext())
			{
				throw new Error('No such element');
			}
			this._allowRemove = true;
			this._removeOffset = 1;
			return this.getItemAt(this._index++);
		}


		/**
		 * @inheritDoc
		 */
		public function previous():Object
		{
			if (!this.hasPrevious())
			{
				throw new Error('No such element');
			}
			this._allowRemove = true;
			this._removeOffset = 0;
			return this.getItemAt(--this._index);
		}


		/**
		 * @inheritDoc
		 */
		public function removeRetrievedItem():void
		{
			if (!this._allowRemove)
			{
				throw new Error('Illegal State: IListIterator.removeRetrievedItem may only be called if neither IListIterator.removeRetrievedItem nor ListIterator.addItem have been called after the last call to next or previous.');
			}
			this._allowRemove = false;
			this._index -= this._removeOffset;
			this.removeItemAt(this._index);
		}


		/**
		 * @inheritDoc
		 */
		public function replaceRetrievedItem(newItem:Object):Object
		{
			if (!this._allowRemove)
			{
				throw new Error('Illegal State: IListIterator.replaceRetrievedItem may only be called if neither IListIterator.removeRetrievedItem nor ListIterator.addItem have been called after the last call to next or previous.');
			}
			return this.replaceItemAt(newItem, this._index - this._removeOffset);
		}




		//
		// protected methods
		//


		/**
		 *
		 *
		 */
		protected function addItemAt(item:Object, index:int):void
		{
			throw new Error('addItemAt() must be overridden by subclass');
		}


		/**
		 *
		 *
		 */
		protected function getItemAt(index:int):Object
		{
			throw new Error('getItemAt() must be overridden by subclass');
		}


		/**
		 *
		 *
		 */
		protected function getLength():int
		{
			throw new Error('getLength() must be overridden by subclass');
		}		 				

		/**
		 *
		 *
		 */
		protected function removeItemAt(index:int):Object
		{
			throw new Error('removeItemAt() must be overridden by subclass');
		}


		/**
		 *
		 *
		 */
		protected function replaceItemAt(newItem:Object, index:int):Object
		{
			throw new Error('replaceItemAt() must be overridden by subclass');
		}




    }
}
