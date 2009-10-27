package  
{
	import inky.routing.request.*;
	import flash.utils.getDefinitionByName;
	
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
	public class RequestDispatcher
	{
		
		/**
		 *	
		 */
		public function handleRequest(request:IRequest):void
		{
			// Get the controller.
// TODO: throw error if no controller prop.
			var controllerName:String = this.formatController(request.params.controller);
// TODO: catch error if controllerClass doesn't exist
			var controllerClass:Class = Class(getDefinitionByName(controllerName));
// TODO: type controller?
			var controller:* = new controllerClass();
			
			// Get the action.
			var action:String = this.formatAction(request.params.action);
// TODO: throw error if no action prop.

// TODO: delete controller and action props from params object. (?)
// TODO: throw error if action function doesn't exist on controller.
trace("c: " + controller + "\ta: " + action)

			controller[action](request.params);
			//controller[action + "Action"](request.params);

		}


		/**
		 *	
		 */
		public function formatController(name:String):String
		{
// TODO: Actually format! (i.e. "unit" -> com.blah.Unit)
			return name;
		}


		/**
		 *	
		 */
		public function formatAction(name:String):String
		{
			return name;
		}

	
	}
	
}
