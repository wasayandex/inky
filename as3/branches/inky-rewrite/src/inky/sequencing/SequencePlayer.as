package inky.sequencing 
{
	import inky.sequencing.ISequence;
	import flash.events.Event;
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.IEventDispatcher;
	import inky.sequencing.events.SequenceEvent;
	
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
		private var eventDispatcher:IEventDispatcher;
		private var pointer:int = 0;
		private var _previousCommand:Object;
		private var sequence:ISequence;
		private var variables:Object;
		
		/**
		 *
		 */
		public function SequencePlayer(sequence:ISequence, variables:Object, eventDispatcher:IEventDispatcher = null)
		{
			this.eventDispatcher = eventDispatcher || sequence;
			this.sequence = sequence;
			this.variables = variables;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function get previousCommand():Object
		{
			return this._previousCommand;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function play():void
		{
			this.executeCommandAt(0);
		}
		
		/**
		 * 
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
		private function executeCommandAt(index:int):void
		{
			if (index < 0 || index >= this.sequence.length)
				throw new RangeError("The index " + index + " is out of bounds");

			var commandData:CommandData = this.sequence.getCommandDataAt(index);
			var command:Object = commandData.command;

			// Make sure it's a command.
			if (!command.hasOwnProperty("execute") || !(command.execute is Function))
				throw new Error("The command " + command + " does not have an execute function!");

			// Update the pointer.
			this.pointer = index;

			// Prepare the command.
			this.prepareCommand(commandData);
			
			// Execute the command.
			if (command is IAsyncCommand)
			{
				command.execute();
				this._previousCommand = command;
				
				// Watch out for IAsyncCommands that execute synchronously!
				if (command.isComplete)
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
			this.pointer++;

			if (this.pointer < this.sequence.length)
			{
				this.executeCommandAt(this.pointer);
			}
			else
			{
				// We're at the end of the sequence.
				this._previousCommand = null;
				this.eventDispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.COMPLETE));
			}
		}
		
		/**
		 * 
		 */
		private function prepareCommand(commandData:CommandData):void
		{
			var command:Object = commandData.command;
			var injectors:Array = commandData.injectors;
			
			for each (var injector:Function in injectors)
			{
				injector(command, this.variables);
			}
		}
		
	}
	
}