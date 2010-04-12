package inky.sequencing 
{
	import inky.sequencing.ISequence;
	import flash.events.EventDispatcher;
	import inky.sequencing.SequencePlayer;
	import inky.sequencing.events.SequenceEvent;
	
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
		private var sequencePlayer:SequencePlayer;
		private var _onAbort:Function;
		private var _onComplete:Function;

		/**
		 *
		 */
		public function AbstractSequence()
		{
			this.addEventListener(SequenceEvent.BEFORE_COMMAND_EXECUTE, this.beforeCommandExecuteHandler);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get currentCommand():Object
		{ 
			return this.sequencePlayer ? this.sequencePlayer.currentCommand : null; 
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentIndex():int
		{ 
			return this.sequencePlayer ? this.sequencePlayer.currentIndex : -1; 
		}
		
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
		public function get onAbort():Function
		{
			return this._onAbort; 
		}
		/**
		 * @private
		 */
		public function set onAbort(value:Function):void
		{
			if (value != this._onAbort)
			{
				if (value != null)
					this.addEventListener(SequenceEvent.ABORT, this.abortHandler);
				else if (this.onAbort != null)
					this.removeEventListener(SequenceEvent.ABORT, this.abortHandler);

				this._onAbort = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get onComplete():Function
		{
			return this._onComplete; 
		}
		/**
		 * @private
		 */
		public function set onComplete(value:Function):void
		{
			if (value != this._onComplete)
			{
				if (value != null)
					this.addEventListener(SequenceEvent.COMPLETE, this.completeHandler);
				else if (this.onComplete != null)
					this.removeEventListener(SequenceEvent.COMPLETE, this.completeHandler);

				this._onComplete = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get previousCommand():Object
		{
			return this.sequencePlayer ? this.sequencePlayer.previousCommand : null;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function abort():Boolean
		{
			return this.getSequencePlayer().abort();
		}

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
		private function abortHandler(event:SequenceEvent):void
		{
			if (this.onAbort != null)
				this.onAbort(this);
		}
		
		/**
		 * 
		 */
		private function beforeCommandExecuteHandler(event:SequenceEvent):void
		{
			this.onBeforeCommandExecute();
		}
		
		/**
		 * 
		 */
		private function completeHandler(event:SequenceEvent):void
		{
			if (this.onComplete != null)
				this.onComplete(this);
		}

		/**
		 * 
		 */
		private function getSequencePlayer():SequencePlayer
		{
			if (!this.sequencePlayer)
				this.sequencePlayer = new SequencePlayer(this);
			return this.sequencePlayer;
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function onBeforeCommandExecute():void
		{
		}
		
	}
	
}