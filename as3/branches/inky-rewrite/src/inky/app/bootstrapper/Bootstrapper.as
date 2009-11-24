package inky.app.bootstrapper
{
	import flash.display.Stage;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import inky.serialization.deserializers.IDeserializer;
	import inky.app.bootstrapper.XMLApplicationModelDeserializer;
	import inky.app.model.ApplicationModel;
	import inky.app.IApplication;
	import inky.routing.IFrontController;
	import inky.app.bootstrapper.ConfigDataDeserializer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
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
		private var _applicationModelDeserializer:IDeserializer;
		private var _config:Object;
		private var _configDataDeserializer:IDeserializer;
		private var _configLoader:URLLoader;
		private var _stage:Stage;


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
		 *  Gets and sets the object responsible for deserializing the application model. If none is set, returns an XMLApplicationModelDeserializer
		 */
		public function get applicationModelDeserializer():IDeserializer
		{
			if (!this._applicationModelDeserializer)
				this._applicationModelDeserializer = new XMLApplicationModelDeserializer();
			return this._applicationModelDeserializer; 
		}
		/**
		 * @private
		 */
		public function set applicationModelDeserializer(value:IDeserializer):void
		{
			this._applicationModelDeserializer = value;
		}


// FIXME: Not sure I like "config". Maybe "configOptions" or something would be better.
		/**
		 *
		 */
		public function get config():Object
		{ 
			return this._config; 
		}
		/**
		 * @private
		 */
		public function set config(value:Object):void
		{
			this._config = value;
		}


		/**
		 *
		 */
		public function get configDataDeserializer():IDeserializer
		{ 
			return this._configDataDeserializer || (this._configDataDeserializer = new ConfigDataDeserializer()); 
		}
		/**
		 * @private
		 */
		public function set configDataDeserializer(value:IDeserializer):void
		{
			this._configDataDeserializer = value;
		}




		//
		// public methods
		//


		/**
		 *	
		 */
		public function initialize():void
		{
			if (!this._application.stage)
				throw new Error("You cannot call initialize() until the application is on stage.");
			
			var loaderInfo:LoaderInfo = this._application.stage.root.loaderInfo;
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
			this.config = this.configDataDeserializer.deserialize(event.currentTarget.data);

			// Create the application controller
			var controllerClass:Class;
			try
			{
				if (this.config.applicationControllerClass)
					controllerClass = getDefinitionByName(this.config.applicationControllerClass) as Class;
				else
					controllerClass = getDefinitionByName(getQualifiedClassName(this._application) + "Controller") as Class;
			}
			catch (error:Error)
			{
// TODO: Use default?
				throw new Error("Could not find an application controller.");
			}

			// Create the application model.
			var applicationModel:ApplicationModel = this.applicationModelDeserializer.deserialize(event.currentTarget.data) as ApplicationModel;

			// Set the model on the application.
			this._application.model = applicationModel;
			// Set the controller on the application.
			this._application.controller = new controllerClass(this._application);

			// Clean up.
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._configLoader = null;
		}




	}
	
}