package inky.routing
{
	import inky.app.SPath;
	import inky.utils.Debugger;
	import inky.routing.Route;


	/**
	 *
	 *  An object responsible for connecting routes. This class should be
	 *	considered an implementation detail and is subject to change.
	 * 
	 * 	@langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Eric Eldredge
	 *  @author Matthew Tretter
	 *  @since  2007.11.02
	 *
	 */
	public class RouteMapper
	{
		private var _routes:Array;
		
		
		/**
		 *
		 * Creates a new RouteMapper
		 * 
		 */
		public function RouteMapper()
		{
			this._routes = [];
		}




		//
		// public methods
		//


		/**
		 *
		 * Connects a given path to a section.
		 *
		 * @param url
		 * @param sPath
		 * @param defaultOptions
		 *     (optional)
		 * @param requirements
		 *     (optional)
		 * 
		 */
		public function connect(path:String, sPath:SPath, defaultOptions:Object = null, requirements:Object = null):Route
		{
			// Store the route.
			var route:Route = new Route(path, sPath.clone() as SPath, defaultOptions, requirements);
			this._routes.push(route);
			return route;
		}


		/**
		 *	
		 *	@private
		 *	TODO: Unshifts the route instead of pushing it.  This is being used when an overrideURL is in effect.
		 *	Eventually, we should look into whether connect should push or unshift, and hopefully get rid of this function.
		 *	
		 */
		public function connect2(path:String, sPath:SPath, defaultOptions:Object = null, requirements:Object = null):Route
		{
			// Store the route.
			var route:Route = new Route(path, sPath.clone() as SPath, defaultOptions, requirements);
			this._routes.unshift(route);
			return route;
		}


		/**
		 *
		 * Parses the options from a url for a given SPath
		 *
		 * @param url
		 * @param sPath
		 *
		 * @return
		 *     a hash containing the dynamic parts of the url
		 * 
		 */
		public function getOptions(url:String, sPath:SPath):Object
		{
			// Get the route that matches the sPath.
			for each (var route:Route in this._routes)
			{
				var match:Object = route.match(url);
				if (match)
				{
					return match;
				}
			}
	
			throw new ArgumentError('The url ' + url + ' is not routed to any section');
		}


		/**
		 *
		 * Get the SPath of the section associated with a given url.
		 *
		 * @param url
		 * 
		 * @return SPath
		 *     the SPath associated with the given url
		 * 
		 */
		public function getSPath(url:String):SPath
		{
			// Find the SPath that matches this route.
			for each (var route:Route in this._routes)
			{
				if (route.match(url))
				{
					return route.sPath;
				}
			}

			throw new ArgumentError('The url ' + url + ' is not routed to any section');
		}


		/**
		 *
		 * Returns the URL associated with a section and set of options.
		 * 
		 * @param sPath
		 *     the sPath of the section
		 * @param options
		 *     a hash map of options
		 *
		 * @return
		 *     the url
		 * 
		 */
		public function getURL(sPath:SPath, options:Object):String
		{
			var foundMatch:Boolean = false;

			for each (var route:Route in this._routes)
			{
				if (route.isRouteFor(sPath, options))
				{
					foundMatch = true;
					break;
				}
			}

			if (!foundMatch)
			{
				// No route was found.
				return null;
			}

			return route.generateURL(options);
		}




	}
}
