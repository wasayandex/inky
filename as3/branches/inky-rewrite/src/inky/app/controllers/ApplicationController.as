package inky.app.controllers
{
	import inky.app.inky;
	import inky.routing.IFrontController;
	import inky.app.IApplication;

	
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
		private var _frontController:IFrontController;
		private var _model:Object;
		private var _view:IApplication;

		use namespace inky;

		/**
		 *
		 */
		public function ApplicationController(view:IApplication, model:Object)
		{
			this._model = model;
			this._view = view;
		}







		//
		// private methods
		//
		

		

	}
	
}