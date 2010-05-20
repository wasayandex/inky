package inky.orm 
{
	import inky.collections.IIterable;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.09.28
	 *
	 */
	public interface IDatabase
	{
		/**
		 *	
		 */
		function getItems(tableName:String):IIterable;


		/**
		 *	
		 */
		function findFirst(conditions:Object):Object;


		/**
		 *	
		 */
		function insert(tableName:String, dto:Object, updateOnDuplicateKey:Boolean = false):void;

// TODO: Provide a method for setting the primary key for a specific table.


	}
}