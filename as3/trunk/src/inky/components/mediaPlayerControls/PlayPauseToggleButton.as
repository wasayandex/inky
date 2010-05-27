package inky.components.mediaPlayerControls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import inky.components.mediaPlayerControls.AbstractControlDecorator;

	/**
	 *
	 *  Decorates a toggle button (a button with a selected property), allowing any toggle button to be a play/pause button.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.07
	 *
	 */
	public class PlayPauseToggleButton extends AbstractControlDecorator
	{
		// VideoState constants. The Flash compiler is a little too smart and
		// won't include the VideoState class unless we have the component in
		// the library.
		private static const BUFFERING:String = "buffering";
		private static const PAUSED:String = "paused";
		private static const PLAYING:String = "playing";
		private static const STOPPED:String = "stopped";
		
		// VideoEvent constants. See explanation above.
		private static const STATE_CHANGE:String = "stateChange";

		private var _selected:Boolean;

		/**
		 * Create a new PlayPauseToggleButton (out of a normal toggle button)
		 * 
		 * @param button    The button to decorate. Must have a boolean selected attribute.
		 * @param updateEvents    A list of event types to check the button's selected property on.
		 */
		public function PlayPauseToggleButton(control:Object, controlUpdateEvents:Array = null)
		{
			controlUpdateEvents = controlUpdateEvents || ["propertyChange", MouseEvent.CLICK, "selected", "unselected", Event.CHANGE];
			super(control, controlUpdateEvents);

			if (!this.control || !this.control.hasOwnProperty("selected"))
				throw new ArgumentError("Button must have a selected property.");
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *	@inheritDoc
		 */
		override public function registerMediaPlayer(mediaPlayer:Object, playerChangeEvents:Array = null):void
		{
			super.registerMediaPlayer(mediaPlayer, playerChangeEvents || [STATE_CHANGE]);
			this.updateControl(mediaPlayer);
		}

		/**
		 *	@inheritDoc
		 */
		override public function updateControl(player:Object):void
		{
			var state:String = player ? player.state : STOPPED;

			switch (state)
			{
				case PLAYING:
				{
					this.control.selected = true;
					break;
				}
				default:	
				{
					this.control.selected = false;
					break;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function updatePlayers(players:Array):void
		{			
			var mediaPlayer:Object;
			if (this.control.selected)
			{
				for each (mediaPlayer in players)
				{
					mediaPlayer.play();
				}
			}
			else
			{
				for each (mediaPlayer in players)
				{
					mediaPlayer.pause();
				}
			}
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 *	@inheritDoc
		 */
		override protected function controlChangeHandler(event:Event):void
		{
			// Set this instance's selected value based on the new value of the decorated button.
			var value:Boolean = event.currentTarget.selected;
			if (value != this._selected)
			{
				this._selected = value;
				this.updatePlayers(this.registeredMediaPlayers);
			}
		}
		
	}
}