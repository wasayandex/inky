package inky.app.controllers
{
	import inky.app.inky;
	import inky.routing.router.Router;
	import inky.routing.AddressFrontController;
	import inky.routing.FrontController;
	import inky.routing.IFrontController;
	import inky.app.Application;
	import inky.app.RouteParser;
	import inky.app.RequestDispatcher;
	import inky.app.controllers.SectionController;
	import inky.app.ViewStack;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class ApplicationController
	{
		private var _application:Application;
		private var _frontController:IFrontController;

// FIXME: how does this get compiled in? 		
SectionController;

		use namespace inky;

		/**
		 *
		 */
		public function ApplicationController(application:Application)
		{
			ViewStack.initialize(application);

			this._application = application;
			this._parseData(application.model.data);
		}
		
		


		//
		// private methods
		//

		
		/**
		 *	
		 */
		private function _parseData(data:XML):void
		{
// TODO: MarkupObjectManager? 
			if (data.Section.length())
			{
				// Create the Router.
				var router:Router = new Router();
				// Parse the routes from the data (and map them).
				new RouteParser(router).parseData(data);
				
				// Create the RequestDispatcher.
				var dispatcher:RequestDispatcher = new RequestDispatcher();
				
				// Create the FrontController.
				this._frontController = new AddressFrontController(new FrontController(this._application, router, dispatcher.handleRequest));
			}
		}
		

		

	}
	
}