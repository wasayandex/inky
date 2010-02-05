package inky.components.button 
{
	import inky.components.button.IButton;
	import flash.display.MovieClip;
	import inky.components.button.CommandButtonBehavior;
	import inky.binding.events.PropertyChangeEvent;
	import flash.display.FrameLabel;
	import inky.commands.IAsyncCommand;
	import inky.commands.PlayFrameLabelCommand;
	import inky.commands.PlayToFrameCommand;
	
	/**
	 *
	 *  ButtonClip is a button that uses frame labels and timeline animations to represent button states.
	 *  The recognized frame labels correspond to the possible button states.
	 * 	
	 *  @see inky.components.button.ButtonState
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.02.02
	 *
	 */
	public class ButtonClip extends MovieClip implements IButton
	{
		private var _enabled:Boolean;
		private var _proxy:CommandButtonBehavior;
		private var _selected:Boolean;
		private var _toggle:Boolean;
		
		/**
		 * Creates a new ButtonClip.
		 */
		public function ButtonClip()
		{
			this._enabled = super.enabled;
			this._selected = false;
			this._toggle = false;
			this._proxy = new CommandButtonBehavior(this);
			this._initialize();
		}
		
		
		
		
		//
		// accessors
		//
		
		
		/**
		 * Whether or not the button is enabled.  When a button is not enabled (false), handling of its mouse events is suppressed.
		 */
		override public function get enabled():Boolean
		{ 
			return this._enabled; 
		}
		/**
		 * @private
		 */
		override public function set enabled(value:Boolean):void
		{
			var oldValue:Boolean = this._enabled;
			if (value != oldValue)
			{
				this._enabled = value;
				super.enabled = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "enabled", oldValue, value));	
			}
		}
		
		
		/**
		 * Whether or not the button is selected.
		 * 
		 * @see #toggle
		 */
		public function get selected():Boolean
		{ 
			return this._selected; 
		}
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			var oldValue:Boolean = this._selected;
			if (value != oldValue)
			{
				this._selected = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, value));	
			}
		}
		
		
		/**
		 * Whether or not the button can be toggled between selected and unselected states.
		 * 
		 * @see #selected
		 */
		public function get toggle():Boolean
		{ 
			return this._toggle; 
		}
		/**
		 * @private
		 */
		public function set toggle(value:Boolean):void
		{
			var oldValue:Boolean = this._toggle;
			if (value != oldValue)
			{
				this._toggle = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toggle", oldValue, value));	
			}
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _initialize():void
		{
			// Automatically configure commands for as many button states as possible.
			var lastUpFrame:int;
			var numLabels:int = this.currentLabels.length;
			var map:Object = {};
			for (var i:int = 0; i < numLabels; i++)
			{
				var label:FrameLabel = this.currentLabels[i];
				switch (label.name)
				{
					case ButtonState.UP:
					{
						// Start the button at the last frame of the up animation.
						lastUpFrame = i + 1 < numLabels ? this.currentLabels[i + 1].frame - 1 : this.totalFrames;
						map[label.name] = new PlayFrameLabelCommand(label.name, this);

						// If there is no over command defined yet, do the reverse of the up command.
						if (!map[ButtonState.OVER])
							map[ButtonState.OVER] = new PlayToFrameCommand(label.frame, this);

						break;
					}
					case ButtonState.OVER:
					{
						// If the lastUpFrame hasn't been calculated from an up state, use the first frame of the over state.
						lastUpFrame = lastUpFrame || label.frame;
						map[label.name] = new PlayFrameLabelCommand(label.name, this);
						
						// If there is no up command defined yet, do the reverse of the over command.
						if (!map[ButtonState.UP])
							map[ButtonState.UP] = new PlayToFrameCommand(label.frame, this);
						
						break;
					}
					case ButtonState.DOWN:
					{
						// If the lastUpFrame hasn't been calculated from an up state, use the first frame of the down state.
						lastUpFrame = lastUpFrame || label.frame;
						map[label.name] = new PlayFrameLabelCommand(label.name, this);

						// If there is no up command defined yet, do the reverse of the down command.
						if (!map[ButtonState.UP])
							map[ButtonState.UP] = new PlayToFrameCommand(label.frame, this);
						

						// If there is no over command defined yet, do the reverse of the down command.
						if (!map[ButtonState.OVER])
							map[ButtonState.OVER] = new PlayToFrameCommand(label.frame, this);

						break;
					}
					case ButtonState.SELECTED_UP:
					case ButtonState.SELECTED_OVER:
					case ButtonState.SELECTED_DOWN:
					case ButtonState.DISABLED:
					case ButtonState.SELECTED_DISABLED:
					case ButtonState.EMPHASIZED:
					{
						map[label.name] = new PlayFrameLabelCommand(label.name, this);
						break;
					}
				}
			}
			
			// Map the commands to the strings on the command button behavior.
			for (var state:String in map)
				this._proxy.mapStateToCommand(state, map[state]);

			// Move the playhead to the initial frame.
			if (lastUpFrame)
				this.gotoAndStop(lastUpFrame);
		}
		
		

		
	}
	
}