package inky.sequencing 
{
	import inky.sequencing.ISequence;
	import inky.sequencing.ISequencePlayer;
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.sequencing.CommandData;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public class SequencePlayer extends EventDispatcher implements ISequencePlayer
	{
		private var currentSequence:ISequence;
		private var pointer:int = 0;
		private var _variables:Object;
// TODO: Allow scope chain in constructor? I.e. it would check those objects for the variables.
		/**
		 *
		 */
		public function SequencePlayer(variables:Object = null)
		{
			this._variables = variables || {};
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get variables():Object
		{
			return this._variables;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function playSequence(sequence:ISequence):void
		{
			this.playSequenceFrom(sequence, 0);
		}
		
		/**
		 * @inheritDoc
		 */
		public function playSequenceFrom(sequence:ISequence, index:int):void
		{
			this.currentSequence = sequence;
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
			this.executeNextCommand();
		}
		
		/**
		 * 
		 */
		private function executeCommandAt(index:int):void
		{
			if (index < 0 || index >= this.currentSequence.length)
				throw new RangeError("The index " + index + " is out of bounds");

			var commandData:CommandData = this.currentSequence.getCommandDataAt(index);
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
				command.addEventListener(Event.COMPLETE, this.command_completeHandler);
				command.execute();
// FIXME: Instead of having the player set variables like this, the property should be set on the player itself and the variables should be searched for in a scope chain that includes the player. That way, if we add more things like this in the future, it won't conflict with variables users have set.
				this.variables.previousCommand = command;
			}
			else
			{
				command.execute();
				this.variables.previousCommand = command;
				this.executeNextCommand();
			}
		}
		
		/**
		 * 
		 */
		private function executeNextCommand():void
		{
			this.pointer++;

			if (this.pointer < this.currentSequence.length)
			{
				this.executeCommandAt(this.pointer);
			}
			else
			{
				// We're at the end of the sequence.
trace("end");
			}
		}
		
		/**
		 * 
		 */
		private function prepareCommand(commandData:CommandData):void
		{
			var command:Object = commandData.command;
			var propertyGetters:Object = commandData.propertyGetters;
			
			for (var prop:String in propertyGetters)
			{
				var getter:Function = propertyGetters[prop];
				command[prop] = getter(this.variables);
			}
		}
		
	}
	
}