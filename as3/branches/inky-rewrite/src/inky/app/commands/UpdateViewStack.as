package inky.app.commands 
{
	import inky.commands.ChainableCommand;
	import inky.app.controller.IApplicationController;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	
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
	public class UpdateViewStack extends ChainableCommand
	{
		private var _applicationController:IApplicationController;
		private var _viewStack:Object;

		
		/**
		 *
		 */
		public function UpdateViewStack(applicationController:IApplicationController, viewStack:Object)
		{
			this._applicationController = applicationController;
			this._viewStack = viewStack;
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function execute(params:Object):Boolean
		{
			if (params.hasOwnProperty("view"))
			{
				var viewClass:Class = getDefinitionByName(params.view) as Class;
				this._viewStack.addChild(new viewClass());
			}
			return true;
		}
		

		
	}
	
}