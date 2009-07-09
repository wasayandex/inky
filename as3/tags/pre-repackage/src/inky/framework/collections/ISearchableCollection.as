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
    public interface ISearchableCollection extends ICollection
    {

		/**
		 *
		 *	
		 */
		function find(filter:Object):ICollection;


    }
}
