package inky.framework.collections
{
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
    public interface IIterator
    {
		//
		// public methods
		//


		/**
		 *
		 * Returns true if the iteration has more elements. (In other words,
		 * returns true if next would return an element rather than throwing an
		 * exception.)
		 * 
		 * @return
		 *     true if the iterator has more elements.
		 *		 		 		 
		 */
		function hasNext():Boolean;


		/**
		 *
		 * Returns the next element in the iteration.
		 * 
		 * @return
		 *     the next element in the iteration.
		 * @throws Error
		 *     iteration has no more elements.		 		 		 		 		 		 
		 *
		 */
		function next():Object;


		/**
		 *
		 * Removes from the underlying collection the last element returned by
		 * the iterator (optional operation). This method can be called only
		 * once per call to next. The behavior of an iterator is unspecified if
		 * the underlying collection is modified while the iteration is in
		 * progress in any way other than by calling this method.
		 *
		 * @throws Error
		 *     if the remove operation is not supported by this Iterator.		 
		 * @throws Error
		 *     if the next method has not yet been called, or the remove method
		 *     has already been called after the last call to the next method.
		 *		 		 
		 */
		function removeRetrievedItem():void;




    }
}
