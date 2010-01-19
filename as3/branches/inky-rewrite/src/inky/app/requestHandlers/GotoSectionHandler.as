package inky.app.requestHandlers 
{
	import inky.app.controller.IApplicationController;
	import inky.app.requestHandlers.IRequestHandler;
	import inky.app.requests.GotoSection;
	import inky.app.requests.CancelQueuedCommands;
	import inky.app.requests.TransitionToCommonAncestor;
	import inky.app.requests.TransitionTo;
	import inky.utils.describeObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.12
	 *
	 */
	public class GotoSectionHandler implements IRequestHandler
	{
		private var _applicationController:IApplicationController;
		
		
		/**
		 *
		 */
		public function GotoSectionHandler(applicationController:IApplicationController)
		{
			this._applicationController = applicationController;
		}
		
		
		

		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):Object
		{
			if (request is GotoSection)
			{
trace("GotoSectionHandler:");
trace("\t" + describeObject(request).replace(/\n/g, "\n\t"));
				var requests:Array = [
					new CancelQueuedCommands(),
					new TransitionToCommonAncestor(request.section),
					new TransitionTo(request.section)
				];
				for each (var r:Object in requests)
					this._applicationController.handleRequest(r);
			}
else
{
	trace("GotoSectionHandler (ignored):");
	trace("\t" + describeObject(request).replace(/\n/g, "\n\t"));
}
			return request;
		}

		
	}
	
}