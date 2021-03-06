package inky.app.bootstrapper 
{
	import inky.app.bootstrapper.LightBootstrapper;
	import inky.routing.AddressFrontController;
	import inky.routing.FrontController;
	import inky.routing.router.Router;
	import inky.app.data.ApplicationData;
	import inky.app.controller.StandardApplicationController;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.18
	 *
	 */
	public class Bootstrapper extends LightBootstrapper
	{
		// Force the compilation of some classes that the bootstrapper uses by
		// default. This class makes it easy to get an application running
		// quickly. However, if you really want to minimize your initial load,
		// it's best to use LightBootstrapper and load these classes in as
		// runtime libraries.
		ApplicationData;
		AddressFrontController;
		FrontController;
		Router;
//!		StandardApplicationController;
	}
	
}