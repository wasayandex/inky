package inky.routing 
{
	import inky.routing.IRoute;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.05.26
	 *
	 */
	public class RouteInfo
	{
		private var _params:Object;
		private var _route:IRoute;
		
		/**
		 *
		 */
		public function RouteInfo(route:IRoute, params:Object = null)
		{
			this._route = route;
			this._params = params;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function get params():Object
		{
			return this._params;
		}
		
		/**
		 * 
		 */
		public function get route():IRoute
		{
			return this._route;
		}
		
		/**
		 * 
		 */
		public function get url():String
		{
// TODO: Cache value? Be careful — params might change.
			return this._route.generateAddress(this._params);
		}

	}
	
}