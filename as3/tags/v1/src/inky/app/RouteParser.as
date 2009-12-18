package inky.app 
{
	import inky.routing.router.IRouter;
	import inky.app.inky;
	import inky.routing.router.AddressRoute;
	import inky.routing.request.StandardRequestFormatter;
	import inky.routing.request.IRequestFormatter;
	import inky.app.SPath;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class RouteParser
	{
		private var _router:IRouter;
		
		use namespace inky;

		/**
		 *
		 */
		public function RouteParser(router:IRouter)
		{
			this._router = router;
		}
		
		


		//
		// public methods
		//
		
		
		/**
		 *	
		 */
		public function parseData(data:XML):void
		{
			this._parseRoutes(data, SPath.parse("/"));
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _parseRoutes(section:XML, sPath:SPath):void
		{
			// Create an sPath for this section.
			var controller:String = section.@inky::controller.length() ? section.@inky::controller : section.@name;

			for each (var route:XML in section.inky::Route)
			{
				var addressPattern:String = route.@path;
// TODO: default trigger based on section name?
// What if a section has multiple routes? Would they all get the same default trigger?
				var trigger:String = route.@trigger;

// TODO: Let route specify controller?

// TODO: Get controller and action from the XML, and use these as defaults?
				var action:String = "index";

// TODO: Get defaults from XML.
				var defaults:Object = {};
				defaults.controller = controller;
				defaults.action = action;
				defaults.sPath = sPath;

// TODO: Get requirements from XML.
				var requirements:Object = {};
				
// TODO: How to define the RequestFormatter??
				var requestFormatter:IRequestFormatter = new StandardRequestFormatter();

				// Add a new Route to the Router.
				this._router.addRoute(new AddressRoute(addressPattern, trigger, defaults, requirements, requestFormatter));
			}
			
			// Recursively parse routes for subsections.
			if (section.Section.length())
			{
				for each (var subsection:XML in section.Section)
					this._parseRoutes(subsection, SPath.parse(subsection.@name).resolve(sPath));
			}
		}
		

		
	}
	
}