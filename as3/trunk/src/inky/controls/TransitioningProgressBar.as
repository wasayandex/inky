package inky.controls 
{
	import inky.async.actions.PlayFrameLabelAction;
	import inky.async.actions.IAction;
	import inky.components.progressBar.views.BaseProgressBar;
	import inky.components.transitioningObject.ITransitioningObject;
	import inky.components.transitioningObject.TransitioningObjectBehavior;
	import inky.components.transitioningObject.TransitioningObjectState;
	import inky.components.transitioningObject.events.TransitionEvent;
	import flash.display.FrameLabel;
	import inky.async.IAsyncToken;

	
	/**
	 *
	 * A progress bar that implements the ITransitioningObject interface.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @since  2008.02.13
	 *
	 */
	public class TransitioningProgressBar extends BaseProgressBar implements ITransitioningObject 
	{
		private var _proxy:TransitioningObjectBehavior;

		
		/**
		 *
		 * Creates a new TransitioningProgressBar instance.
		 * 
		 */
		public function TransitioningProgressBar()
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
		 * @inheritDoc
		 */
		public function get state():String
		{
			return this._proxy.state;
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
		 * Relays the transition event.
		 * 
		 */
		private function _relayEvent(e:TransitionEvent):void
		{
			this.dispatchEvent(e);
		}




	}
}