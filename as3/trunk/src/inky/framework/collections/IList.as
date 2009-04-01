package inky.framework.collections
{
	import inky.framework.collections.ICollection;


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
    public interface IList extends ICollection
    {
		//
		// public methods
		//


		/**
		 *
		 * Inserts the specified element at the specified position in this list
		 * (optional operation). Shifts the element currently at that position
		 * (if any) and any subsequent elements to the right (adds one to their
		 * indices).
		 * 
		 * @param item
		 *     element to be inserted.
		 * @param index
		 *     index at which the specified element is to be inserted.
		 * @throws Error
		 *     if the add method is not supported by this list.
		 * @throws Error
		 *     if the class of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if the specified element is null and this list does not support
		 *     null elements.
		 * @throws Error
		 *     if some aspect of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if the index is out of range (index > length).		 		 		 		 		 		 		 
		 *
		 */		 		 		
		function addItemAt(item:Object, index:uint):void


		/**
		 *
		 * Inserts all of the elements in the specified collection into this
		 * list at the specified position (optional operation). Shifts the
		 * element currently at that position (if any) and any subsequent
		 * elements to the right (increases their indices). The new elements
		 * will appear in this list in the order that they are returned by the
		 * specified collection's iterator. The behavior of this operation is
		 * unspecified if the specified collection is modified while the
		 * operation is in progress. (Note that this will occur if the specified
		 * collection is this list, and it's nonempty.)
		 * 
		 * @param collection
		 *     collection whose elements are to be added to this list.
		 * @param index
		 *     index at which to insert first element from the specified collection.
		 * @throws Error
		 *     if the addItems method is not supported by this list.
		 * @throws Error
		 *     if the class of one of elements of the specified collection
		 *     prevents it from being added to this list.
		 * @throws Error
		 *     if the specified collection contains one or more null elements
		 *     and this list does not support null elements, or if the specified
		 *     collection is null.
		 * @throws Error
		 *     if some aspect of one of elements of the specified collection
		 *     prevents it from being added to this list.
		 * @throws Error
		 *     if the index is out of range (index > length).		 		 
		 *		 
		 */
		function addItemsAt(collection:ICollection, index:uint):void;
		
		
		/**
		 *
		 * Returns the element at the specified position in this list.
		 * 
		 * @param index
		 *     index of element to return.
		 * @return
		 *     the element at the specified position in this list.
		 * @throws Error
		 *     if the index is out of range (index >= length).		 		 		 		 		 		 		 		 
		 *
		 */
		function getItemAt(index:uint):Object;
		
		
		/**
		 *
		 * Returns the index in this list of the first occurrence of the
		 * specified element, or -1 if this list does not contain this element.
		 * 
		 * @param item
		 *     element to search for.
		 * @return
		 *     the index in this list of the first occurrence of the specified
		 *     element, or -1 if this list does not contain this element.
		 * @throws Error
		 *     if the type of the specified element is incompatible with this
		 *     list (optional).
		 * @throws Error
		 *     if the specified element is null and this list does not support
		 *     null elements (optional).		 		 
		 *
		 */
		function getItemIndex(item:Object):int;


		/**
		 *
		 * <p>Returns a view of the portion of this list between the specified
		 * fromIndex, inclusive, and toIndex, exclusive. (If fromIndex and
		 * toIndex are equal, the returned list is empty.) The returned list is
		 * backed by this list, so non-structural changes in the returned list
		 * are reflected in this list, and vice-versa. The returned list
		 * supports all of the optional list operations supported by this list.
		 * </p>
		 * 		 
		 * <p>This method eliminates the need for explicit range operations (of
		 * the sort that commonly exist for arrays). Any operation that expects
		 * a list can be used as a range operation by passing a subList view
		 * instead of a whole list. For example, the following idiom removes a
		 * range of elements from a list:</p>
		 * 
		 * <listing>
		 * list.getSubList(from, to).clear();
		 * </listing>
		 * 
		 * <p>Similar idioms may be constructed for indexOf and lastIndexOf, and
		 * all of the algorithms in the Collections class can be applied to a
		 * subList.</p>
		 * 
		 * <p>The semantics of the list returned by this method become undefined
		 * if the backing list (i.e., this list) is structurally modified in any
		 * way other than via the returned list. (Structural modifications are
		 * those that change the size of this list, or otherwise perturb it in
		 * such a fashion that iterations in progress may yield incorrect
		 * results.)</p>
		 * 
		 * @param fromIndex
		 *     low endpoint (inclusive) of the subList.
		 * @param toIndex
		 *     high endpoint (exclusive) of the subList.
		 * @return
		 *     a view of the specified range within this list.
		 * @throws RangeError
		 *     for an illegal endpoint index value (toIndex > length ||
		 *     fromIndex > toIndex).		 		 		 		 		 		 		 		 		  
		 *		 
		 */
		function getSubList(fromIndex:uint, toIndex:uint):IList

		
		/**
		 *
		 * Returns a list iterator of the elements in this list (in proper
		 * sequence).
		 * 
		 * @return
		 *     a list iterator of the elements in this list (in proper
		 *     sequence).		 		 		 
		 *
		 */
		function listIterator(index:uint = 0):IListIterator;
		
		
		/**
		 *
		 * Removes the element at the specified position in this list (optional
		 * operation). Shifts any subsequent elements to the left (subtracts one
		 * from their indices). Returns the element that was removed from the
		 * list.
		 * 
		 * @param index
		 *     the index of the element to removed.
		 * @return
		 *     the element previously at the specified position.
		 * @throws Error
		 *     if the remove method is not supported by this list.
		 * @throws RangeError
		 *     if the index is out of range (index >= length).		 		 		 		 		 		 		 		 		 		 
		 *
		 */
		function removeItemAt(index:uint):Object;
		
		
		/**
		 *
		 * Replaces the element at the specified position in this list with the
		 * specified element (optional operation).
		 * 
		 * @param newItem
		 *     element to be stored at the specified position.		 
		 * @param index
		 *     index of element to replace.		 
		 * @return
		 *     the element previously at the specified position.
		 * @throws Error
		 *     if the set method is not supported by this list.
		 * @throws Error
		 *     if the class of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if the specified element is null and this list does not support
		 *     null elements.
		 * @throws Error
		 *     if some aspect of the specified element prevents it from being
		 *     added to this list.
		 * @throws Error
		 *     if the index is out of range (index >= length).		 		 	 		 		 		 
		 *
		 */
		function replaceItemAt(newItem:Object, index:uint):Object;

		
		

    }
}
