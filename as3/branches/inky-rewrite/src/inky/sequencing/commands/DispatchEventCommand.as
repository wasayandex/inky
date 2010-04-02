package inky.sequencing.commands 
{
	import inky.utils.getClass;
	import inky.sequencing.events.SequenceEvent;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import inky.sequencing.ISequence;
	import inky.sequencing.commands.ISequenceCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.03.29
	 *
	 */
	public class DispatchEventCommand implements ISequenceCommand
	{
		public var bubbles:Boolean = true;
		public var cancelable:Boolean = false;
		public var event:Event;
		public var eventClass:Object = SequenceEvent;
		private var _sequence:ISequence;
		public var target:IEventDispatcher;
		public var type:String;

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get sequence():ISequence
		{ 
			return this._sequence; 
		}
		/**
		 * @private
		 */
		public function set sequence(value:ISequence):void
		{
			this._sequence = value;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.type)
				throw new Error("You must specify an event type.");
			else if (!this.target)
				throw new Error("You must specify a target.");
			else if (!(this.target is IEventDispatcher))
				throw new Error("The target is not an IEventDispatcher");
			
			var cls:Class;
			
			if (this.eventClass is String || this.eventClass is Class)
			{
				cls = getClass(this.eventClass);
				if (!cls)
					throw new Error("Could not find event class " + this.eventClass);
			}
			else
			{
				throw new Error("Invalid eventClass value: " + this.eventClass);
			}
			
			if (cls == SequenceEvent)
			{
				this.event = new cls(this.sequence, this.type, this.bubbles, this.cancelable);
			}
			else
			{
				try
				{
					this.event = new cls(this.type, bubbles, cancelable);
				}
				catch (error:Error)
				{
					throw new Error("The following error was thrown while attempting to create the event:\n" + error.toString());
				}
			}

			this.target.dispatchEvent(this.event);
		}
		
	}
	
}