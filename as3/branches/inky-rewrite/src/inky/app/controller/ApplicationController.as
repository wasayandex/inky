package inky.app.controller 
{
	import inky.app.controller.IApplicationController;
	import inky.commands.IChain;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.05
	 *
	 */
	public class ApplicationController implements IApplicationController
	{
		private var _application:Object;
		private var _chain:IChain;
		private var _model:Object;
		
		/**
		 *
		 */
		public function ApplicationController(application:Object, model:Object, chain:IChain)
		{
			this._application = application;
			this._model = model;
			this._chain = chain;
		}
		
		
		

		//
		// accessors
		//


		/**
		 *
		 */
		public function get chain():IChain
		{ 
			return this._chain; 
		}
		

		
	}
	
}