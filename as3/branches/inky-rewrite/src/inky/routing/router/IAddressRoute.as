package inky.routing.router 
{
	import inky.routing.router.IRoute;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.02.09
	 *
	 */
	public interface IAddressRoute extends IRoute
	{
		
		/**
		 * Generates a url for this route using the provided options Object.
		 * Returns the url associated with this Route, with the dynamic parts
		 * replaced with the values in the options object.	
		 */
		function generateAddress(request:Object = null):String;


	}
	
}