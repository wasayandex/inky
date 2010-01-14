package inky.app 
{
	import inky.routing.request.IRequest;
	import inky.app.IRequestHandler;
	import inky.utils.CloningUtil;
	import inky.app.controller.IApplicationController;

	
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
		private var _applicationController:IApplicationController;
		
		/**
		 *
		 */
		public function RequestHandler(applicationController:IApplicationController)
		{
			this._applicationController = applicationController;
		}


		

		//
		// public methods
		//
		
		
		/**
		 *	@inheritDoc
		 */
		public function handleRequest(request:IRequest):void
		{
			var params:Object = CloningUtil.clone(request.params);
			this._applicationController.executeCommand(params);
		}




	}
	
}