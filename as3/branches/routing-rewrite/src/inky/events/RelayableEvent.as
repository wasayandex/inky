package inky.events
{
	import flash.events.Event;
	import inky.events.IRelayableEvent;
	import flash.events.IEventDispatcher;
	import flash.events.EventPhase;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.23
	 *
	 */
	public class RelayableEvent extends Event implements IRelayableEvent
	{
		private var _currentTarget:Object;
		private var _eventPhase:uint;
		private var _target:Object;


		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param cancelable
		 *      Specifies whether the behavior associated with the event can be prevented.
		 *
		 */
		public function RelayableEvent(type:String, cancelable:Boolean = false)
		{
			super(type, false, cancelable);		
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
			return new RelayableEvent(this.type, this.cancelable);
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
			return this.formatToString("RelayableEvent", "type", "bubbles", "cancelable");
		}




	}
}