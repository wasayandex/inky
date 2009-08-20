package inky.collections
{
	import inky.collections.IIterable;
	import inky.utils.IEquatable;
	import flash.events.IEventDispatcher;


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
    public interface ICollection extends IEquatable, IIterable, IEventDispatcher
    {


		//
		// accessors
		//


		/**
		 *
		 * The number of elements in this collection. If this collection
		 * contains more than uint.MAX_VALUE elements, returns uint.MAX_VALUE.
		 *
		 */
		function get length():uint;




		//
		// public methods
		//


		/**
		 *
		 * Adds an item to the collection.
		 * 
		 * @param item
		 *     The element to add to the collection.
		 * @throws Error
		 *     add is not supported by this collection.
		 * @throws Error
		 *     class of the specified element prevents it from being added to
		 *     this collection.	
		 * @throws Error
		 *     if the specified element is null and this collection does not
		 *     support null elements.
		 * @throws Error
		 *     some aspect of this element prevents it from being added to this
		 *     collection.		 		 		 		 	 		 		 		 
		 *		 
		 */		 		 		
		function addItem(item:Object):void;
		
		
		/**
		 *
		 * Adds all of the elements in the specified collection to this
		 * collection (optional operation). The behavior of this operation is
		 * undefined if the specified collection is modified while the operation
		 * is in progress. (This implies that the behavior of this call is
		 * undefined if the specified collection is this collection, and this
		 * collection is nonempty.)
		 * 
		 * @param collection
		 *     elements to be inserted into this collection.
		 * @throws Error
		 *     if this collection does not support the addAll method.
		 * @throws Error
		 *     if the class of an element of the specified collection prevents
		 *     it from being added to this collection.
		 * @throws Error
		 *     if the specified collection contains one or more null elements
		 *     and this collection does not support null elements, or if the
		 *     specified collection is null.
		 * @throws Error
		 *     some aspect of an element of the specified collection prevents it
		 *     from being added to this collection.		 		 
		 *		 
		 */
		function addItems(collection:ICollection):void;
		
		
		/**
		 *
		 * Returns true if this collection contains the specified element.
		 * 
		 * @param item
		 *     element whose presence in this collection is to be tested.
		 * @return
		 *     true if this collection contains the specified element
		 * @throws Error
		 *     if the type of the specified element is incompatible with this
		 *     collection (optional).
		 * @throws Error
		 *     if the specified element is null and this collection does not
		 *     support null elements (optional).
		 *		 		 		 
		 */		 		 		
		function containsItem(item:Object):Boolean;
		
		
		/**
		 *
		 * Returns true if this collection contains all of the elements in the
		 * specified collection.
		 * 
		 * @param collection
		 *     collection to be checked for containment in this collection.
		 * @return
		 *     true if this collection contains all of the elements in the
		 *     specified collection
		 * @throw Error
		 *     if the types of one or more elements in the specified collection
		 *     are incompatible with this collection (optional).
		 * @throw Error
		 *     if the specified collection contains one or more null elements
		 *     and this collection does not support null elements (optional).
		 * @throw Error
		 *     if the specified collection is null.		 		 		 		 
		 *
		 */
		function containsItems(collection:ICollection):Boolean;
		
		
		/**
		 *
		 * Returns true if this collection contains no elements.
		 * 
		 * @return
		 *     true if this collection contains no elements		 		 		 
		 *		 
		 */
		function isEmpty():Boolean;
// FIXME: Shoudl probably be an as-style getter (i.e. get isEmpty)
		
		/**
		 *
		 * Removes all of the elements from this collection (optional
		 * operation). This collection will be empty after this method returns
		 * unless it throws an exception.
		 * 
		 * @throws Error
		 *     if the clear method is not supported by this collection.		 		 		 
		 *
		 */
		function removeAll():void;
		
		
		/**
		 *
		 * Removes a single instance of the specified element from this
		 * collection, if it is present (optional operation).
		 * 
		 * @param item
		 *     element to be removed from this collection, if present.
		 * @return
		 *     true if this collection changed as a result of the call
		 * @throws Error
		 *     if the type of the specified element is incompatible with this
		 *     collection (optional).
		 * @throws Error
		 *     if the specified element is null and this collection does not
		 *     support null elements (optional).
		 * @throws Error
		 *     remove is not supported by this collection.		 		 		 		 
		 *		 		 		 
		 */		 		 		
		function removeItem(item:Object):Object;
		
		
		/**
		 *
		 * Removes all this collection's elements that are also contained in the
		 * specified collection (optional operation). After this call returns,
		 * this collection will contain no elements in common with the specified
		 * collection.
		 * 
		 * @param collection
		 *     elements to be removed from this collection.
		 * @return
		 *     true if this collection changed as a result of the call
		 * @throw Error
		 *     if the removeAll method is not supported by this collection.
		 * @throw Error
		 *     if the types of one or more elements in this collection are
		 *     incompatible with the specified collection (optional).
		 * @throw Error
		 *     if this collection contains one or more null elements and the
		 *     specified collection does not support null elements (optional).
		 * @throw Error
		 *     if the specified collection is null.		 		 		 		 
		 *
		 */
		function removeItems(collection:ICollection):void;
		
		
		/**
		 *
		 * Retains only the elements in this collection that are contained in
		 * the specified collection (optional operation). In other words,
		 * removes from this collection all of its elements that are not
		 * contained in the specified collection.
		 * 
		 * @param collection
		 *     elements to be retained in this collection.
		 * @throws Error
		 *     if the retainAll method is not supported by this Collection.
		 * @throws Error
		 *     if the types of one or more elements in this collection are
		 *     incompatible with the specified collection (optional).
		 * @throws Error
		 *     if this collection contains one or more null elements and the
		 *     specified collection does not support null elements (optional).
		 * @throws Error
		 *     if the specified collection is null.		 		 		 		 		 		 
		 *		 
		 */
		function retainItems(collection:ICollection):void;
		
		
		/**
		 *
		 * <p>Returns an array containing all of the elements in this
		 * collection. If the collection makes any guarantees as to what order
		 * its elements are returned by its iterator, this method must return
		 * the elements in the same order.</p>
		 * <p>The returned array will be "safe" in that no references to it are
		 * maintained by this collection. (In other words, this method must
		 * allocate a new array even if this collection is backed by an array).
		 * The caller is thus free to modify the returned array.</p>
		 * <p>This method acts as bridge between array-based and
		 * collection-based APIs.</p>
		 * 
		 * @return
		 *     an array containing all of the elements in this collection		 		 		  
		 *		 
		 */
		function toArray():Array;




    }
}
