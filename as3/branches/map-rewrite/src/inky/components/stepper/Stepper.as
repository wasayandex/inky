package inky.components.stepper 
{
	import flash.display.Sprite;
	import inky.components.stepper.IStepper;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import inky.binding.events.PropertyChangeEvent;
	import flash.events.MouseEvent;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.30
	 *
	 */
	public class Stepper extends Sprite implements IStepper
	{
		private var _autoRepeat:Boolean;
		private var _enabled:Boolean;
		private var __decrementButton:InteractiveObject;
		private var __incrementButton:InteractiveObject;
		private var _maximum:Number;
		private var _minimum:Number;
		private var _stepSize:Number;
		private var _value:Number;

		/**
		 *
		 */
		public function Stepper()
		{
			this._autoRepeat = true;
			this._enabled = true;
			this._minimum = 0;
			this._maximum = 10;
			this._stepSize = 1;
			this._value = 1;
			this.initButtons();
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get autoRepeat():Boolean
		{ 
			return this._autoRepeat; 
		}
		/**
		 * @private
		 */
		public function set autoRepeat(value:Boolean):void
		{
			this._autoRepeat = value;
		}

		/**
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		public function get maximum():Number
		{ 
			return this._maximum; 
		}
		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			this._maximum = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get minimum():Number
		{ 
			return this._minimum; 
		}
		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			this._minimum = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextValue():Number
		{
			return this.getNextValue();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get previousValue():Number
		{
			return this.getPreviousValue();
		}
		
		/**
		 *
		 */
		public function get stepSize():Number
		{ 
			return this._stepSize; 
		}
		/**
		 * @private
		 */
		public function set stepSize(value:Number):void
		{
			this._stepSize = value;
		}

		/**
		 *
		 */
		public function get value():Number
		{ 
			return this._value; 
		}
		/**
		 * @private
		 */
		public function set value(value:Number):void
		{
			var oldValue:Number = this._value;
			if (value != oldValue)
			{
				this._value = value;
				this.dispatchEvent(new Event(Event.CHANGE));
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "value", oldValue, value));	
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function decrementButton_mouseDownHandler(event:MouseEvent):void
		{
			if (this.autoRepeat)
			{
				this.addEventListener(Event.ENTER_FRAME, this.decrementValue);			
				this.stage.addEventListener(MouseEvent.MOUSE_UP, this.decrementButton_mouseUpHandler);
			}
			else
			{
				event.target.addEventListener(MouseEvent.MOUSE_UP, this.decrementButton_mouseUpHandler);
			}
		}
		
		/**
		 * 
		 */
		private function decrementButton_mouseUpHandler(event:MouseEvent):void
		{
			if (this.autoRepeat)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.decrementValue);			
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.decrementButton_mouseUpHandler);
			}
			else
			{
				this.decrementValue(null);
			}
		}
		
		/**
		 * 
		 */
		private function decrementValue(event:Event):void
		{
			this.value = this.getPreviousValue();
		}
		
		/**
		 * 
		 */
		private function getNextValue():Number
		{
			return Math.min(this.maximum, this.value + this.stepSize);
		}
		
		/**
		 * 
		 */
		private function getPreviousValue():Number
		{
			return Math.max(this.minimum, this.value - this.stepSize);
		}
		
		/**
		 * 
		 */
		private function incrementButton_mouseDownHandler(event:MouseEvent):void
		{
			if (this.autoRepeat)
			{
				this.addEventListener(Event.ENTER_FRAME, this.incrementValue);			
				this.stage.addEventListener(MouseEvent.MOUSE_UP, this.incrementButton_mouseUpHandler);
			}
			else
			{
				event.target.addEventListener(MouseEvent.MOUSE_UP, this.incrementButton_mouseUpHandler);
			}
		}
		
		/**
		 * 
		 */
		private function incrementButton_mouseUpHandler(event:MouseEvent):void
		{
			if (this.autoRepeat)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.incrementValue);			
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.incrementButton_mouseUpHandler);
			}
			else
			{
				this.incrementValue(null);
			}
		}
		
		/**
		 * 
		 */
		private function incrementValue(event:Event):void
		{
			this.value = this.getNextValue();
		}
		
		/**
		 * 
		 */
		private function initButtons():void
		{
			this.__decrementButton = this.getChildByName("_decrementButton") as InteractiveObject;
			if (this.__decrementButton)
				this.__decrementButton.addEventListener(MouseEvent.MOUSE_DOWN, this.decrementButton_mouseDownHandler);

			this.__incrementButton = this.getChildByName("_incrementButton") as InteractiveObject;
			if (this.__incrementButton)
				this.__incrementButton.addEventListener(MouseEvent.MOUSE_DOWN, this.incrementButton_mouseDownHandler);
		}
		
	}
	
}