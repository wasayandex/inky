package inky.routing.router 
{
	import flash.events.Event;
	import inky.app.inky;
	import inky.utils.getClass;
	import inky.routing.request.IRequestWrapper;
	import inky.routing.router.IEventRoute;
	import inky.conditions.PropertyConditions;

	
	/**
	 *
	 *  An object that maps an event to action arguments.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.24
	 *
	 */
	public class EventRoute implements IEventRoute
	{
		private var _defaults:Object;
		private var _requestWrapper:Object;
		private var _requirements:PropertyConditions;
		private var _triggers:Array;
		
		/**
		 * 
		 */
		public function EventRoute(triggers:Object, requestWrapper:Object = null, defaults:Object = null, requirements:Object = null)
		{
			// Create the requirements object.
			var requirements:Object = requirements || {};
			for (var requirementName:String in requirements)
			{
				var r:Object = requirements[requirementName];
				var requirement:RegExp;
				if (r is String)
					requirement = new RegExp(r as String);
				else if (r is RegExp)
					requirement = r as RegExp;
				else
					throw new ArgumentError();
				requirements[requirementName] = requirement;
			}
			
			if (triggers is Array)
				this._triggers = triggers as Array;
			else if (triggers is String)
				this._triggers = [triggers];
			else
				throw new ArgumentError("The first argument of the EventRoute constructor must be either a String or Array of Strings.");

			this._requestWrapper = requestWrapper;
			this._requirements = new PropertyConditions(requirements);
			this._defaults = defaults || {};
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get defaults():Object
		{ 
			return this._defaults; 
		}


		/**
		 * @inheritDoc
		 */
		public function get requestWrapper():Object
		{
			return this._requestWrapper;
		}


		/**
		 * @inheritDoc
		 */
		public function get requirements():Object
		{ 
			return this._requirements; 
		}


		/**
		 * @inheritDoc
		 */
		public function get triggers():Array
		{
			return this._triggers;
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		public function formatRequest(oldRequest:Object):Object
		{
			var request:Object;
			if (oldRequest is Event && this._triggers.indexOf(oldRequest.type) != -1)
				request = this.wrapRequest(oldRequest);
			else
				request = null;
			return request;
		}
		
		
		/**
		 * 
		 */
		protected function wrapRequest(wrappee:Object):Object
		{
			var request:Object;
			
			if (this.requestWrapper)
			{
				var wrapper:Class = getClass(this.requestWrapper);
				if (!wrapper)
			 		throw new Error(this.requestWrapper + " not found!");

				request = new wrapper(wrappee);

				if (!(request is IRequestWrapper))
					throw new Error(this.requestWrapper + " does not implement IRequestWrapper");
			}
			else
				request = wrappee;

			for (var p:String in this.defaults)
				if (request[p] == null)
					request[p] = this.defaults[p];

			// Make sure the params meet the requirements.
			if (this._requirements && !this._requirements.test(request))
				request = null;
		
			return request;
		}




	}
}