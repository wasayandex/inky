package inky.sequencing 
{
	import inky.sequencing.ISequence;
	import flash.events.EventDispatcher;
	import inky.sequencing.CommandData;
	import inky.sequencing.SequencePlayer;
	
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
	public class AbstractSequence extends EventDispatcher implements ISequence
	{
		private var id:String;
		private var sequencePlayer:SequencePlayer;
		private var _variables:Object;

		/**
		 *
		 */
		public function AbstractSequence(variables:Object = null, id:String = "sequence")
		{
			this.id = id;
			this._variables = variables || {};

			if (this._variables[id] && (this._variables[id] != this))
				throw new ArgumentError("The id \"" + id + "\" is already being used on the provided variables for another sequence.")
			
			this._variables[id] = this;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			throw new Error("You must override this method.");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get previousCommand():Object
		{
			return this.sequencePlayer ? this.sequencePlayer.previousCommand : null;
		}
		
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
		public function getCommandAt(index:int):Object
		{
			throw new Error("You must override this method.");
		}
		
		/**
		 * @inheritDoc
		 */
		public function getCommandDataAt(index:int):CommandData
		{
			throw new Error("You must override this method.");
		}

		/**
		 * @inheritDoc
		 */
		public function interject(obj:Object):void
		{
			this.getSequencePlayer().interject(obj);
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			this.getSequencePlayer().play();
		}
		
		/**
		 * @inheritDoc
		 */
		public function playFrom(index:int):void
		{
			this.getSequencePlayer().playFrom(index);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function getSequencePlayer():SequencePlayer
		{
			return this.sequencePlayer || (this.sequencePlayer = new SequencePlayer(this, this.variables));
		}

		
	}
	
}