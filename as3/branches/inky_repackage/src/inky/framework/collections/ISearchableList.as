package inky.framework.collections
{
	import inky.framework.collections.IList;
	import inky.framework.collections.ISearchableCollection;


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
    public interface ISearchableList extends IList, ISearchableCollection
    {

		/**
		 *
		 *	Works like ISearchableCollection.find(), but only returns the first
		 *	match.
		 *	
		 *	@see inky.framework.collections.ISearchableCollection#find();
		 *	
		 */
		function findFirst(filter:Object):Object;


    }
}
