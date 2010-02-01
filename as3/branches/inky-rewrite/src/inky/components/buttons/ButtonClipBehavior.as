package inky.components.buttons
{
	import flash.events.EventDispatcher;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import inky.binding.events.PropertyChangeEvent;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import inky.commands.IAsyncCommand;
	import inky.components.buttons.ButtonState;
	import inky.commands.PlayFrameLabelCommand;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import inky.commands.PlayToFrameCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.02.01
	 *
	 */
	public class ButtonClipBehavior extends EventDispatcher
	{
		private var _enabled:Boolean;
		private var _selected:Boolean;
		private var _target:Object;
		private var _toggle:Boolean;
		private var _mouseIsDown:Boolean;
		private var _mouseIsOver:Boolean;
		private var _previousCommand:IAsyncCommand;
		private var _disabled:IAsyncCommand;
		private var _down:IAsyncCommand;
		private var _emphasized:IAsyncCommand;
		private var _over:IAsyncCommand;
		private var _selectedDisabled:IAsyncCommand;
		private var _selectedDown:IAsyncCommand;
		private var _selectedOver:IAsyncCommand;
		private var _selectedUp:IAsyncCommand;
		private var _up:IAsyncCommand;
		
		/**
		 *
		 */
		public function ButtonClipBehavior(target:InteractiveObject)
		{
			this._enabled = true;
			this._toggle = false;
			this._selected = false;
			this._mouseIsDown = false;
			this._mouseIsOver = false;

			this._initialize(target);
		}

		
		
		
		//
		// accessors
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function get disabled():IAsyncCommand
		{
			return this._disabled;
		}
		/**
		 * @private
		 */
		public function set disabled(value:IAsyncCommand):void
		{
			this._disabled = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get down():IAsyncCommand
		{
			return this._down;
		}
		/**
		 * @private
		 */
		public function set down(value:IAsyncCommand):void
		{
			this._down = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get emphasized():IAsyncCommand
		{
			return this._emphasized;
		}
		/**
		 * @private
		 */
		public function set emphasized(value:IAsyncCommand):void
		{
			this._emphasized = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get over():IAsyncCommand
		{
			return this._over;
		}
		/**
		 * @private
		 */
		public function set over(value:IAsyncCommand):void
		{
			this._over = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get selectedDisabled():IAsyncCommand
		{
			return this._selectedDisabled;
		}
		/**
		 * @private
		 */
		public function set selectedDisabled(value:IAsyncCommand):void
		{
			this._selectedDisabled = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get selectedDown():IAsyncCommand
		{
			return this._selectedDown;
		}
		/**
		 * @private
		 */
		public function set selectedDown(value:IAsyncCommand):void
		{
			this._selectedDown = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get selectedOver():IAsyncCommand
		{
			return this._selectedOver;
		}
		/**
		 * @private
		 */
		public function set selectedOver(value:IAsyncCommand):void
		{
			this._selectedOver = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get selectedUp():IAsyncCommand
		{
			return this._selectedUp;
		}
		/**
		 * @private
		 */
		public function set selectedUp(value:IAsyncCommand):void
		{
			this._selectedUp = value;
			this._updateState();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get up():IAsyncCommand
		{
			return this._up;
		}
		/**
		 * @private
		 */
		public function set up(value:IAsyncCommand):void
		{
			this._up = value;
			this._updateState();
		}		


		/**
		 *
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
				this._updateState();
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "enabled", oldValue, value));	
			}
		}
		
		
		/**
		 *
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
				this._updateState();
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, value));	
			}
		}


		/**
		 *
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
				this._updateState();
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toggle", oldValue, value));	
			}
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _initialize(target:Object):void
		{
			var lastUpFrame:int;

			this._target = target;
			target.buttonMode = true;
			target.mouseChildren = false;

			// If the target is a movieclip, create commands for playing any label frame sets that match a button state.
			if (target is MovieClip)
			{
				var numLabels:int = target.currentLabels.length;
				for (var i:int = 0; i < numLabels; i++)
				{
					var label:FrameLabel = target.currentLabels[i];
					switch (label.name)
					{
						case ButtonState.UP:
						{
							lastUpFrame = label.frame + (i + 1 < numLabels ? target.currentLabels[i + 1].frame - 1 : target.totalFrames);
							this._up = new PlayFrameLabelCommand(label.name, target);
trace("MADE A _up")
if (!this._over) trace("i'm making my own over")
							this._over = this._over || new PlayToFrameCommand(label.frame, target);
							break;
						}
						case ButtonState.OVER:
						case ButtonState.DOWN:
						{
							lastUpFrame = lastUpFrame || label.frame;
							this["_" + label.name] = new PlayFrameLabelCommand(label.name, target);
trace("MADE A " + " _" + label.name)
if (!this._up) trace("I'm making my own up")
							this._up = this._up || new PlayToFrameCommand(label.frame, target);
							break;
						}
						case ButtonState.DISABLED:
						case ButtonState.EMPHASIZED:
						case ButtonState.SELECTED_DISABLED:
						case ButtonState.SELECTED_DOWN:
						case ButtonState.SELECTED_OVER:
						case ButtonState.SELECTED_UP:
						{
							this["_" + label.name] = new PlayFrameLabelCommand(label.name, target);
							break;
						}
					}
				}
			}
			
			// If the target is a container, check if it contains a child designated as a hit area.
			if (target is DisplayObjectContainer)
			{
				var hitArea:Sprite = target.getChildByName('_hitArea') as Sprite;
				if (hitArea)
				{
					hitArea.mouseEnabled = false;
					target.hitArea = hitArea;
				}
			}

			target.addEventListener(MouseEvent.CLICK, this._clickFilter);
			target.addEventListener(MouseEvent.CLICK, this._clickHandler);
			target.addEventListener(MouseEvent.ROLL_OVER, this._rollOverHandler);
			target.addEventListener(MouseEvent.ROLL_OUT, this._rollOutHandler);
			target.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
			
			if (lastUpFrame)
				target.gotoAndStop(lastUpFrame);
			else
				this._updateState();
		}


		/**
		 * 
		 */
		private function _clickFilter(event:MouseEvent):void
		{
			if (!this.enabled)
				event.stopImmediatePropagation();
		}
		
		
		/**
		 * 
		 */
		private function _clickHandler(event:MouseEvent):void
		{
			if (this.toggle)
				this.selected = !this.selected;
		}
		
		
		/**
		 * 
		 */
		private function _mouseDownHandler(event:MouseEvent):void
		{
			if (this._target.stage)
			{
				this._mouseIsDown = true;
				this._target.stage.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
				this._updateState();
			}
		}
		
		
		/**
		 * 
		 */
		private function _mouseUpHandler(event:MouseEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._mouseIsDown = false;
			this._updateState();
		}
		
		
		/**
		 * 
		 */
		private function _rollOutHandler(event:MouseEvent):void
		{
			this._mouseIsOver = false;
			this._updateState();
		}

		
		/**
		 * 
		 */
		private function _rollOverHandler(event:MouseEvent):void
		{
			this._mouseIsOver = true;
			this._updateState();
		}
		
		
		/**
		 * 
		 */
		private function _updateState():void
		{
			var command:IAsyncCommand;
			
			if (!this.enabled)
			{
				command = this.selected ? this.selectedDisabled : this.disabled;
				if (!command)
					command = this.disabled || this.up;
			}
			else if (this.selected)
			{
				if (this._mouseIsDown)
					command = this.selectedDown || this.down;
				
				if (!command)
				{
					if (this._mouseIsOver)
						command = this.selectedOver || this.over;
					else
						command = this.selectedUp || this.up;
				}
			}
			else
			{
				if (this._mouseIsDown)
					command = this.down;
				else if (this._mouseIsOver)
					command = this.over;
				
				if (!command)
					command = this.up;
			}
			
			
			// Guard against the same command being repeated unnecessarily.
trace(this._previousCommand + ' vs ' + command)
			if (command != this._previousCommand)
			{
				this._previousCommand = command;
				command.execute();
			}
		}
		

		

	}
	
}