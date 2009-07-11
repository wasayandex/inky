package inky.collections
{
	import inky.collections.IIterator;


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
    public interface IListIterator extends IIterator
    {


		//
		// accessors
		//


		/**
		 *
		 * The index of the element that would be returned by a subsequent call
		 * to next, or list size if list iterator is at end of list.	 
		 *
		 */
		function get nextIndex():int;


		/**
		 *
		 * The index of the element that would be returned by a subsequent call
		 * to previous, or -1 if list iterator is at beginning of list.
		 *		 
		 */
		function get previousIndex():int;




		//
		// public methods
		//


		/**
		 *
		 * Inserts the specified element into the list (optional operation).
		 * The element is inserted immediately before the next element that
		 * would be returned by next, if any, and after the next element that
		 * would be returned by previous, if any. (If the list contains no
		 * elements, the new element becomes the sole element on the list.) The
		 * new element is inserted before the implicit cursor: a subsequent call
		 * to next would be unaffected, and a subsequent call to previous would
		 * return the new element. (This call increases by one the value that
		 * would be returned by a call to nextIndex  or previousIndex.)
		 * 
		 * @param item
		 *     the element to insert.
		 * @throws Error
		 *     if the add method is not supported by this list iterator.
		 * @throws Error
		 *     if the class of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if some aspect of this element prevents it from being added to
		 *     this list.		 		 		 		 		 	 
		 *
		 */		 		 		
		function addItem(item:Object):void;


		/**
		 *
		 * Returns true if this list iterator has more elements when traversing
		 * the list in the reverse direction. (In other words, returns true if
		 * previous would return an element rather than throwing an exception.)
		 * 
		 * @return
		 *     true if the list iterator has more elements when traversing the
		 *     list in the reverse direction.		 		 		 	 
		 *
		 */
		function hasPrevious():Boolean;


		/**
		 *
		 * Returns the previous element in the list. This method may be called
		 * repeatedly to iterate through the list backwards, or intermixed with
		 * calls to next to go back and forth. (Note that alternating calls to
		 * next and previous will return the same element repeatedly.)
		 * 
		 * @return
		 *     the previous element in the list.
		 * @throws Error
		 *     if the iteration has no previous element.		 		 		 		 		 		 
		 *
		 */
		function previous():Object;


		/**
		 *
		 * Replaces the last element returned by next or previous with the
		 * specified element (optional operation). This call can be made only if
		 * neither ListIterator.remove nor ListIterator.add have been called
		 * after the last call to next or previous.
		 * 
		 * @param newItem
		 *     the element with which to replace the last element returned by
		 *     next or previous.
		 * @throws Error
		 *     if the set operation is not supported by this list iterator. 
		 * @throws Error
		 *     if the class of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if some aspect of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if neither next nor previous have been called, or remove or add
		 *     have been called after the last call to next or previous.		 		 		 		 		 		 
		 *
		 */
		function replaceRetrievedItem(newItem:Object):Object;




    }
}
