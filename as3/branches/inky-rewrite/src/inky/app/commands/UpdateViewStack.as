package inky.app.commands 
{
	import inky.commands.ChainableCommand;
	import inky.app.controller.IApplicationController;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import inky.utils.describeObject;
	import inky.routing.request.IRequest;
	
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
		private var _model:Object;

		
		/**
		 *
		 */
		public function UpdateViewStack(applicationController:IApplicationController, viewStack:Object, model:Object)
		{
			this._applicationController = applicationController;
			this._viewStack = viewStack;
			this._model = model;
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function execute(params:Object = null):Boolean
		{
			if (params.hasOwnProperty("action"))
			{
				var action:String = params.action;
				var sPath:Object = params.hasOwnProperty("sPath") ? params.sPath : "/";
				switch (action)
				{
					case "transitionToCommonAncestor":
					{
						this._transitionToCommonAncestor(sPath);
						break;
					}
					case "transitionTo":
					{
						this._transitionTo(sPath);
						break;
					}
					case "cancelQueuedActions":
					{
						this._cancelQueuedActions();
						break;
					}
				}
			}

			return true;
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _cancelQueuedActions():void
		{
			
		}

		
		/**
		 * 
		 */
		private function _transitionTo(sPath:Object):void
		{
trace("transitioning to " + sPath)
		}
		
		
		/**
		 * 
		 */
		private function _transitionToCommonAncestor(sPath:Object):void
		{
trace("transitioning to the common ancestor for " + sPath)
			
		}
		



	}
	
}