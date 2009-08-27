package inky.controls 
{
	import com.exanimo.controls.ButtonClip;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import inky.components.transitioningObject.ITransitioningObject;
	import inky.components.transitioningObject.TransitioningObjectBehavior;
	import inky.components.transitioningObject.TransitioningObjectState;
	import inky.components.transitioningObject.events.TransitionEvent;
	import inky.async.actions.PlayFrameLabelAction;
	import inky.async.actions.IAction;
	import inky.async.IAsyncToken;

	
	/**
	 *
	 * A button whose states are specified with frame labels and that
	 * implements ITransitioningObject functionality. Use this class if you want
	 * a button that uses timeline animation and has an intro or outro.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter (matthew@exanimo.com)
	 * @since  01.02.2008
	 *
	 */
	public class TransitioningButtonClip extends ButtonClip implements ITransitioningObject
	{
		private var _proxy:TransitioningObjectBehavior;

		
		/**
		 *
		 * Creates a new TransitioningButtonClip instance.
		 * 
		 */
		public function TransitioningButtonClip()
		{
			this._proxy = new TransitioningObjectBehavior(this);
			// Determine whether the clip has "intro" and "outro" labels.
			var hasIntroLabel:Boolean = false;
			var hasOutroLabel:Boolean = false;
			for each (var label:FrameLabel in this.currentLabels)
			{
				hasIntroLabel = hasIntroLabel || (label.name == 'intro');
				hasOutroLabel = hasOutroLabel || (label.name == 'outro');
			}

			// Set the default transitions.
			if (hasIntroLabel)
			{
				this.intro = new PlayFrameLabelAction('intro', this);
			}
			if (hasOutroLabel)
			{
				this.outro = new PlayFrameLabelAction('outro', this);
			}
			
			this._proxy.addEventListener(TransitionEvent.TRANSITION_START, this._relayEvent);
			this._proxy.addEventListener(TransitionEvent.TRANSITION_FINISH, this._relayEvent);

			this.mouseEnabled = false;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get intro():IAction
		{
			return this._proxy.intro;
		}
		/**
		 * @private
		 */
		public function set intro(intro:IAction):void
		{
			this._proxy.intro = intro;
		}


		/**
		 * @inheritDoc
		 */
		public function get outro():IAction
		{
			return this._proxy.outro;
		}
		/**
		 * @private
		 */
		public function set outro(outro:IAction):void
		{
			this._proxy.outro = outro;
		}


		/**
		 * 
		 * Gets the state of the TransitioningButtonClip. Possible values are
		 * TransitioningObjectState.PLAYING_INTRO,
		 * TransitioningObjectState.PLAYING_OUTRO,
		 * ButtonState.SELECTED_UP, ButtonState.SELECTED_OVER,
		 * ButtonState.SELECTED_DISABLED, ButtonState.SELECTED_DOWN,
		 * ButtonState.DOWN, ButtonState.OVER, ButtonState.UP,
		 * ButtonState.EMPHASIZED, ButtonState.DISABLED.
		 * 
		 * @see inky.components.transitioningObject.TransitioningObjectState
		 * @see com.exanimo.controls.ButtonState
		 * 
		 */
		override public function get state():String
		{
			return this._proxy.state == TransitioningObjectState.STABLE ? super.state : this._proxy.state;
		}	




		//
		// public methods
		//
		

		/**
		 * @inheritDoc
		 */
		public function remove():IAsyncToken
		{
			return this._proxy.remove();
		}




		//
		// private methods
		//
		
		
		/**
		 *
		 * Relays the proxy's transition event.
		 * 
		 */
		private function _relayEvent(e:TransitionEvent):void
		{
			this.mouseEnabled = e.type == TransitionEvent.TRANSITION_FINISH;
			this.dispatchEvent(e);
		}




	}
}