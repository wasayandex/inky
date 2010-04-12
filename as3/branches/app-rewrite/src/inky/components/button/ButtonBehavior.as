package inky.components.button 
{
	import inky.components.button.IButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import inky.components.button.ButtonState;
	import inky.binding.events.PropertyChangeEvent;
	import flash.events.EventDispatcher;
	import inky.binding.utils.BindingUtil;
	import inky.binding.utils.IChangeWatcher;
	
	/**
	 *
	 *  Button behavior maintains a button state for a target object. 
	 *  The target object's mouse input and button properties are monitored by the button behavior to trigger changes in state.
	 *  
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
	public class ButtonBehavior extends EventDispatcher
	{
		private var _mouseIsDown:Boolean;
		private var _mouseIsOver:Boolean;
		private var _state:String;
		private var _target:IButton;
		private var _watchers:Array;
		
		/**
		 * Creates a new button behavior.
		 * 
		 * @param target
		 * 	The IButton this behavior targets.
		 * 
		 * @see	inky.components.button.IButton
		 */
		public function ButtonBehavior(target:IButton)
		{
			this._initialize(target);
		}
		
		
		
		
		//
		// accessors
		//
		
		
		/**
		 * The current state of the button.
		 * 
		 * @see	inky.components.button.ButtonState
		 */
		public function get state():String
		{
			return this._state;
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * Removes all listeners and bindings that were created by the button behavior.
		 */
		public function destroy():void
		{
			if (this._watchers)
			{
				for each (var watcher:IChangeWatcher in this._watchers)
					watcher.unwatch();
				
				this._watchers = null;
			}
			
			this._target.removeEventListener(MouseEvent.CLICK, this._clickFilter);
			this._target.removeEventListener(MouseEvent.CLICK, this._clickHandler);
			this._target.removeEventListener(MouseEvent.ROLL_OVER, this._rollOverHandler);
			this._target.removeEventListener(MouseEvent.ROLL_OUT, this._rollOutHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
		}

		
		

		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _clickFilter(event:MouseEvent):void
		{
			if (!this._target.enabled)
				event.stopImmediatePropagation();
		}
		
		
		/**
		 * 
		 */
		private function _clickHandler(event:MouseEvent):void
		{
			if (this._target.toggle)
				this._target.selected = !this._target.selected;
		}
		
		
		/**
		 * 
		 */
		private function _initialize(target:IButton):void
		{
			this._mouseIsDown = false;
			this._mouseIsOver = false;
			this._target = target;

			if (target is Sprite)
			{
				var sprite:Sprite = Sprite(target);
				sprite.buttonMode = true;

				var hitArea:Sprite = sprite.getChildByName('_hitArea') as Sprite;
				if (hitArea)
				{
					hitArea.mouseEnabled = false;
					sprite.hitArea = hitArea;
				}
			}
			
			this._watchers = [];
			this._watchers.push(BindingUtil.bindSetter(this._targetChangeHandler, target, "enabled"));
			this._watchers.push(BindingUtil.bindSetter(this._targetChangeHandler, target, "selected"));

			target.addEventListener(MouseEvent.CLICK, this._clickFilter);
			target.addEventListener(MouseEvent.CLICK, this._clickHandler);
			target.addEventListener(MouseEvent.ROLL_OVER, this._rollOverHandler);
			target.addEventListener(MouseEvent.ROLL_OUT, this._rollOutHandler);
			target.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
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
		private function _setState(value:String):void
		{
			var oldValue:String = this._state;
			if (value != oldValue)
			{
				this._state = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "state", oldValue, value));	
			}
		}
		
		
		/**
		 * 
		 */
		private function _targetChangeHandler(value:Object):void
		{
			this._updateState();
		}

		
		/**
		 *  
		 */
		private function _updateState():void
		{
			var selected:Boolean = this._target.selected;
			if (!this._target.enabled)
				this._setState(selected ? ButtonState.SELECTED_DISABLED : ButtonState.DISABLED);
			else if (this._mouseIsDown)
				this._setState(selected ? ButtonState.SELECTED_DOWN : ButtonState.DOWN);
			else if (this._mouseIsOver)
				this._setState(selected ? ButtonState.SELECTED_OVER : ButtonState.OVER);
			else
				this._setState(selected ? ButtonState.SELECTED_UP : ButtonState.UP);
		}
		

		

	}
	
}