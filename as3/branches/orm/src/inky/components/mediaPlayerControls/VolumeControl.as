package inky.components.mediaPlayerControls
{
	import flash.events.Event;
	import inky.components.mediaPlayerControls.AbstractControlDecorator;

	/**
	 *  A decorator that makes any component with a value getter into a volume control.
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@author Ryan Sprake
	 *	@since  2009.10.30
	 *
	 */
	public class VolumeControl extends AbstractControlDecorator
	{
		private var _value:Number;
		
		/**
		 *
		 */
		public function VolumeControl(control:Object, controlUpdateEvents:Array = null)
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
			super.registerMediaPlayer(mediaPlayer, playerChangeEvents || ["soundUpdate"]);
		}

		/**
		 *	@inheritDoc
		 */
		override public function updateControl(player:Object):void
		{
			this.control.value = player.volume;
		}

		/**
		 * @inheritDoc
		 */
		override public function updatePlayers(players:Array):void
		{			
			for each (var mediaPlayer:Object in players)
			{
				mediaPlayer.volume = this._value;
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