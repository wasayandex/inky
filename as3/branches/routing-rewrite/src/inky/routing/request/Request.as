package inky.routing.request 
{
	import inky.routing.request.IRequest;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.10.23
	 *
	 */
	public class Request implements IRequest
	{
		private var _params:Object;


		/**
		 *
		 */
		public function Request()
		{
			this._params = {};
		}




		//
		// accessors
		//


		/**
		 *  @inheritDoc
		 */
		public function get params():Object { return this._params; }


	}
	
}