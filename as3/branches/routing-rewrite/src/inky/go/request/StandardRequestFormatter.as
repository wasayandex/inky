package inky.go.request 
{
	import inky.go.request.IRequest;
	import inky.go.request.Request;
	import inky.utils.PropertyChain;
	import flash.events.Event;
	import flash.utils.describeType;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.10.22
	 *
	 */
	public class StandardRequestFormatter implements IRequestFormatter
	{
		private var _propertyMap:Object;
		
		
		/**
		 *
		 * @param propertyMap An object that defines the mapping from the event
		 * type to the ----????? object. Properties represent the target
		 * of the mapping. The values are property-chain-style values.
		 * @see inky.utils.PropertyChain
		 */
		public function StandardRequestFormatter(propertyMap:Object = null)
		{
			this._propertyMap = propertyMap;
		}



		/**
		 *	@inheritDoc
		 */
		public function format(event:Event, defaults:Object = null):IRequest
		{
// TODO: Allow other request classes.
			var request:IRequest = new Request();
			defaults = defaults || {};
			var p:String;

			// Map the event to the request params.
			if (this._propertyMap)
			{
				for (p in this._propertyMap)
				{
					request.params[p] = PropertyChain.evaluateChain(event, this._propertyMap[p]);
				}
			}
			else
			{
				// Perform the default event -> params mapping.
// FIXME: Yikes, this is some costly stuff. How to improve?
				var typeDescription:XML = describeType(event);
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
							request.params.action = defaults.action == null ? event[propName] : defaults.action;
							break;
						}
						default:
						{
							request.params[propName] = event[propName];
							break;
						}
					}
				}
			}

			// Apply the defaults.
			for (p in defaults)
				if (request.params[p] == null)
					request.params[p] = defaults[p];

			return request;
		}


	}
	
}