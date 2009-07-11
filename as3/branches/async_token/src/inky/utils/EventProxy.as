package inky.utils
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import inky.binding.utils.BindingUtil;
	import flash.events.EventDispatcher;


	/**
	 *
	 *  Allows you to delay the adding of event listeners until an object becomes available.
	 *	
	 *	@example The following code allows a display object to listen for stage
	 *	resizing without having to wait for it to be added to the stage. (Though
	 *	the handler will not fire until the display object's stage property is
	 *	set.)
	 *  <listing version="3.0" >
	 *		var mySprite:Sprite = new Sprite();
	 *		var ep:EventProxy = new EventProxy(mySprite, "stage");
	 *		ep.addEventListener(Event.RESIZE, trace);
	 *  </listing>
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.05.15
	 *
	 */
	public class EventProxy extends EventDispatcher
	{
		private var _target:IEventDispatcher;
		private var _eventTypes:Object;


		/**
		 *
		 *	Creates a new EventProxy for the specified object.
		 *	
		 */
		public function EventProxy(obj:Object, chain:Object = null)
		{
			this._eventTypes = {};
			
			if (chain)
				BindingUtil.bindSetter(this._targetChanged, obj, chain)
			else
				this._targetChanged(obj as IEventDispatcher);
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			// Add the event type to the list of watched events.
			this._eventTypes[type] = null;

			// Add the listener.
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			// Make sure the event is relayed.
			if (this._target)
				this._target.addEventListener(type, this._relayEvent, false, 0, true);
		}


		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			// Remove the event listener.
			super.removeEventListener(type, listener, useCapture);
			
			// If there are no listeners for this event type, remove it from the list of watched events.
			if (!this.willTrigger(type))
				delete this._eventTypes[type];
		}




		//
		// private methods
		//


		/**
		 *
		 */
		private function _relayEvent(event:Event):void
		{
			this.dispatchEvent(event);
		}


		/**
		 *	
		 */
		private function _targetChanged(target:IEventDispatcher):void
		{
			var type:String;

			// Don't watch the old target's events anymore.
			if (this._target)
			{
				for (type in this._eventTypes)
					this._target.removeEventListener(type, this._relayEvent);
			}

			// Watch the new target's events.
			if (target)
			{
				for (type in this._eventTypes)
					target.addEventListener(type, this._relayEvent, false, 0, true);
			}

			// Update the target property.
			this._target = target;
		}




	}
}