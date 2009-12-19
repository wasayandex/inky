package inky.app.bootstrapper
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import inky.app.bootstrapper.BootstrapperConfig;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import inky.loading.LoadQueue;
	import inky.loading.loaders.RuntimeLibraryLoader;
	import inky.routing.IFrontController;
	import flash.utils.getDefinitionByName;
	import inky.app.IRequestDispatcher;
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
	public class LightBootstrapper extends Sprite
	{
		private var _applicationController:*;
		private var _applicationModel:Object;
		private var _applicationModelData:String;
		private var _config:Object;
		private var _frontController:IFrontController;
		private var _loadQueue:LoadQueue;
		private var _requestDispatcher:IRequestDispatcher;
		private var _stage:Stage;


		/**
		 *
		 */
		public function LightBootstrapper()
		{
			// Automatically initialize the bootstrapper.
			if (this.stage)
			{			
				this.stage.addEventListener(Event.RENDER, this._initialize);
				this.stage.invalidate();
			}
		}




		//
		// accessors
		//


		/**
		 * 
		 */
		public function get config():Object
		{
			return this._config || (this._config = new BootstrapperConfig(this.loaderInfo));
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
			return this._applicationModel || (this._applicationModel = this.createApplicationModel(this._applicationModelData));
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
		
		
		/**
		 * 
		 */
		override public function get stage():Stage
		{
			return this._stage || super.stage;
		}




		//
		// public methods
		//


		/**
		 * Initialize the bootstrapper. This is automatically called on the
		 * RENDER event if the bootstrapper is used as the document class.
		 * Otherwise, you must call it manually.
		 */
		public function initialize(stage:Stage = null):void
		{
			if (stage)
				this._stage = stage;

			if (!this.stage)
				throw new Error("The bootstrapper needs the stage!");

			// Prevent modifications to the config object.
			this.config.freeze();

			var appModelDataSource:String = this.config.applicationModelDataSource;
			var dependencies:Array = this.config.bootstrapperDependencies;

			if ((appModelDataSource != null) || dependencies)
			{
				// Create the load queue.
				var lq:LoadQueue =
				this._loadQueue = new LoadQueue();
				lq.addEventListener(Event.COMPLETE, this._initNow);

				// Add the model data loader to the load queue.
				var modelDataLoader:URLLoader = new URLLoader();
				modelDataLoader.addEventListener(Event.COMPLETE, this._appModelDataReadyHandler);
				lq.addItem(modelDataLoader, new URLRequest(appModelDataSource));				

				// Add the dependencies to the load queue.
				for each (var source:String in dependencies)
				{
					var loader:RuntimeLibraryLoader = new RuntimeLibraryLoader(source);
					lq.addItem(loader);
				}

				// Load the load queue.
				lq.load();
			}
			else
			{
				this._initNow(null);
			}
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _appModelDataReadyHandler(event:Event):void
		{
			// Save the loaded data for use by the model.
			this._applicationModelData = event.currentTarget.data;

			// Clean up.
			event.currentTarget.removeEventListener(event.type, arguments.callee);
		}


		/**
		 * 
		 */
		private function _initNow(event:Event):void
		{
			if (event)
				event.currentTarget.removeEventListener(event.type, arguments.callee);

			// Register the routes from the application model.
			for each (var route:* in applicationModel.routes)
				this.frontController.router.addRoute(route);

			this.frontController.initialize();
		}


		/**
		 * 
		 */
		private function _initialize(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (this.stage)
				this.initialize(this.stage);
		}




		//
		// protected methods
		//


		/**
		 * 
		 */
		protected function createApplicationController():*
		{
return null;
			/*var applicationControllerClass:Class = getDefinitionByName("inky.app.controllers.ApplicationController") as Class;
			var applicationController:* = new applicationControllerClass(this.application, this.applicationModel);
			return applicationController;*/
		}


		/**
		 * 
		 */
		protected function createApplicationModel(data:Object):Object
		{
			var applicationModelClass:Class = getDefinitionByName("inky.app.model.ApplicationModel") as Class;
			var applicationModel:Object = new applicationModelClass(data);
			return applicationModel;
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
			var frontController:IFrontController = new addressFCClass(new fcClass(this.stage, router, this.requestDispatcher.handleRequest));

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