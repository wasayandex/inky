package inky.go.request
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.22
	 *
	 */
	public class Request implements IRequest
	{
		private var _params:Object;


		/**
		 *
		 */
		public function Request(params:Object = null)
		{
			this._params = params || {};
		}




		//
		// accessors
		//


		/**
		 *  @inheritDoc
		 */
		public function get params():Object	{ return this._params; }




	}
	
}
