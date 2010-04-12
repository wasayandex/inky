package inky.collections
{
	import inky.collections.AbstractListIterator;


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
    public class ArrayIterator extends AbstractListIterator
    {


		/**
		 *
		 *
		 *
		 */		 		 		 		
		public function ArrayIterator(target:Array, index:int = 0)
		{
			super(target, index);
		}



		//
		// protected methods
		//


		/**
		 * @private
		 */
		override protected function addItemAt(item:Object, index:int):void
		{
			this._target.splice(index, 0, item);
		}


		/**
		 * @private
		 */
		override protected function getLength():int
		{
			return this._target.length;
		}	


		/**
		 * @private
		 */
		override protected function getItemAt(index:int):Object
		{
			return this._target[index];
		}


		/**
		 * @private
		 */
		override protected function removeItemAt(index:int):Object
		{
			return this._target.splice(index, 1);
		}


		/**
		 * @private
		 */
		override protected function replaceItemAt(newItem:Object, index:int):Object
		{
			return this._target.splice(index, 1, newItem)[0];
		}




    }
}
