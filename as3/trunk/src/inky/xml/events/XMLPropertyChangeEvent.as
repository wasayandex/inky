package inky.xml.events
{
	import flash.events.Event;
	import inky.binding.events.PropertyChangeEvent;
	import inky.events.IRelayableEvent;
	import flash.events.EventPhase;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.19
	 *
	 */
	public class XMLPropertyChangeEvent extends PropertyChangeEvent implements IRelayableEvent
	{
		private var _currentTarget:Object;
		private var _eventPhase:uint;
		private var _target:Object;


		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param bubbles
		 *      Specifies whether the event can bubble up the display list hierarchy.
		 *  @param cancelable
		 *      Specifies whether the behavior associated with the event can be prevented.
		 *
		 */
		public function XMLPropertyChangeEvent(type:String, cancelable:Boolean = false, kind:String = null, property:Object = null, oldValue:Object = null, newValue:Object = null, source:Object = null)
		{
			super(type, false, cancelable, kind, property, oldValue, newValue, source);
		}




		//
		// accessors
		//


		/**
		 *	@inheritDoc
		 */
		override public function get currentTarget():Object
		{
			return this._currentTarget;
		}
		
		
		/**
		 *	@inheritDoc
		 */
		override public function get eventPhase():uint
		{
			return this._eventPhase;
		}


		/**
		 *	@inheritDoc
		 */
		override public function get target():Object
		{
			return this._target;
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var event:XMLPropertyChangeEvent = new XMLPropertyChangeEvent(type, cancelable, kind, property, oldValue, newValue, source);
			event.prepare(this.currentTarget, this.target);
			return event;
		}

		
		/**
		 *	@inheritDoc
		 */
		public function prepare(curentTarget:Object, target:Object):void
		{
			this._currentTarget = curentTarget;
			this._target = target;
			this._eventPhase = currentTarget == target ? EventPhase.AT_TARGET : EventPhase.BUBBLING_PHASE;
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("XMLPropertyChangeEvent", "type", "cancelable");
		}




	}
}