package inky.framework.display
{
	import  inky.framework.events.ActionEvent;
	import inky.framework.utils.IAction;
	import inky.framework.display.TransitioningObjectState;
	import inky.framework.events.TransitionEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;


	/**
	 *
	 *  A decorator that provides ITransitioningObject behavior to a
	 * DisplayObject. Use this when you can't extend TransitioningMovieClip.
	 * 
	 * @see inky.framework.display.ITransitioningObject
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
	public class TransitioningObjectBehavior extends EventDispatcher
	{
		private var _intro:IAction;
		private var _obj:DisplayObject;
		private var _outro:IAction;
		private var _state:String;
		private var _transition:Object;


		/**
		 *
		 * Creates a proxy for a DisplayObject that implements
		 * ITransitioningObject.
		 *
		 * @param obj
		 *     The object to decorate.
		 *
		 */
		public function TransitioningObjectBehavior(obj:DisplayObject)
		{
			this._obj = obj;
			this._obj.addEventListener(Event.ADDED_TO_STAGE, this._init, false, 0, true);
		}




		//
		// accessors
		//


		/**
		 * @copy inky.framework.display.ITransitioningObject#intro
		 */
		public function get intro():IAction
		{
			return this._intro;
		}
		/**
		 * @private
		 */
		public function set intro(intro:IAction):void
		{
			if (this._intro)
			{
				this._intro.removeEventListener(ActionEvent.ACTION_FINISH, this._actionFinishHandler);
				this._intro.removeEventListener(ActionEvent.ACTION_START, this._action2TransitionEvents);
				this._intro.removeEventListener(ActionEvent.ACTION_FINISH, this._action2TransitionEvents);
			}
			
			var playTransition:Boolean = (this.state == TransitioningObjectState.PLAYING_INTRO) && (this._intro != intro);
			this._intro = intro;

			if (intro)
			{
				intro.addEventListener(ActionEvent.ACTION_FINISH, this._actionFinishHandler, false, 0, true);
				intro.addEventListener(ActionEvent.ACTION_START, this._action2TransitionEvents, false, 0, true);
				intro.addEventListener(ActionEvent.ACTION_FINISH, this._action2TransitionEvents, false, 0, true);
				intro.target = this._obj;
			}


			if (playTransition) this._playTransition(intro);
		}


		/**
		 * @copy inky.framework.display.ITransitioningObject#outro
		 */
		public function get outro():IAction
		{
			return this._outro;
		}
		/**
		 * @private	
		 */
		public function set outro(outro:IAction):void
		{
			if (this._outro)
			{
				this._outro.removeEventListener(ActionEvent.ACTION_FINISH, this._actionFinishHandler);
				this._outro.removeEventListener(ActionEvent.ACTION_START, this._action2TransitionEvents);
				this._outro.removeEventListener(ActionEvent.ACTION_FINISH, this._action2TransitionEvents);
				this._outro.removeEventListener(ActionEvent.ACTION_FINISH, this._removeNow);
			}
			
			var playTransition:Boolean = (this.state == TransitioningObjectState.PLAYING_OUTRO) && (this._outro != outro);
			this._outro = outro;

			if (outro)
			{
				outro.addEventListener(ActionEvent.ACTION_FINISH, this._actionFinishHandler, false, 0, true);
				outro.addEventListener(ActionEvent.ACTION_START, this._action2TransitionEvents, false, 0, true);
				outro.addEventListener(ActionEvent.ACTION_FINISH, this._action2TransitionEvents, false, 0, true);
				outro.target = this._obj;
			}
			
			if (playTransition) this._playTransition(outro);
		}


		/**
 		 * @copy inky.framework.display.ITransitioningObject#state
		 */
		public function get state():String
		{
			return this._state;
		}




		//
		// public methods
		//


		/**
		 * @copy inky.framework.display.ITransitioningObject#remove()
		 */
		public function remove():void
		{
			if (this.state == TransitioningObjectState.PLAYING_OUTRO) return;

			if (this._outro)
			{
				// If there is an outro, play it before removing the clip.
				this._outro.addEventListener(ActionEvent.ACTION_FINISH, this._removeNow, false, 0, true);
				this._playTransition(this._outro);
			}
			else
			{
				// If the clip doesn't have an outro, remove it immediately.
				this._playTransition(this._outro);
				this._removeNow();
			}
		}




		//
		// private methods
		//


		/**
		 *
		 * Converts ActionEvents into TransitionEvents.
		 * 
		 */
		private function _action2TransitionEvents(e:ActionEvent):void
		{
			var newType:String;
			switch (e.type)
			{
				case ActionEvent.ACTION_START:
					newType = TransitionEvent.TRANSITION_START;
					break;
				case ActionEvent.ACTION_FINISH:
					newType = TransitionEvent.TRANSITION_FINISH;
					break;
			}

			this.dispatchEvent(new TransitionEvent(newType, false, false, this._transition));
		}


		/**
		 *
		 * Sets the state to STABLE when the transition finishes.
		 * 
		 */
		private function _actionFinishHandler(e:ActionEvent):void
		{
			this._state = TransitioningObjectState.STABLE;
		}


		/**
		 *
		 * Initializes the clip by playing the intro. Called when the clip is
		 * added to the stage.
		 * 
		 * @param e:Event
		 *     the ADDED_TO_STAGE event that triggered the handler.
		 *
		 */
		private function _init(e:Event = null):void
		{
			if (e.target != this._obj) return;
			this._playTransition(this._intro);

			if (!this._intro)
			{
				this.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_START, false, false, null));
				this.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_FINISH, false, false, null));
			}
		}


		/**
		 *
		 * Plays a specific transition.
		 *
		 */
		private function _playTransition(transition:IAction):void
		{
			this._transition = transition;

			if (transition)
			{
				this._state = this._transition == this.intro ? TransitioningObjectState.PLAYING_INTRO : this._transition == this.outro ? TransitioningObjectState.PLAYING_OUTRO : null;
				transition.start();
			}
			else
			{
				this.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_START, false, false, null));
				this.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_FINISH, false, false, null));
			}
		}


		/**
		 *
		 * Immediately removes the clip from the display list. Can be triggerd
		 * by an event or called directly.
		 * 
		 * @param e:Event
		 *     the event that triggered the handler.
		 * 
		 */
		private function _removeNow(e:Event = null):void
		{
			if (this._obj.parent)
			{
				this._obj.parent.removeChild(this._obj);
			}
		}


		/**
		 *
		 * Immediately stops a transition.
		 *
		 */
		private function _stopTransition():void
		{
			if (this._transition)
			{
				this._transition.stop();
				this._transition = null;
			}
		}




	}
}
