package inky.sequencing 
{
	import inky.sequencing.ISequence;
	import flash.events.Event;
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.IEventDispatcher;
	import inky.sequencing.events.SequenceEvent;
	import inky.sequencing.commands.ISequenceCommand;
	
	/**
	 *
	 *  An object responsible for playing a sequence. This class should not be
	 *  used directly as users control sequences directly through the sequence.
	 *  Instead, this class can be used to create new implementations of
	 *  ISequence without using inheritence.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.01
	 *
	 */
	public class SequencePlayer
	{
		private var abortPending:Boolean = false;
		private var eventDispatcher:IEventDispatcher;
		private var interjectedSequences:Array;
		private var isPlaying:Boolean = false;
		private var pointer:int = 0;
		private var _previousCommand:Object;
		private var sequence:ISequence;
		
		/**
		 *
		 */
		public function SequencePlayer(sequence:ISequence, eventDispatcher:IEventDispatcher = null)
		{
			this.eventDispatcher = eventDispatcher || sequence;
			this.sequence = sequence;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @copy	inky.sequencing.ISequence#currentIndex
		 */
		public function get currentIndex():int
		{ 
			return this.pointer; 
		}
		
		/**
		 * @copy	inky.sequencing.ISequence#currentCommand
		 */
		public function get currentCommand():Object
		{
			return this.pointer >= 0 && this.pointer < this.sequence.length ? this.sequence.getCommandAt(this.pointer) : null;
		}
		
		/**
		 * @copy	inky.sequencing.ISequence#previousCommand
		 */
		public function get previousCommand():Object
		{
			return this._previousCommand;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @copy	inky.sequencing.ISequence#abort()
		 */
		public function abort():Boolean
		{
			if (!this.isPlaying)
			{
				return false;
			}
			else
			{
				this.abortPending = true;
				return true;
			}
		}
		
		/**
		 * @copy	inky.sequencing.ISequence#interject()
		 */
		public function interject(obj:Object):void
		{
			if (!this.isPlaying)
				throw new Error("You can only interject when the sequence is playing.");
			
			if (!obj)
				throw new ArgumentError("Null values not allowed!");
			
			if (!(obj is ISequence))
				throw new Error("I haven't written interject to accept anything other than an ISequence yet. Maybe commands soon? Am I missing something?");
			
			if (!this.interjectedSequences)
				this.interjectedSequences = [];
			
			this.interjectedSequences.push(obj);
		}
		
		/**
		 *
		 */
//		public function interjectOn(dispatcher:IEventDispatcher, eventType:String, filter:Object = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
//		{
// FIXME: Confusing signature. Normally it's interjectionTarget.injerject(interjectedSequence), with this the method is called on the interjectedSequence
//		}
		
		/**
		 * @copy	inky.sequencing.ISequence#play()
		 */
		public function play():void
		{
			if (!this.isPlaying)
				this.executeCommandAt(0);
		}
		
		/**
		 * @copy	inky.sequencing.ISequence#playFrom()
		 */
		public function playFrom(index:int):void
		{
			this.executeCommandAt(index);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function command_completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.executeNextCommand();
		}
		
		/**
		 * 
		 */
		private function dispatch(type:String):void
		{
			if (this.eventDispatcher.hasEventListener(type))
				this.eventDispatcher.dispatchEvent(new SequenceEvent(this.sequence, type));
		}
		
		/**
		 * 
		 */
		private function executeCommandAt(index:int):void
		{
			if (index < 0 || index >= this.sequence.length)
				throw new RangeError("The index " + index + " is out of bounds");

			this.isPlaying = true;

			var command:Object = this.sequence.getCommandAt(index);

			// Make sure it's a command.
			if (!command.hasOwnProperty("execute") || !(command.execute is Function))
				throw new Error("The command " + command + " does not have an execute function!");
				
			if (command is ISequenceCommand)
				command.sequence = this.sequence;

			// Update the pointer/currentCommand
			this.pointer = index;

			// Prepare the command.
			this.dispatch(SequenceEvent.BEFORE_COMMAND_EXECUTE);
			
			// Execute the command.
			if (command is IAsyncCommand)
			{
				command.execute();
				this._previousCommand = command;
				
				// Watch out for IAsyncCommands that execute synchronously!
				if (command.isAsync)
					this.executeNextCommand();
				else
					command.addEventListener(Event.COMPLETE, this.command_completeHandler);
			}
			else
			{
				command.execute();
				this._previousCommand = command;
				this.executeNextCommand();
			}
		}
		
		/**
		 * 
		 */
		private function executeNextCommand():void
		{
			if (this.abortPending)
			{
				this.onAbort();
			}
			else if (this.interjectedSequences && this.interjectedSequences.length)
			{
				var sequence:ISequence = ISequence(this.interjectedSequences.shift());
				sequence.addEventListener(SequenceEvent.COMPLETE, this.interjectedSequence_completeHandler);
				sequence.play();
			}
			else if (++this.pointer < this.sequence.length)
			{
				this.executeCommandAt(this.pointer);
			}
			else
			{
				this.onComplete();
			}
		}

		/**
		 * 
		 */
		private function interjectedSequence_completeHandler(event:SequenceEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.executeNextCommand();
		}

		/**
		 * 
		 */
		private function onAbort():void
		{
			this.onStop();
			this.dispatch(SequenceEvent.ABORT);
		}

		/**
		 * 
		 */
		private function onComplete():void
		{
			this.onStop();
			this.dispatch(SequenceEvent.COMPLETE);
		}
		
		/**
		 * Called by onAbort() and onComplete()
		 */
		private function onStop():void
		{
			this.interjectedSequences = null;
			this.abortPending = false;
			this.isPlaying = false;
			this._previousCommand = null;
			this.pointer = -1;
		}

	}
	
}