package inky.routing 
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
	public interface IRouter
	{
		
		
		/**
		 *	Map a Class to a url route.
		 * 
		 *  <p>The <code>commandClass</p> must implement an execute() method</p>
		 * 
		 * @param pattern A rails-style url patterm that begins with the hash symbol. (i.e. #/a/b/:myVar)
		 * @param commandClass The Class to instantiate - must have an execute() method
		 */
		function mapRoute(pattern:String, commandClass:Class, defaults:Object = null, requirements:Object = null):void;


		/**
		 * 
		 */
//		function unmapRoute(route:String, commandClass:Class):void;


		/**
		 *	
		 */
//		function route(request:Object):Object;
		
	}
	
}