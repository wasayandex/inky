package inky.app 
{
	import inky.app.LightApplication;
	import inky.routing.router.Router;
	import inky.app.RequestDispatcher;
	import inky.routing.FrontController;
	import inky.routing.AddressFrontController;
	
	/**
	 *
	 *  A version of IApplication that includes common Bootstrapper dependencies. If you want to load those dependencies at runtime, use LightApplication
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.18
	 *
	 */
	public class Application extends LightApplication
	{
		AddressFrontController;
		FrontController;
		RequestDispatcher;
		Router;
	}
	
}