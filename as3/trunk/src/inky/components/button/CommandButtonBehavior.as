package inky.components.button 
{
	import inky.components.button.ButtonBehavior;
	import inky.components.button.IButton;
	import inky.binding.utils.BindingUtil;
	import inky.binding.utils.IChangeWatcher;
	import inky.components.button.ButtonState;
	import inky.commands.IAsyncCommand;
	
	/**
	 *
	 *  Command button behavior maintains a map of button states to commands, and executes a matching command when the button state changes.
	 *  
	 *  @see inky.components.button.ButtonBehavior
	 *  @see inky.components.button.IButton
	 *  @see inky.components.button.ButtonState	
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.02.02
	 *
	 */
	public class CommandButtonBehavior extends ButtonBehavior
	{
		private var _map:Object;
		private var _lastState:String;
		private var _watcher:IChangeWatcher;
		private var _target:IButton;

		/**
		 * Creates a new command button behavior.
		 * 
		 * @param target
		 * 	The IButton this behavior targets.
		 * 
		 * @see	inky.components.button.IButton
		 */
		public function CommandButtonBehavior(target:IButton)
		{
			super(target);
			this._target = target;
			this._map = {};
			this._watcher = BindingUtil.bindSetter(this._executeCommand, this, "state");
		}
		
		


		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			for (var prop:String in this._map)
				delete this._map[prop];

			if (this._watcher)
				this._watcher.unwatch();
		}
		
		
		/**
		 * Maps a button state to a command.  When the button is in the state, the command is executed.
		 * 
		 * @param state
		 * 	The button state that is associated with a command.
		 * 
		 * @param command
		 * 	The command that is executed when the associated button state is detected.
		 * 
		 * @see inky.components.button.ButtonState
		 * @see inky.commands.IAsyncCommand
		 */
		public function mapStateToCommand(state:String, command:Object):void
		{
			switch (state)
			{
				case ButtonState.UP:
				{
					if (!this._map[ButtonState.SELECTED_UP])
						this._map[ButtonState.SELECTED_UP] = command;
					break;
				}
				case ButtonState.DOWN:
				{
					if (!this._map[ButtonState.SELECTED_DOWN])
						this._map[ButtonState.SELECTED_DOWN] = command;
					break;
				}
				case ButtonState.OVER:
				{
					if (!this._map[ButtonState.SELECTED_OVER])
						this._map[ButtonState.SELECTED_OVER] = command;
					break;
				}
				case ButtonState.DISABLED:
				{
					if (!this._map[ButtonState.SELECTED_DISABLED])
						this._map[ButtonState.SELECTED_DISABLED] = command;
					break;
				}
			}
			this._map[state] = command;
		}
		
		
		/**
		 * @param state
		 * 	The button state that is associated with a command.
		 */
		public function returnCommandByState(state:String):IAsyncCommand
		{
			return this._map[state];
		}
		
		

		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _executeCommand(state:String):void
		{
			if (state != this._lastState && this._map[state])
			{
				this._lastState = state;
				this._map[state].execute();
			}
		}

		


	}
	
}