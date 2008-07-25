package inky.utils
{
	import inky.utils.Route;
	import inky.utils.SPath;


	/**
	 *
	 *  An object responsible for connecting routes.
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
		public function connect(path:String, sPath:SPath, defaultOptions:Object = null, requirements:Object = null):void
		{
			// If this SPath is already routed elsewhere, throw an error. If it
			// is routed to the same place, break.
			for each (var route:Route in this._routes)
			{
				if (route.path == path)
				{
					if (!route.sPath.equals(sPath))
					{
						throw new Error('Duplicate route: the path ' + path + ' cannot be routed to ' + sPath + ' because it is already routed to ' + route.sPath); 
					}
					else
					{
						// This route is already stored.
						return;
					}
				}
			}

			// Store the route.
			this._routes.push(new Route(path, sPath, defaultOptions, requirements));
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
				if (sPath.equals(route.sPath))
				{
					return route.match(url);
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
				if (route.sPath.equals(sPath))
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
