package inky.app
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import inky.app.bootstrapper.Bootstrapper;
	import inky.app.model.ApplicationModel;
	import inky.app.IApplication;
	import inky.serialization.deserializers.IDeserializer;
	
	/**
	 *
	 *  The Application contains all other sections. Application instances
	 *	correspond to the root node of an inky XML.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class LightApplication extends MovieClip implements IApplication
	{
		private var _applicationModelDeserializer:IDeserializer;
		private var _bootstrapper:Bootstrapper;
		private var _controller:Object;
		private var _model:Object;
		
		public static var debug:Boolean;
		
		
		/**
		 * Creates a new Application instance. The Application constructor should
		 * never be called directly, however. Instead, it should be used as the
		 * document class of your project's FLA.
		 */
		public function LightApplication()
		{
			if (!this.stage)
				throw new Error("Application must be the document class!");
			
			this.stage.addEventListener(Event.RENDER, this._initialize);
			this.stage.invalidate();
		}
		
		
		

		//
		// accessors
		//


		/**
		 *
		 */
		public function get model():Object
		{ 
			return this._model; 
		}
		/**
		 * @private
		 */
		public function set model(value:Object):void
		{
			this._model = value;
		}

		
		
		
		//
		// private methods
		//
			
		
		/**
		 *	
		 */
		private function _initialize(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			
			if (!this.model)
			{
				this._bootstrapper = new Bootstrapper(this);
				this._bootstrapper.initialize();
			}
		}
		


		
	}
	
}