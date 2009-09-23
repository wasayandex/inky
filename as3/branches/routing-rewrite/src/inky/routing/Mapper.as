package inky.routing 
{
	import flash.utils.Dictionary;
	import inky.routing.Route;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2008.09.22
	 *
	 */
	public class Mapper
	{
		private var _names2Routes:Object;
		private var _routes:Array;
		private var _routes2Callbacks:Dictionary;


		/**
		 *
		 */
		public function Mapper()
		{
			this._names2Routes = {};
			this._routes = [];
			this._routes2Callbacks = new Dictionary(true);
		}




		//
		// public methods
		//


		/**
		 *	
		 */
		public function connect(pattern:String, callback:Function, defaults:Object = null, requirements:Object = null):void
		{
			var route:Route = new Route(pattern, defaults, requirements);
			this._routes.push(route);
			this._routes2Callbacks[route] = callback;
		}
		
		
		/**
		 *	
		 */
		public function connectNamed(name:String, pattern:String, callback:Function, defaults:Object = null, requirements:Object = null):void
		{
			var route:Route = new Route(pattern, defaults, requirements);
			this._routes.push(route);
			this._routes2Callbacks[route] = callback;
			if (this._names2Routes[name])
				throw new ArgumentError("A route named " + name + " has already been connected!");
			else
				this._names2Routes[name] = route;
		}


		/**
		 *	
		 */
		public function root(callback:Function, defaults:Object = null, requirements:Object = null):void
		{
			this.connectNamed("root", "#", callback, defaults, requirements);
		}




	}
}