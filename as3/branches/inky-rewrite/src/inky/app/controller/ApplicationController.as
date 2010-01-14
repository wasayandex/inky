package inky.app.controller 
{
	import inky.app.controller.IApplicationController;
	import inky.app.commands.UpdateViewStack;
	import inky.app.commands.GotoSection;
	import inky.app.model.IApplicationModel;
	import inky.commands.collections.CommandChain;
	import inky.app.commands.ProcessCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.05
	 *
	 */
	public class ApplicationController implements IApplicationController
	{
		private var _commandChain:CommandChain;
		
		/**
		 *
		 */
		public function ApplicationController(application:Object, model:IApplicationModel)
		{
			this._commandChain = new CommandChain
			(
				new ProcessCommand(),
				new GotoSection(this),
				new UpdateViewStack(this, application, model)
			);
		}
		
		
		

		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function executeCommand(params:Object):void
		{
			this._commandChain.start(params);
			
		}
		

		

	}
	
}