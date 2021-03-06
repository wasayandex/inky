package inky.collections
{
	import inky.collections.AbstractListIterator;
	import inky.collections.IList;


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
    public class ListIterator extends AbstractListIterator
    {


		/**
		 *
		 *
		 *
		 */		 		 		 		
		public function ListIterator(target:IList, index:int = 0)
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
			this._target.addItemAt(item, index);
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
			return this._target.getItemAt(index);
		}


		/**
		 * @private
		 */
		override protected function removeItemAt(index:int):Object
		{
			return this._target.removeItemAt(index);
		}


		/**
		 * @private
		 */
		override protected function replaceItemAt(newItem:Object, index:int):Object
		{
			return this._target.replaceItemAt(newItem, index);
		}




    }
}
