package inky.components.mediaPlayerControls 
{
	import inky.components.mediaPlayerControls.AbstractControlDecorator;
	import flash.events.Event;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.05.27
	 *
	 */
	public class SeekControl extends AbstractControlDecorator
	{
		private var _value:Number;
		
		/**
		 *
		 */
		public function SeekControl(control:Object, controlUpdateEvents:Array = null)
		{
			controlUpdateEvents = controlUpdateEvents || ["propertyChange", Event.CHANGE];
			super(control, controlUpdateEvents);

			if (!this.control || !this.control.hasOwnProperty("value"))
				throw new ArgumentError("Control must have a value property.");
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *	@inheritDoc
		 */
		override public function registerMediaPlayer(mediaPlayer:Object, playerChangeEvents:Array = null):void
		{
			super.registerMediaPlayer(mediaPlayer, playerChangeEvents || ["playheadUpdate"]);
		}

		/**
		 *	@inheritDoc
		 */
		override public function updateControl(player:Object):void
		{
			this.control.value = player.playheadTime / player.totalTime;
		}

		/**
		 * @inheritDoc
		 */
		override public function updatePlayers(players:Array):void
		{
			if (!isNaN(this._value))
			{
				for each (var mediaPlayer:Object in players)
				{
					mediaPlayer.seek(this._value * mediaPlayer.totalTime);
				}
			}
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 *@inheritDoc
		 */
		override protected function controlChangeHandler(event:Event):void
		{
			// Set this instance's selected value based on the new value of the decorated control.
			var value:Number = Math.min(1, Math.max(0, event.currentTarget.value));
			if (value != this._value)
			{
				this._value = value;
				this.updatePlayers(this.registeredMediaPlayers);
			}
		}

	}
	
}