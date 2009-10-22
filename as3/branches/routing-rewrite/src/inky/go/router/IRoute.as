package inky.go.router 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.22
	 *
	 */
	public interface IRoute
	{
		/**
		 *	
		 */
		function match(obj:Object):Object;



		/**
		 *
		 */
		function get defaults():Object;


		/**
		 *
		 */
		function get requirements():Object;


		/**
		 *	
		 */
		function get triggers():Array;

		
	}
	
}
