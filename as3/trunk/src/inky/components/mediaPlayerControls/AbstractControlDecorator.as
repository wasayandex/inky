package inky.components.mediaPlayerControls 
{
	import inky.components.mediaPlayerControls.BaseMediaControl;
	import flash.events.Event;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.05.07
	 *
	 */
	public class AbstractControlDecorator extends BaseMediaControl
	{
		private var _control:Object;
		private var _controlChangeEvents:Array;
		
		/**
		 * Decorate a control.
		 * 
		 * @param control    The control to decorate.
		 * @param controlChangeEvents    A list of event types that the control dispatches which should cause a change in the player.
		 */
		public function AbstractControlDecorator(control:Object, controlChangeEvents:Array = null)
		{
			if (!control)
				throw new ArgumentError("Null argument not allowed.");

			this._control = control;
			this._controlChangeEvents = controlChangeEvents || ["propertyChange", Event.CHANGE];
			for each (var eventType:String in this.controlChangeEvents)
			{
				control.addEventListener(eventType, this.controlChangeHandler, false, 0, true);
			}
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 *
		 */
		public function get control():Object
		{ 
			return this._control; 
		}

		/**
		 *
		 */
		public function get controlChangeEvents():Array
		{ 
			return this._controlChangeEvents; 
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *	@inheritDoc
		 */
		override protected function onMediaPlayerRegistered(mediaPlayer:Object):void
		{
			super.onMediaPlayerRegistered(mediaPlayer);

			// If this is the first media player being registered, update the button state to match the player.
			// If there are multiple players registered, update the player to match the button state.
			if (this.registeredMediaPlayers.length == 1)
				this.updateControl(mediaPlayer);
			else
				this.updatePlayers(this.registeredMediaPlayers);
		}

		/**
		 * 
		 */
		public function updateControl(player:Object):void
		{
			throw new Error("You must override this method");
		}
		
		/**
		 * 
		 */
		public function updatePlayers(players:Array):void
		{
			throw new Error("You must override this method");
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function controlChangeHandler(event:Event):void
		{
			this.updatePlayers(this.registeredMediaPlayers);
		}

		/**
		 * Called when one of the registered players' states changes.
		 */
		override protected function mediaPlayerChangeHandler(event:Event):void
		{
			this.updateControl(event.currentTarget);
		}

	}
	
}