package inky.go 
{
	import inky.utils.PropertyChain;
	import inky.utils.Requirement;
	import flash.utils.describeType;
	
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
	public class Route
	{
		private var _argumentMap:Object;
		private var _defaults:Object;
		private var _requirements:Object;
		private var _requirementTester:Requirement;
		private var _triggers:Array;
		
		/**
		 *
		 * @param argumentMap An object that defines the mapping from the event
		 * type to the action arguments object. Properties represent the target
		 * of the mapping. The values are property-chain-style values.
		 * @see inky.utils.PropertyChain
		 * 
		 * 
		 */
		public function Route(triggers:Object, defaults:Object = null, requirements:Object = null, argumentMap:Object = null)
		{
// FIXME: Last argument should be an adapter object. (Simple one should be creatable with argument map). Then again, maybe just also allow a function?
			if (triggers is String)
				this._triggers = [triggers];
			else if (triggers is Array)
				this._triggers = triggers.concat();
			else
				throw new ArgumentError();
			
			if (typeof argumentMap != "object")
				throw new ArgumentError("Invalid arguments map!");
				
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
			
			this._requirements = requirements;
			this._requirementTester = new Requirement(requirements);
			this._argumentMap = argumentMap;
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
		public function get requirements():Object
		{ 
			return this._requirements; 
		}


		/**
		 *	
		 */
		public function get triggers():Array
		{
			return this._triggers;
		}




		//
		// public methods
		//


		/**
		 *	
		 */
		public function match(obj:Object):Object
		{
			var match:Object;
			if (this._triggers.indexOf(obj.type) == -1)
			{
				match = null;
			}
			else
			{
				match = {};
				var p:String;
			
				// Map the event to an args object.
				if (this._argumentMap)
				{
					for (p in this._argumentMap)
					{
						match[p] = PropertyChain.evaluateChain(obj, this._argumentMap[p]);
					}
				}
				else
				{
					// Perform the default event -> args mapping.
// FIXME: Yikes, this is some costly stuff. How to improve?
					match = {};
					var typeDescription:XML = describeType(obj);
					var properties:XMLList = typeDescription.variable + typeDescription.accessor;
					for each (var prop:XML in properties.(@type == "String" || @type == "Number" || @type == "Boolean" || @type == "uint" || @type == "int"))
					{
						var propName:String = prop.@name;
						switch (propName)
						{
							case "eventPhase":
							case "bubbles":
							case "cancelable":
							{
								// ignore event properties.
								break;
							}
							case "type":
							{
								match.action = this.defaults.action == null ? obj[propName] : this.defaults.action;
								break;
							}
							default:
							{
								match[propName] = obj[propName];
								break;
							}
						}
					}
				}

				// Apply the defaults.
				for (p in this._defaults)
					if (match[p] == null)
						match[p] = this._defaults[p];
			
				// Make sure it meets the requirements.
				if (this._requirements && !this._requirementTester.test(match))
					match = null;
			}

			return match;
		}




	}
}