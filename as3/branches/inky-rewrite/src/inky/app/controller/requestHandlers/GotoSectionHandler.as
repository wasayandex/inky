package inky.app.controller. requestHandlers 
{
	import inky.app.controller.IApplicationController;
	import inky.app.controller. requestHandlers.IRequestHandler;
	import inky.app.controller.requests.GotoSection;
	import inky.app.controller.requests.CancelQueuedCommands;
	import inky.app.controller.requests.TransitionToCommonAncestor;
	import inky.app.controller.requests.TransitionTo;
	import inky.utils.describeObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 * 
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
				var requests:Array = [
					new CancelQueuedCommands(),
					new TransitionToCommonAncestor(request.section),
					new TransitionTo(request.section)
				];
				for each (var r:Object in requests)
					this._applicationController.handleRequest(r);
			}
			return request;
		}

		
	}
	
}