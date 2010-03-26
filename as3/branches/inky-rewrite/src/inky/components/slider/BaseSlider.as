package inky.components.slider 
{
	import flash.display.Sprite;
	import inky.components.slider.ISlider;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import inky.components.slider.SliderDirection;
	import inky.utils.DragUtil;
	import flash.display.DisplayObject;
	import inky.components.slider.events.SliderEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import inky.binding.events.PropertyChangeEvent;
	import inky.components.slider.events.SliderEventClickTarget;
	
	/**
	 *
	 *  Provides a basic Slider implementation that handles events, and positioning of the thumb.
	 * 
	 *  @inheritDoc
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.03.17
	 *
	 */
	public class BaseSlider extends Sprite implements ISlider
	{
		private var _direction:String;
		private var _isDragging:Boolean;
		private var _enabled:Boolean;
		private var _maximum:Number;
		private var _minimum:Number;
		private var _liveDragging:Boolean;
		private var _snapInterval:Number;
//		private var _tickInterval:Number; // TODO: Implement 'tick marks?'
		private var _trackDragging:Boolean;
		private var _value:Number;
		private var __thumb:InteractiveObject;
		private var __track:InteractiveObject;
		private var _xOrY:String;
		private var _widthOrHeight:String;
		
		/**
		 * 
		 * Creates an instance of BaseSlider. The Slider can be created in the IDE
		 * by linking a symbol to this class and giving it children named "_thumb", and "_track".
		 *
		 */
		public function BaseSlider()
		{
			this.direction = SliderDirection.HORIZONTAL;
			this._isDragging = false;
			this._enabled = true;
			this._minimum = 0;
			this._maximum = 1;
			this._value = 0;
			this._snapInterval = 0;
//			this._tickInterval = 0;
			this._liveDragging = false;
			this._trackDragging = true;

			this._setThumb(this.getChildByName('_thumb') as InteractiveObject);
			this._setTrack(this.getChildByName('_track') as InteractiveObject);

			this._updateThumbPosition(null);
			this._init(null);
		}
		
		
		

		//
		// accessors
		//

		
		/**
		 * @inheritDoc
		 */
		public function get direction():String
		{
			return this._direction;
		}
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			switch (value)
			{
				case SliderDirection.HORIZONTAL:
					this._xOrY = 'x';
					this._widthOrHeight = 'width';
					break;
				case SliderDirection.VERTICAL:
					this._xOrY = 'y';
					this._widthOrHeight = 'height';
					break;
			}

			this._direction = value;
			
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
			if (value != this._enabled)
			{
				var childrenNames:Array = ['__thumb', '__track'];
				var name:String;
				
				for each (name in childrenNames)
				{
					if (this[name] && this[name].hasOwnProperty('enabled'))
					{
						(this[name] as Object).enabled = value;
					}
				} 

				this._enabled = value;				
			}
		}

		
		/**
		 * @inheritDoc
		 */
		public function get liveDragging():Boolean
		{
			return this._liveDragging;
		}
		/**
		 * @private
		 */
		public function set liveDragging(value:Boolean):void
		{
			this._liveDragging = value;
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
			var oldValue:Number = this._maximum;
			if (value != oldValue)
			{
				this._maximum = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maximum", oldValue, value));	
			}
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
			var oldValue:Number = this._minimum;
			if (value != oldValue)
			{
				this._minimum = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minimum", oldValue, value));	
			}
		}

		
		/**
		 * @inheritDoc
		 */
		public function get snapInterval():Number
		{ 
			return this._snapInterval; 
		}
		/**
		 * @private
		 */
		public function set snapInterval(value:Number):void
		{
			var oldValue:Number = this._snapInterval;
			if (value != oldValue)
			{
				this._snapInterval = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "snapInterval", oldValue, value));	
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get trackDragging():Boolean
		{ 
			return this._trackDragging; 
		}
		/**
		 * @private
		 */
		public function set trackDragging(value:Boolean):void
		{
			var oldValue:Boolean = this._trackDragging;
			if (value != oldValue)
			{
				this._trackDragging = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "trackDragging", oldValue, value));	
			}
		}
		

		/**
		 * @inheritDoc
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
				this._updateThumbPosition(null, false);
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "value", oldValue, value));	
			}
		}
		
		


		//
		// private methods
		//

// FIXME: This doesn't seem to work.
		/**
		 * 
		 */
		private function _adjustPositionForSnapping(position:Point):Point
		{
			var newPosition:Point = position.clone();

			if (this.snapInterval > 0)
			{
				var trackRect:Rectangle = this.__track.getRect(this);
				var dragBounds:Rectangle = this._getDragBounds();
				var divs:Number = (this.maximum - this.minimum) / this.snapInterval;
				var divSize:Number = dragBounds[this._widthOrHeight] / divs;
				var pct:Number = (position[this._xOrY] - dragBounds[this._xOrY]) / dragBounds[this._widthOrHeight];
				newPosition[this._xOrY] = Math.floor(pct * divs) * divSize;
			}
			
			return newPosition;
		}
		
		
		/**
		 * 
		 */
		private function _cleanUp(event:Event):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._thumbMouseUpHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, this._init);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this._cleanUp);
		}


		/**
		 * TODO: Create an InteractionInputType for the triggerEvent? ("mouse" vs "keyboard")
		 */
		private function _dispatchSliderEvent(type:String, clickTarget:String, triggerEvent:String, keyCode:int = 0):void
		{
			this.dispatchEvent(new SliderEvent(type, this.value, clickTarget, triggerEvent, keyCode))
		}
		
		
		/**
		 * 
		 */
		private function _getDragBounds():Rectangle
		{
			if (!this.__thumb || !this.__track)
				return null;

			var thumbMin:Number = this.__track.getRect(this)[this._xOrY] + this.__thumb[this._xOrY] - this.__thumb.getRect(this)[this._xOrY];
			return this.direction == SliderDirection.VERTICAL ? new Rectangle(this.__thumb.x, thumbMin, 0, this.__track.height - this.__thumb.height) : new Rectangle(thumbMin, this.__thumb.y, this.__track.width - this.__thumb.width, 0);
		}

		
		/**
		 * 
		 */
		private function _init(event:Event):void
		{
			if (this.stage)
				this.removeEventListener(Event.ADDED_TO_STAGE, this._init);
			else
				this.addEventListener(Event.ADDED_TO_STAGE, this._init);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._cleanUp);
		}

		
		/**
		 * @param thumb InteractiveObject
		 */
		private function _setThumb(thumb:InteractiveObject):void
		{
			if (thumb)
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, this._thumbMouseDownHandler);
			this.__thumb = thumb;
		}

		
		/**
		 * @param track InteractiveObject 
		 */
		private function _setTrack(track:InteractiveObject):void
		{
			if (track)
			{
				track.addEventListener(MouseEvent.MOUSE_DOWN, this._trackMouseDownHandler);
				this.value = 0;
			}
			
			this.__track = track;
		}
		
		
		/**
		 * 
		 */
		private function _startThumbDrag():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._thumbDragHandler);
			this._isDragging = true;
		}
		
		
		/**
		 * 
		 */
		private function _stopThumbDrag():void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this._thumbDragHandler);
			this._isDragging = false;
		}
		
		
		/**
		 * 
		 */
		private function _thumbDragHandler(event:MouseEvent):void
		{
			this._updateThumbPosition(new Point(this.mouseX, this.mouseY));
			this._dispatchSliderEvent(SliderEvent.THUMB_DRAG, SliderEventClickTarget.THUMB, "mouse");			
		}
		

		/**
		 * Handles the thumb's MOUSE_DOWN event. Drags the thumb (within the appropriate bounds).
		 */
		private function _thumbMouseDownHandler(event:MouseEvent):void
		{
			this._startThumbDrag();
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this._thumbMouseUpHandler);
			this._dispatchSliderEvent(SliderEvent.THUMB_PRESS, SliderEventClickTarget.THUMB, "mouse");
			this._updateThumbPosition(new Point(this.mouseX, this.mouseY));
		}
		
		
		/**
		 * Handles the thumb's MOUSE_UP event.
		 */
		private function _thumbMouseUpHandler(event:MouseEvent):void
		{
			this._stopThumbDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._thumbMouseUpHandler);
			this._dispatchSliderEvent(SliderEvent.THUMB_RELEASE, SliderEventClickTarget.THUMB, "mouse");
			this._updateThumbPosition(new Point(this.mouseX, this.mouseY));
		}
		
		
		/**
		 * Handles the track's MOUSE_DOWN event.
		 */
		private function _trackMouseDownHandler(event:MouseEvent):void
		{
			if (this.trackDragging)
			{
				this._startThumbDrag();
				this._updateThumbPosition(new Point(this.mouseX, this.mouseY));
			}
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this._trackMouseUpHandler);
		}

			
		/**
		 * Handles the track's MOUSE_UP event.
		 */
		private function _trackMouseUpHandler(event:MouseEvent):void
		{
			this._stopThumbDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._trackMouseUpHandler);
			this._updateThumbPosition(new Point(this.mouseX, this.mouseY));
		}
		
		
		/**
		 * 
		 */
		private function _updateThumbPosition(newPosition:Point, updateValue:Boolean = true):void
		{
			var dragBounds:Rectangle = this._getDragBounds();
			var newThumbPos:Point;
			if (newPosition)
			{
				// Normalize the new position to within the draggable bounds of the slider.
				newThumbPos = new Point(this.__thumb.x, this.__thumb.y);
				newThumbPos[this._xOrY] = Math.max(dragBounds[this._xOrY], Math.min(newPosition[this._xOrY], dragBounds[this._xOrY] + dragBounds[this._widthOrHeight]));
			}
			else
			{
				// Calculate new position from the current slider value.
				var pct:Number = (this.value - this.minimum) / (this.maximum - this.minimum);
				newThumbPos = new Point(this.__thumb.x, this.__thumb.y);
				newThumbPos[this._xOrY] = dragBounds[this._xOrY] +  pct * dragBounds[this._widthOrHeight];
			}
			
			newThumbPos = this._adjustPositionForSnapping(newThumbPos);

			// TODO: Implement a proxy or overridable method for positioning. Maybe a cancelable event can be dispatched, which can be hijacked to modify how the thumb is actually positioned This would be useful if you wanted to move the thumb differently depending on the input source (mouse vs keyboard vs direct modification of slider value).
			this.__thumb.x = newThumbPos.x;
			this.__thumb.y = newThumbPos.y;
			
			if (!this._isDragging || this.liveDragging)
			{
// FIXME: Probably shouldn't be called "updateValue" because it's really more like "mouseTriggered"
				if (updateValue)
				{
					this._updateValue();
					this._dispatchSliderEvent(SliderEvent.CHANGE, SliderEventClickTarget.TRACK, "mouse");
				}
			}
		}
		
		
		/**
		 * 
		 */
		private function _updateValue():void
		{
			var dragBounds:Rectangle = this._getDragBounds();
			var pct:Number = (this.__thumb[this._xOrY] - dragBounds[this._xOrY]) / dragBounds[this._widthOrHeight];
			this.value = this.minimum + pct * (this.maximum - this.minimum);
		}

		


	}
	
}