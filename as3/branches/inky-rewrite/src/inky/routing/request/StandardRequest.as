package inky.routing.request 
{
	import flash.events.Event;
	import flash.utils.describeType;
	import inky.routing.request.IRequestWrapper;


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
	dynamic public class StandardRequest implements IRequestWrapper
	{
		
		
		/**
		 *
		 */
		public function StandardRequest(request:Object = null)
		{
			this._wrap(request);
		}



		/**
		 *	
		 */
		private function _wrap(request:Object):void
		{
			if (!request)
				return;

			// Perform the mapping.

			var propName:String;
			
// FIXME: Yikes, this is some costly stuff. How to improve?
			var typeDescription:XML = describeType(request);
			var properties:XMLList = typeDescription.variable + typeDescription.accessor;
			for each (var prop:XML in properties.(@type == "String" || @type == "Number" || @type == "Boolean" || @type == "uint" || @type == "int"))
			{
				propName = prop.@name;
				switch (propName)
				{
					case "eventPhase":
					case "bubbles":
					case "cancelable":
					case "type":
					{
						// ignore event properties.
						if (request is Event)
							break;
					}
					default:
					{
						this[propName] = request[propName];
						break;
					}
				}
			}
			
			// Also map the enumerable properties.
			for (propName in request)
				this[propName] = request[propName];
		}


	}
	
}