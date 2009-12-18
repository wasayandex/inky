package inky.app.bootstrapper
{
	config namespace INKY;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import inky.app.controllers.ApplicationController;
	import inky.app.IApplication;
	import inky.routing.IFrontController;
	import flash.utils.getDefinitionByName;
	import inky.app.IRequestDispatcher;
	import inky.app.model.DefaultApplicationModelFactory;
	import inky.app.model.IApplicationModelFactory;
	import inky.routing.router.IRouter;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.16
	 *
	 */
	public class Bootstrapper
	{
		private var _application:IApplication;
		private var _applicationModel:Object;
		private var _applicationModelFactory:IApplicationModelFactory;
		private var _applicationController:*;
		private var _frontController:IFrontController;
		private var _requestDispatcher:IRequestDispatcher;
		private var _configData:Object;
		private var _configLoader:URLLoader;


		/**
		 *
		 */
		public function Bootstrapper(application:IApplication)
		{
			this._application = application;
		}




		//
		// accessors
		//


		/**
		 *
		 */
		public function get application():IApplication
		{ 
			return this._application; 
		}


		/**
		 *
		 */
		public function get applicationController():*
		{ 
			return this._applicationController || (this._applicationController = this.createApplicationController()); 
		}


		/**
		 *
		 */
		public function get applicationModel():Object
		{
			if (!this._applicationModel)
			{
				if (!this.applicationModelFactory)
					throw new Error("Could not create application model: applicationModelFactory has not been set!");
				
				if (this._configData)
				{
					this._applicationModel = this.applicationModelFactory.createModel(this._configData);
					this._configData = null;
				}
				else
				{
					this._applicationModel = this.applicationModelFactory.createModel();
				}
			}
				
			return this._applicationModel;
		}


		/**
		 *
		 */
		public function get applicationModelFactory():IApplicationModelFactory
		{ 
			return this._applicationModelFactory || (this._applicationModelFactory = new DefaultApplicationModelFactory()); 
		}
		/**
		 * @private
		 */
		public function set applicationModelFactory(value:IApplicationModelFactory):void
		{
			this._applicationModelFactory = value;
		}


		/**
		 *
		 */
		public function get frontController():IFrontController
		{ 
			return this._frontController || (this._frontController = this.createFrontController()); 
		}


		/**
		 *
		 */
		public function get requestDispatcher():IRequestDispatcher
		{ 
			return this._requestDispatcher || (this._requestDispatcher = this.createRequestDispatcher()); 
		}




		//
		// public methods
		//


		/**
		 *	
		 */
		public function initialize():void
		{
			if (!this.application.stage)
				throw new Error("You cannot call initialize() until the application is on stage.");
			
			var loaderInfo:LoaderInfo = this.application.stage.root.loaderInfo;
// TODO: Allow other ways to set the dataSource.
			var dataSource:String = loaderInfo.parameters.dataSource || loaderInfo.loaderURL.split(".").slice(0, -1).join(".") + ".inky.xml";
			
			var loader:URLLoader =
			this._configLoader = new URLLoader();
// TODO: Add error handlers.
			loader.addEventListener(Event.COMPLETE, this._configLoaderCompleteHandler);
			loader.load(new URLRequest(dataSource));
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _configLoaderCompleteHandler(event:Event):void
		{
			// Save the loaded data for use by the model.
			this._configData = event.currentTarget.data;
			
			// Clean up.
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._configLoader = null;
			
// Preload assets
			
			// Initialize the front controller.
trace(this.frontController);
		}




		//
		// protected methods
		//


		/**
		 * 
		 */
		protected function createApplicationController():*
		{
			var applicationControllerClass:Class = getDefinitionByName("inky.application.controllers.ApplicationController") as Class;
			var applicationController:* = new applicationControllerClass(this.application, this.applicationModel);
			return applicationController;
		}


		/**
		 * 
		 */
		protected function createFrontController():IFrontController
		{
			// Create the Router.
			var routerClass:Class = getDefinitionByName("inky.routing.router.Router") as Class;
			var router:IRouter = new routerClass();

			if (!this.requestDispatcher)
				throw new Error("No request dispatcher found!");

			// Create the front controller.
			var addressFCClass:Class = getDefinitionByName("inky.routing.AddressFrontController") as Class;
			var fcClass:Class = getDefinitionByName("inky.routing.FrontController") as Class;
			var frontController:IFrontController = new addressFCClass(new fcClass(this.application, router, this.requestDispatcher.handleRequest));

			return frontController;
		}


		/**
		 * 
		 */
		protected function createRequestDispatcher():IRequestDispatcher
		{
			var dispatcherClass:Class = getDefinitionByName("inky.app.RequestDispatcher") as Class;
			return new dispatcherClass();
		}




	}
	
}