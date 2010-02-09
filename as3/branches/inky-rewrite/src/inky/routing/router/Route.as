package inky.routing.router 
{
	import inky.utils.Requirement;
	import flash.events.Event;
	import inky.routing.request.StandardRequest;
	import inky.app.inky;
	import inky.utils.getClass;
	import inky.routing.request.IRequestWrapper;

	
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
	public class Route implements IRoute
	{
		private var _defaults:Object;
		private var _requestWrapper:Object;
		private var _requirements:Object;
		private var _requirementTester:Requirement;
		private var _trigger:String;
		
		/**
		 * 
		 */
		public function Route(trigger:String, defaults:Object = null, requirements:Object = null, requestWrapper:Object = null)
		{
			// Create the requirements object.
			var requirements:Object = {};
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
			
			this._trigger = trigger;
			this._requestWrapper = requestWrapper;
			this._requirements = requirements;
			this._requirementTester = new Requirement(requirements);
			this._defaults = defaults || {};
		}




		//
		// accessors
		//


		/**
		 *
		 */
		public function get defaults():Object
		{ 
			return this._defaults; 
		}


		/**
		 *	
		 */
		public function get requestWrapper():Object
		{
			if (!this._requestWrapper)
				this._requestWrapper = StandardRequest;

			return this._requestWrapper;
		}


		/**
		 *
		 */
		public function get requirements():Object
		{ 
			return this._requirements; 
		}


		/**
		 *	
		 */
		public function get trigger():String
		{
			return this._trigger;
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		public function createRequest(event:Event):Object
		{
			var request:Object;
			if (this._trigger != event.type)
				request = null;
			else
				request = this.wrapRequest(event);

			return request;
		}
		
		
		/**
		 * 
		 */
		protected function wrapRequest(wrappee:Object):Object
		{
			var wrapper:Class = getClass(this.requestWrapper);
			if (!wrapper)
			 	throw new Error(this.requestWrapper + " not found!");

			var request:Object = new wrapper(wrappee);

			if (!(request is IRequestWrapper))
				throw new Error(this.requestWrapper + " does not implement IRequestWrapper");

			for (var p:String in this.defaults)
				if (request[p] == null)
					request[p] = this.defaults[p];

			// Make sure the params meet the requirements.
			if (this._requirements && !this._requirementTester.test(request))
				request = null;
		
			return request;
		}




	}
}