package inky.framework.display
{
	import inky.framework.transitions.PlayFrameLabelAction;
	import inky.framework.utils.IAction;
	import inky.framework.display.ITransitioningObject;
	import inky.framework.display.TransitioningObjectBehavior;
	import inky.framework.events.TransitionEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;


	/**
	 *
	 *  A MovieClip implementation of the ITransitioningObject interface.
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.09
	 *
	 */
	public class TransitioningMovieClip extends MovieClip implements ITransitioningObject
	{
		private var _proxy:TransitioningObjectBehavior;


		/**
		 *
		 * Creates an instance of TransitioningMovieClip.
		 *
		 */
		public function TransitioningMovieClip()
		{
			// Create the TransitioningObjectBehavior
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
				this.intro = new PlayFrameLabelAction('intro');
			}
			if (hasOutroLabel)
			{
				this.outro = new PlayFrameLabelAction('outro');
			}
			
			this._proxy.addEventListener(TransitionEvent.TRANSITION_START, this._relayEvent, false, 0, true);
			this._proxy.addEventListener(TransitionEvent.TRANSITION_FINISH, this._relayEvent, false, 0, true);
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
		public function remove():void
		{
			this._proxy.remove();
		}




		//
		// private methods
		//


		/**
		 *
		 * Relays the TransitionEvent from the TransitioningObjectBehavior
		 * decorator.
		 * 
		 */
		private function _relayEvent(e:TransitionEvent):void
		{
			this.dispatchEvent(e);
		}




	}
}
