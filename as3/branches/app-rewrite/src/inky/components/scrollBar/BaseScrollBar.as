﻿package inky.components.scrollBar
{
	import inky.binding.events.PropertyChangeEvent;
	import inky.binding.utils.BindingUtil;
	import inky.components.scrollBar.IScrollBar;
	import inky.components.scrollBar.ScrollBarDirection;
	import inky.components.scrollBar.events.ScrollEvent;
	import inky.utils.DragUtil;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	
	/**
	 *
	 * Provides a basic ScrollBar implementation that handles events, and
	 * positioning of the thumb.
	 * 
	 * @inheritDoc	 	 
	 *	
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author    Matthew Tretter (matthew@exanimo.com)
	 * @author    Ryan Sprake
	 * @since     2007.11.20
	 *	
	 */
	public class BaseScrollBar extends Sprite implements IScrollBar
	{
		BindingUtil.setPropertyBindingEvents(BaseScrollBar, "scrollPosition", [ScrollEvent.SCROLL]);


		private var _direction:String;
		private var _directionPolarity:Number;
		private var __downArrow:InteractiveObject;
		private var _enabled:Boolean;
		private var _lineScrollSize:Number;
		private var _maxScrollPosition:Number;
		private var _minScrollPosition:Number;
		private var _minThumbSize:Number;
		private var _originalThumbPosition:Point;
		private var _pageScrollSize:Number;	
		private var _pageSize:Number;
		private var _repeatDelay:Number;
		private var _repeatDelayTimer:Timer;
		private var _repeatIntervalTimer:Timer;
		private var _scaleThumb:Boolean;
		private var _scrollBy:String;
		private var _scrollPosition:Number;
		private var __thumb:InteractiveObject;
		private var __track:InteractiveObject;
		private var __upArrow:InteractiveObject;
		private var _widthOrHeight:String;	
		private var _xOrY:String;




		/**
		 *
		 * Creates an instance of BaseScrollBar. The ScrollBar can be created in
		 * the IDE by giving linking a symbol to this class and giving it
		 * children named "_thumb", "_track", "_upArrow", and "_downArrow".
		 * Though all are optional, a track is required if a thumb is used.		 		 		 
		 *
		 */
		public function BaseScrollBar()
		{
			this._setThumb(this.getChildByName('_thumb') as InteractiveObject);
			this._setTrack(this.getChildByName('_track') as InteractiveObject);
			this._setUpArrow(this.getChildByName('_upArrow') as InteractiveObject);
			this._setDownArrow(this.getChildByName('_downArrow') as InteractiveObject);

			this._lineScrollSize = 4;
			this._pageScrollSize = 0;
			this._pageSize = 10;
	
			this._minScrollPosition = 0;
			this._maxScrollPosition = 1;
			this._minThumbSize = 10;
			this._scrollPosition = 0;

			this.direction = ScrollBarDirection.VERTICAL;
			this._enabled = true;
			this._scaleThumb = true;

			this._directionPolarity = 1;

			this.repeatDelay = 500;
			this.repeatInterval = 35;

			this._init();
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
		public function set direction(direction:String):void
		{
			switch (direction)
			{
				case ScrollBarDirection.HORIZONTAL:
					this._xOrY = 'x';
					this._widthOrHeight = 'width';
					break;
				case ScrollBarDirection.VERTICAL:
					this._xOrY = 'y';
					this._widthOrHeight = 'height';
					break;
			}
			this._direction = direction;
			this._updateThumb();
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
		public function set enabled(enabled:Boolean):void
		{
			if (enabled != this._enabled)
			{
				var childrenNames:Array = ['__downArrow', '__thumb', '__track', '__upArrow'];
				var name:String;
				
				for each (name in childrenNames)
				{
					if (this[name] && this[name].hasOwnProperty('enabled'))
					{
						(this[name] as Object).enabled = enabled;
					}
				} 

				this._enabled = enabled;				
			}
		}
		

		/**
		 * @inheritDoc
		 */
		public function get pageScrollSize():Number
		{
			return this._pageScrollSize;
		}
		/**
		 * @private
		 */	
		public function set pageScrollSize(value:Number):void
		{
			if (value != this._pageScrollSize)
			{
				var oldValue:Number = this._pageScrollSize;
				this._pageScrollSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pageScrollSize", oldValue, value));
			}
		}


		/**
		 * @inheritDoc
		 */		 		 		 		
		public function get pageSize():Number
		{
			return this._pageSize;
		}
		/**
		 * @private
		 */	
		public function set pageSize(value:Number):void
		{
			if (value != this._pageSize)
			{
				var oldValue:Number = this._pageSize;
				this._pageSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pageSize", oldValue, value));
				this._updateThumb();
			}
		}


		/**
		 * @inheritDoc
		 */	
		public function get repeatDelay():Number
		{
			return this._repeatDelayTimer.delay;
		}
		/**
		 * @private
		 */	
		public function set repeatDelay(repeatDelay:Number):void
		{
			this._repeatDelayTimer = new Timer(repeatDelay, 1);
			this._repeatDelayTimer.addEventListener(TimerEvent.TIMER, this._repeatDelayTimerHandler)
		}


		/**
		 * @inheritDoc
		 */	
		public function get repeatInterval():Number
		{
			return this._repeatIntervalTimer.delay;
		}
		/**
		 * @private
		 */	
		public function set repeatInterval(repeatInterval:Number):void
		{
			this._repeatIntervalTimer = new Timer(repeatInterval);
			this._repeatIntervalTimer.addEventListener(TimerEvent.TIMER, this._doScroll);
		}


		/**
		 * @inheritDoc
		 */	
		public function get lineScrollSize():Number
		{
			return this._lineScrollSize;
		}
		/**
		 * @private
		 */	
		public function set lineScrollSize(value:Number):void
		{
			if (value != this._lineScrollSize)
			{
				var oldValue:Number = this._lineScrollSize;
				this._lineScrollSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineScrollSize", oldValue, value));
			}
		}


		/**
		 * @inheritDoc
		 */	
		public function get minScrollPosition():Number
		{
			return this._minScrollPosition;
		}
		/**
		 * @private
		 */	
		public function set minScrollPosition(value:Number):void
		{
			if (value != this._minScrollPosition)
			{
				var oldValue:Number = this._minScrollPosition;
				this._minScrollPosition = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minScrollPosition", oldValue, value));
				this._updateThumb();
			}
		}


		/**
		 * @inheritDoc
		 */	
		public function get maxScrollPosition():Number
		{
			return this._maxScrollPosition;
		}
		/**
		 * @private
		 */	
		public function set maxScrollPosition(value:Number):void
		{
			if (value != this._maxScrollPosition)
			{
				var oldValue:Number = this._maxScrollPosition;
				this._maxScrollPosition = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxScrollPosition", oldValue, value));
				this._update();
			}
		}


		/**
		 *
		 *
		 *
		 */
		public function get minThumbSize():Number
		{
			return this._minThumbSize;
		}
		/**
		 * @private
		 */
		public function set minThumbSize(value:Number):void
		{
			this._minThumbSize = value;
		}


		/**
		 * @inheritDoc
		 */	
		public function get scaleThumb():Boolean
		{
			return this._scaleThumb;
		}
		/**
		 * @private
		 */	
		public function set scaleThumb(scaleThumb:Boolean):void
		{
			this._scaleThumb = scaleThumb;
			this._update();
		}
		
		
		/**
		 * @inheritDoc
		 */	
		public function get scrollPosition():Number
		{
			return this._scrollPosition || 0;
		}
		/**
		 * @private
		 */	
		public function set scrollPosition(scrollPosition:Number):void
		{
			var oldScrollPosition:Number = this._scrollPosition;
			this._scrollPosition = scrollPosition;
			this._updateThumb();

			// Dispatch a ScrollEvent.
			if (oldScrollPosition != scrollPosition)
				this._dispatchScrollEvent(oldScrollPosition);
		}
		



		//
		// private methods
		//

		
		/**
		 *
		 * Handles the arrow buttons' MOUSE_DOWN events.
		 *
		 */
		private function _arrowButtonMouseDownHandler():void
		{
			this._scrollBy = 'line';
			this._doScroll();
			this._repeatDelayTimer.reset();
			this._repeatDelayTimer.start();
		}


		/**
		 *
		 *
		 *
		 */
		private function _cleanUp(e:Event):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__thumbMouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._stopTimers);
			this.addEventListener(Event.ADDED_TO_STAGE, this._init);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this._cleanUp);
		}


		/**
		 *
		 * A helper function used to dispatch the ScrollEvent.
		 *
		 */
		private function _dispatchScrollEvent(oldScrollPosition:Number):void
		{
			var delta:Number = this._scrollPosition - oldScrollPosition;
			this.dispatchEvent(new ScrollEvent(this.direction, delta, this._scrollPosition));
		}
		
		
		/**
		 *
		 *
		 *
		 */
		private function _doScroll(e:TimerEvent = null):void
		{
			switch (this._scrollBy)
			{
				case 'line':
					break;
				case 'page':
					switch (this._directionPolarity)
					{
						case 1:
							if (this['mouse' + this._xOrY.toUpperCase()] < this.__thumb.getRect(this)[this._xOrY] + this.__thumb[this._widthOrHeight] / 2) return;
							break;
						case -1:
							if (this['mouse' + this._xOrY.toUpperCase()] > this.__thumb.getRect(this)[this._xOrY] + this.__thumb[this._widthOrHeight] / 2) return;
							break;
					}
					break;
			}
			
			var scrollAmount:Number = this._scrollBy == 'line' ? this.lineScrollSize : this.pageScrollSize || this.pageSize;
			this.scrollPosition = Math.min(this.maxScrollPosition, Math.max(this.scrollPosition + this._directionPolarity * scrollAmount, this.minScrollPosition));
		}		
		
		
		/**
		 *
		 * Handles the down arrow's MOUSE_DOWN events.
		 *
		 */
		private function __downArrowMouseDownHandler(e:MouseEvent):void
		{
			this._directionPolarity = 1;
			this._arrowButtonMouseDownHandler();
		}	


		/**
		 *
		 * Sets up the "component."
		 *
		 */
		private function _init(e:Event = null):void
		{
			if (this.stage)
			{
				this.stage.addEventListener(MouseEvent.MOUSE_UP, this.__thumbMouseUpHandler);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, this._stopTimers);
				this.removeEventListener(Event.ADDED_TO_STAGE, this._init);
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, this._init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._cleanUp);
		}

	
		/**
		 *
		 *
		 *
		 */	
		private function _repeatDelayTimerHandler(e:TimerEvent):void
		{
			this._repeatDelayTimer.stop();
			this._repeatIntervalTimer.reset();
			this._repeatIntervalTimer.start();
		}
	
	
		/**
		 *
		 *
		 *
		 */		 		 		 		
		private function _setDownArrow(downArrow:InteractiveObject):void
		{
			if (downArrow)
			{
				downArrow.addEventListener(MouseEvent.MOUSE_DOWN, this.__downArrowMouseDownHandler);
			}
			
			this.__downArrow = downArrow;
		}
		

		/**
		 *
		 *
		 *
		 */
		private function _setThumb(thumb:InteractiveObject):void
		{
			if (thumb)
			{
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, this.__thumbMouseDownHandler);
				this._originalThumbPosition = new Point(thumb.x, thumb.y);
			}
			
			this.__thumb = thumb;
		}
	
		
		/**
		 *
		 *
		 *
		 */
		private function _setTrack(track:InteractiveObject):void
		{
			if (track)
			{
				track.addEventListener(MouseEvent.MOUSE_DOWN, this.__trackMouseDownHandler);
				this.scrollPosition = 0;
			}
			
			this.__track = track;
		}


		/**
		 *
		 *
		 *
		 */
		private function _setUpArrow(upArrow:InteractiveObject):void
		{
			if (upArrow)
			{
				upArrow.addEventListener(MouseEvent.MOUSE_DOWN, this.__upArrowMouseDownHandler);
			}
			
			this.__upArrow = upArrow;
		}
		

		/**
		 *
		 *
		 *
		 */
		private function _stopTimers(e:MouseEvent = null):void
		{
			this._repeatDelayTimer.stop();
			this._repeatIntervalTimer.stop();
		}
		
	
		/**
		 *
		 * Handles the thumb's MOUSE_DOWN event. Drags the thumb (within the
		 * appropriate bounds).
		 *
		 */
		private function __thumbMouseDownHandler(e:MouseEvent):void
		{
			var thumbMin:Number = this.__track.getRect(this)[this._xOrY] + this.__thumb[this._xOrY] - this.__thumb.getRect(this)[this._xOrY];
			var dragBounds:Rectangle = this.direction == ScrollBarDirection.VERTICAL ? new Rectangle(this.__thumb.x, thumbMin, 0, this.__track.height - this.__thumb.height) : new Rectangle(thumbMin, this.__thumb.y, this.__track.width - this.__thumb.width, 0);
			DragUtil.startDrag(e.currentTarget as DisplayObject, false, dragBounds);

			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._updateScrollPosition);
		}
		
		
		/**
		 *
		 * Handles the thumb's MOUSE_UP event.
		 *
		 */
		private function __thumbMouseUpHandler(e:MouseEvent):void
		{
			DragUtil.stopDrag(this.__thumb as DisplayObject);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this._updateScrollPosition);
		}
		
			
		/**
		 *
		 * Handles the track's MOUSE_DOWN event.
		 *
		 */
		private function __trackMouseDownHandler(e:MouseEvent):void
		{
			if (!this.__thumb) return;
		
			this._directionPolarity = this['mouse' + this._xOrY.toUpperCase()] < this.__thumb[this._xOrY] ? -1 : 1;
			this._scrollBy = 'page';
			this._doScroll();
			this._repeatDelayTimer.reset();
			this._repeatDelayTimer.start();
		}
		

		/**
		 *
		 * Handles the up arrow's MOSE_DOWN event.
		 *
		 */
		private function __upArrowMouseDownHandler(e:MouseEvent):void
		{
			this._directionPolarity = -1;
			this._arrowButtonMouseDownHandler();
		}


		/**
		 *
		 * 
		 *
		 */
		private function _update():void
		{
			this._updateThumb();
			this._updateScrollPosition();
		}


		/**
		 *
		 * Updates the value of scrollPosition based on the position of the
		 * thumb sprite.
		 *
		 */
		private function _updateScrollPosition(e:MouseEvent = null):void
		{
			if (!this.__thumb || !this.__track) return;

			var thumbRect:Rectangle = this.__thumb.getRect(this);
			var trackRect:Rectangle = this.__track.getRect(this);
			var pct:Number = (thumbRect[this._xOrY] - trackRect[this._xOrY]) / (trackRect[this._widthOrHeight] - thumbRect[this._widthOrHeight]);
			var oldScrollPosition:Number = this._scrollPosition;
			this._scrollPosition = pct * (this.maxScrollPosition - this.minScrollPosition) + this.minScrollPosition;
// TODO: Only dispatch if changes (but watch for first update)
			this._dispatchScrollEvent(oldScrollPosition);
		}
		
		
		/**
		 *
		 * Updates the position of the thumb based on scrollPosition.
		 *
		 */
		private function _updateThumb():void
		{
			// Update the scaling of the thumb.
			if (this.__thumb && this.__track)
			{
				this.__thumb.scaleX =
				this.__thumb.scaleY = 1;

				if (this._scaleThumb)
				{
					// Resize the thumb. This is done in something of a
					// roundabout way because of a bug with reading/writing
					// sizes of rotated DisplayObjects in Flash. See
					// <http://www.gskinner.com/blog/archives/2007/08/annoying_as3_bu.html>
					var prop:String = this.__thumb.rotation % 180 ? this._xOrY == 'x' ? 'scaleY' : 'scaleX' : 'scale' + this._xOrY.toUpperCase();
					var size:Number = Math.max(this.minThumbSize, this.__track.getRect(this)[this._widthOrHeight] * this.pageSize / (this.pageSize + this.maxScrollPosition - this.minScrollPosition));
					this.__thumb[prop] = size / this.__thumb[this._widthOrHeight];
				}
			}

			// Update the position of the thumb.
			if (this.direction && this.__thumb && this.__track)
			{
				this._scrollPosition = Math.min(this.maxScrollPosition, Math.max(this.minScrollPosition, this.scrollPosition));
				var thumbMin:Number = this.__track.getRect(this)[this._xOrY] + this.__thumb[this._xOrY] - this.__thumb.getRect(this)[this._xOrY];
				this.__thumb[this._xOrY] = maxScrollPosition ? thumbMin + this.scrollPosition / (this.maxScrollPosition - this.minScrollPosition) * (this.__track[this._widthOrHeight] - this.__thumb[this._widthOrHeight]) : thumbMin;

				var otherProp:String = this._xOrY == 'x' ? 'y' : 'x';
				this.__thumb[otherProp] = this._originalThumbPosition[otherProp];
			}
		}




	}
}
