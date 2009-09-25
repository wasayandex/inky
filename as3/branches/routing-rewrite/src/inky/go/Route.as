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
		private var _requirements:Requirement;
		private var _trigger:String;
		
		/**
		 *
		 * @param argumentMap An object that defines the mapping from the event
		 * type to the action arguments object. Properties represent the target
		 * of the mapping. The values are property-chain-style values.
		 * @see inky.utils.PropertyChain
		 * 
		 * 
		 */
		public function Route(trigger:String, defaults:Object = null, requirements:Object = null, argumentMap:Object = null)
		{
			if (typeof argumentMap != "object")
				throw new ArgumentError("Invalid arguments map!");
			
			this._trigger = trigger;
			this._argumentMap = argumentMap;
			this._defaults = defaults || {};
			this._requirements = requirements ? new Requirement(requirements) : null;
		}


		/**
		 *	
		 */
		public function get trigger():String
		{
			return this._trigger;
		}


		/**
		 *	
		 */
		public function match(obj:Object):Object
		{
			var match:Object;
			if (!obj.type == this._trigger)
			{
				match = null;
			}
			else
			{
				match = {};
				var p:String;
			
				// Do the mapping, if necessary.
				if (this._argumentMap)
				{
					for (p in this._argumentMap)
					{
						match[p] = PropertyChain.evaluateChain(obj, this._argumentMap[p]);
					}
				}
				else
				{
	// FIXME: Yikes, this is some costly stuff. How to improve?
					match = {};
					var typeDescription:XML = describeType(obj);
					var properties:XMLList = typeDescription.variable + typeDescription.accessor;
					for each (var prop:XML in properties.(@type == "String" || @type == "Number" || @type == "Boolean" || @type == "uint" || @type == "int"))
					{
						var propName:String = prop.@name;
						match[propName] = obj[propName];
					}
				}

				// Apply the defaults.
				for (p in this._defaults)
					if (match[p] == null)
						match[p] = this._defaults[p];
			
				// Make sure it meets the requirements.
				if (this._requirements && !this._requirements.test(match))
					match = null;
			}

			return match;
		}




	}
}