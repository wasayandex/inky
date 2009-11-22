package inky.app 
{
	import inky.routing.request.IRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.28
	 *
	 */
	public class RequestDispatcher
	{
		// TODO: How to manage this pacakge information??
		public var controllerPackage:Array = ["inky.app.controllers"];



		
		//
		// public methods
		//
		
		
		/**
		 *	
		 */
		public function handleRequest(request:IRequest):void
		{
			if (!request.params.controller)
				throw new ArgumentError("Controller not defined for request.");

			if (!request.params.action)
				throw new ArgumentError("Action not defined for request.");

			// Get the controller.
			var controllerClass:Class;
			for (var i:int = 0; (i < this.controllerPackage.length) && !controllerClass; i++)
			{
				try
				{
					var controllerName:String = this.formatController(this.controllerPackage[i], request.params.controller);
				 	controllerClass = Class(getDefinitionByName(controllerName));
				}
				catch(error:Error)
				{
					var error:Error = error;
				}
			}

// TODO: use a default controller class instead?
			if (!controllerClass)
				throw error;
			
// TODO: type controller?
			var controller:* = new controllerClass();

			// Get the action.
			var action:String = this.formatAction(request.params.action);

// TODO: delete controller and action props from params object. (?)
			controller.dispatch(action, request.params);
		}
		
		

		
		//
		// private methods
		//


		/**
		 *	
		 */
		private function formatController(controllerPackage:String, name:String):String
		{
			return controllerPackage + "." + name.replace(/^(\w)/, function(){ return arguments[1].toUpperCase(); }) + "Controller";
		}


		/**
		 *	
		 */
		private function formatAction(name:String):String
		{
			return name + "Action";
		}




	}
	
}