package inky.app
{
	import flash.display.MovieClip;
	import inky.app.IApplication;
	
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
	public class Application extends MovieClip implements IApplication
	{
		private var _model:Object;

		
		

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

		


		
	}
	
}