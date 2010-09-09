package inky.sequencing.commands 
{
	import flash.events.EventDispatcher;
	import inky.sequencing.commands.ICommand;
	import inky.sequencing.ISequence;
	import flash.events.Event;
	import inky.sequencing.events.SequenceEvent;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.09.08
	 *
	 */
	public class PlaySequenceCommand extends EventDispatcher implements ICommand
	{
		public var sequence:ISequence;
		private var _isInstantaneous:Boolean = true;
		
		/**
		 *
		 */
		public function PlaySequenceCommand(sequence:ISequence = null)
		{
			this.sequence = sequence;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isInstantaneous():Boolean
		{ 
			return this._isInstantaneous; 
		}
		/**
		 * @private
		 */
		public function set isInstantaneous(value:Boolean):void
		{
			this._isInstantaneous = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.sequence)
				throw new Error("No sequence defined.");
			
			this.sequence.addEventListener(SequenceEvent.COMPLETE, this.sequenceCompleteHandler);
			this.sequence.play();
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function sequenceCompleteHandler(event:SequenceEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

	}
	
}