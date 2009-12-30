package inky.app 
{
	import inky.routing.request.IRequest;
	import flash.utils.getDefinitionByName;
	import inky.app.IRequestHandler;
	import inky.utils.describeObject;
	import inky.utils.CloningUtil;
	import inky.app.commands.ICommand;

	
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
	public class RequestHandler implements IRequestHandler
	{


		
		//
		// public methods
		//
		
		
		/**
		 *	@inheritDoc
		 */
		public function handleRequest(request:IRequest):void
		{
			if (!request.params.context)
				throw new ArgumentError("No context for request.");

			if (!request.params.action)
				throw new ArgumentError("Action not defined for request.");

			// Create an object that represents the command parameters:
			var params:Object = CloningUtil.clone(request.params);
			delete params.action;
			delete params.context;
			
			// Create the command from the context and action.
			var cmd:ICommand = this.createCommand(request.params.context, request.params.action);

cmd.execute(params);
//trace(describeObject(params, true));			
		}
		
		

		
		protected function createCommand(context:String, action:String):ICommand
		{
import commands.SearchWeb;
			return new SearchWeb();
		}



	}
	
}