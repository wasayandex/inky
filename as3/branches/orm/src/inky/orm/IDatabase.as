package inky.orm 
{

	
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
		function insert(tableName:String, dto:Object, updateOnDuplicateKey:Boolean = false):void;

// TODO: Provide a method for setting the primary key for a specific table.


	}
}
