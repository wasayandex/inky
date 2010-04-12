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
	import inky.routing.router.IRouter;
//!	import inky.app.controller.IApplicationController;
	import inky.app.bootstrapper.events.BootstrapperEvent;
	import inky.app.data.IApplicationData;

	
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
//!		private var _applicationController:IApplicationController;
		private var _applicationData:IApplicationData;
		private var _rawApplicationData:String;
		private var _config:Object;
		private var _frontController:IFrontController;
		private var _loadQueue:LoadQueue;
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
		/*public function get applicationController():IApplicationController
		{ 
			return this._applicationController || (this._applicationController = this.createApplicationController()); 
		}*/


		/**
		 *
		 */
		public function get applicationData():IApplicationData
		{
			return this._applicationData || (this._applicationData = this.createApplicationData(this._rawApplicationData));
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

			var appDataSource:String = this.config.applicationDataSource;
			var dependencies:Array = this.config.bootstrapperDependencies;

			if ((appDataSource != null) || dependencies)
			{
				// Create the load queue.
				var lq:LoadQueue =
				this._loadQueue = new LoadQueue();
				lq.addEventListener(Event.COMPLETE, this._initNow);

				// Add the data loader to the load queue.
				var dataLoader:URLLoader = new URLLoader();
				dataLoader.addEventListener(Event.COMPLETE, this._appDataReadyHandler);
				lq.addItem(dataLoader, new URLRequest(appDataSource));				

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
		private function _appDataReadyHandler(event:Event):void
		{
			// Save the loaded data.
			this._rawApplicationData = event.currentTarget.data;

			// Clean up.
			event.currentTarget.removeEventListener(event.type, arguments.callee);
		}
		
		
		/**
		 * 
		 */
		private function _handleRequest(request:Object):void
		{
import inky.utils.describeObject;
trace(describeObject(request));
//!			this.applicationController.handleRequest(request);
		}


		/**
		 * 
		 */
		private function _initNow(event:Event):void
		{
			if (event)
				event.currentTarget.removeEventListener(event.type, arguments.callee);

			// Make sure the application controller is created.
//!			if (!this.applicationController)
//!				throw new Error("Application has not been created!");

			if (this.dispatchEvent(new BootstrapperEvent(BootstrapperEvent.STARTUP, true)))
				this.onStartup();

//!			this.applicationController.initialize(this.applicationData, this.stage);
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
		/*protected function createApplicationController():IApplicationController
		{
			// Create the application controller.
			var applicationControllerClass:Class;
			var className:String = this._config.applicationControllerClass;
			
			if (className)
			{
				try
				{
					applicationControllerClass = getDefinitionByName(className) as Class;
				}
				catch (error:Error)
				{
					throw new Error("Could not find application controller class " + className);
				}
			}
			else
			{
				try
				{
					applicationControllerClass = getDefinitionByName("inky.app.controller.StandardApplicationController") as Class;
				}
				catch (error:Error)
				{
					throw new Error("Could not find StandardApplicationController and no custom application controller was set!");
				}
			}

			var applicationController:IApplicationController = new applicationControllerClass();
			return applicationController;
		}*/


		/**
		 * 
		 */
		protected function createApplicationData(data:Object):IApplicationData
		{
			var applicationDataClass:Class = getDefinitionByName("inky.app.data.ApplicationData") as Class;
			var applicationData:Object = new applicationDataClass(new XML(data as String));
			if (!(applicationData is IApplicationData))
				throw new Error();
			return applicationData as IApplicationData;
		}


		/**
		 * 
		 */
		protected function createFrontController():IFrontController
		{
			// Create the Router.
			var routerClass:Class = getDefinitionByName("inky.routing.router.Router") as Class;
			var router:IRouter = new routerClass();

			// Create the front controller.
			var addressFCClass:Class = getDefinitionByName("inky.routing.AddressFrontController") as Class;
			var fcClass:Class = getDefinitionByName("inky.routing.FrontController") as Class;
			var frontController:IFrontController = new addressFCClass(new fcClass(this.stage, router, this._handleRequest));

			return frontController;
		}


		/**
		 * 
		 */
		protected function onStartup():void
		{
		}




	}
	
}