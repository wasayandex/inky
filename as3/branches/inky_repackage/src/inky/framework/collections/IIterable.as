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
    public interface IIterable
    {

		/**
		 *
		 * Returns an iterator over the elements in this collection. There are
		 * no guarantees concerning the order in which the elements are returned
		 * (unless this collection is an instance of some class that provides a
		 * guarantee).
		 * 
		 * @return
		 *     an Iterator over the elements in this collection		 
		 *
		 */
		function iterator():IIterator;


	}
}
