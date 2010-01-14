package inky.app.commands 
{
	import inky.commands.ChainableCommand;
	import inky.utils.describeObject;
	import inky.routing.request.IRequest;
	import inky.app.controller.IApplicationController;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.06
	 *
	 */
	public class RequestProcessor extends ChainableCommand
	{
		private var _applicationController:IApplicationController;

		/**
		 *
		 */
		public function RequestProcessor(applicationController:IApplicationController)
		{
			this._applicationController = applicationController;
		}


		/**
		 * @inheritDoc
		 */
		override public function execute(params:Object = null):Boolean
		{
			if (params is IRequest)
			{
				params = params.params;
//				if (params.view)
				this._applicationController.chain.start(params);
			}
			return true;
		}

		
	}
	
}