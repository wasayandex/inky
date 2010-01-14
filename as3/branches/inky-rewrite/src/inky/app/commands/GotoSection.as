package inky.app.commands 
{
	import inky.commands.ChainableCommand;
	import inky.app.controller.IApplicationController;
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
	public class GotoSection extends ChainableCommand
	{
		private var _applicationController:IApplicationController;
		
		
		/**
		 *
		 */
		public function GotoSection(applicationController:IApplicationController)
		{
			this._applicationController = applicationController;
		}
		
		
		

		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function execute(params:Object = null):Boolean
		{
			if (params.hasOwnProperty("action") && params.action == "gotoSection")
			{
				var sPath:Object = params.hasOwnProperty("sPath") ? params.sPath : "/";
				
				this._applicationController.executeCommand({action: "cancelQueuedCommands"});
				this._applicationController.executeCommand({action: "transitionToCommonAncestor", sPath: sPath});
// Preload assets?
				this._applicationController.executeCommand({action: "transitionTo", sPath: sPath});
			}
			
			
			return true;
		}

		
	}
	
}