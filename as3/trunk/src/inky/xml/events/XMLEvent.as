package inky.xml.events
{
	import flash.events.Event;
	import inky.xml.xml_internal;

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
	public class XMLEvent extends Event
	{
		public static const ADDED:String = "added";
		public static const REMOVED:String = "removed";
		private var _currentTarget:Object;
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
		public function XMLEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);		
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		override public function get currentTarget():Object
		{
			return this._currentTarget; 
		}


		/**
		 * @inheritDoc
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
			var event:XMLEvent = new XMLEvent(this.type, this.bubbles, this.cancelable);
			event.xml_internal::setCurrentTarget(this.currentTarget);
			event.xml_internal::setTarget(this.target);
			return event;
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("XMLEvent", "type", "bubbles", "cancelable");
		}



		//
		// internal methods
		//
		

		/**
		 *	
		 */
		xml_internal function setCurrentTarget(value:Object):void
		{
			this._currentTarget = value;
		}

		
		/**
		 *	
		 */
		xml_internal function setTarget(value:Object):void
		{
			this._target = value;
		}




	}
}