package inky.app.bootstrapper 
{
	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;
	import inky.dynamic.DynamicObject;


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
	dynamic public class BootstrapperConfig extends DynamicObject
	{
		private var _appName:String;
		private var _applicationControllerClass:String;
		private var _applicationDataSource:String;
		private var _bootstrapperDependencies:Array;
		private var _loaderInfo:LoaderInfo;
		
		
		/**
		 *
		 */
		public function BootstrapperConfig(loaderInfo:LoaderInfo)
		{
			this._loaderInfo = loaderInfo;
			this._appName = this._loaderInfo.loaderURL.split("/").pop().toString().split(".").slice(0, -1).join(".");
		}




		//
		// accessors
		//


		/**
		 *
		 */
		public function get applicationControllerClass():String
		{
			 if (!this._applicationControllerClass)
				this._applicationControllerClass = "inky.app.controller.StandardApplicationController";
			return this._applicationControllerClass; 
		}
		/**
		 * @private
		 */
		public function set applicationControllerClass(value:String):void
		{
// FIXME: This should not be allowed to be changed after the config is frozen!
			this._applicationControllerClass = value;
		}


		/**
		 * 
		 */
		public function get applicationDataSource():String
		{
			if (!this._applicationDataSource)
				this._applicationDataSource = this._appName + ".inky.xml";
			return this._applicationDataSource;
		}


		/**
		 * 
		 */
		public function get bootstrapperDependencies():Array
		{
			if (!this._bootstrapperDependencies && this._loaderInfo)
			{
				var value:String = this._loaderInfo.parameters.bootstrapperDependencies;
				this._bootstrapperDependencies = value ? value.split(";") : [];
			}
			return this._bootstrapperDependencies.concat();
		}


	}
	
}
