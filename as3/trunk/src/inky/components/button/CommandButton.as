package inky.components.button 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import inky.binding.events.PropertyChangeEvent;
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.commands.FunctionCommand;
	import inky.commands.PlayFrameLabelCommand;
	import inky.commands.PlayToFrameCommand;
	import inky.components.button.IButton;
	import inky.components.button.CommandButtonBehavior;
	
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
	 *  @author Ryan Sprake
	 *	@since  2010.02.08
	 *
	 */
	public class CommandButton extends Sprite implements IButton
	{
		private var _enabled:Boolean;
		private var _proxy:CommandButtonBehavior;
		private var _selected:Boolean;
		private var _toggle:Boolean;
		
		/**
		 * Creates a new ButtonClip.
		 */
		public function CommandButton()
		{
			this._enabled = true;
			this._selected = false;
			this._toggle = false;
			this._proxy = new CommandButtonBehavior(this);
		}
		
		
		
		
		//
		// accessors
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function get up():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.UP);
		}
		/**
		 * @private
		 */
		public function set up(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.UP, value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get over():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.OVER);
		}
		/**
		 * @private
		 */
		public function set over(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.OVER, value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get down():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.DOWN);
		}
		/**
		 * @private
		 */
		public function set down(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.DOWN, value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get disabled():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.DISABLED);
		}
		/**
		 * @private
		 */
		public function set disabled(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.DISABLED, value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get selectedUp():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.SELECTED_UP);
		}
		/**
		 * @private
		 */
		public function set selectedUp(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.SELECTED_UP, value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedOver():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.SELECTED_OVER);
		}
		/**
		 * @private
		 */
		public function set selectedOver(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.SELECTED_OVER, value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedDown():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.SELECTED_DOWN);
		}
		/**
		 * @private
		 */
		public function set selectedDown(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.SELECTED_DOWN, value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get selectedDisabled():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.SELECTED_DISABLED);
		}
		/**
		 * @private
		 */
		public function set selectedDisabled(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.SELECTED_DISABLED, value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get emphasized():IAsyncCommand
		{
			return this._proxy.returnCommandByState(ButtonState.EMPHASIZED);
		}
		/**
		 * @private
		 */
		public function set emphasized(value:IAsyncCommand):void
		{
			this._proxy.mapStateToCommand(ButtonState.EMPHASIZED, value);
		}
				
		
		/**
		 * Whether or not the button is enabled.  When a button is not enabled (false), handling of its mouse events is suppressed.
		 */
		public function get enabled():Boolean
		{
			return this._enabled; 
		}
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			var oldValue:Boolean = this._enabled;
			if (value != oldValue)
			{
				this._enabled = value;
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
		// public methods
		//
		
		
		//
		// protected methods
		//		
		
		
		//
		// private methods
		//
	}	
}