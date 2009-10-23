package inky.go.router 
{
	import inky.utils.PropertyChain;
	import inky.utils.Requirement;
	import flash.utils.describeType;
	import inky.go.request.IRequest;
	import inky.go.request.IRequestFormatter;
	import flash.events.Event;
	import inky.go.request.StandardRequestFormatter;

	
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
		private var _requestFormatter:IRequestFormatter;
		private var _requirements:Object;
		private var _requirementTester:Requirement;
		private var _trigger:String;
		
		/**
		 * 
		 */
		public function Route(trigger:String, defaults:Object = null, requirements:Object = null, requestFormatter:IRequestFormatter = null)
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
			this._requestFormatter = requestFormatter;
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
		public function get requestFormatter():IRequestFormatter
		{
			if (!this._requestFormatter)
				this._requestFormatter = new StandardRequestFormatter();

			return this._requestFormatter;
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
		public function formatRequest(event:Event):IRequest
		{
			var request:IRequest;
			if (this._trigger != event.type)
			{
				request = null;
			}
			else
			{
				request = this.requestFormatter.format(event, this.defaults);

				// Make sure the params meet the requirements.
				if (this._requirements && !this._requirementTester.test(request.params))
					request = null;
			}
				
			return request;
		}




	}
}