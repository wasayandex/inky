package inky.components.transitioningObject
{
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.components.transitioningObject.TransitioningObjectState;
	import inky.components.transitioningObject.events.TransitionEvent;
	import inky.utils.AddedToStageEventFixer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.commands.tokens.AsyncToken;


	/**
	 *
	 *  A decorator that provides ITransitioningObject behavior to a
	 * DisplayObject. Use this when you can't extend TransitioningMovieClip.
	 * 
	 * @see inky.components.transitioningObject.ITransitioningObject
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
		private var _addedToStageEventFixer:AddedToStageEventFixer;
		private var _intro:IAsyncCommand;
		private var _obj:DisplayObject;
		private var _outro:IAsyncCommand;
		private var _removeToken:IAsyncToken;
		private var _state:String;
		private var _transition:Object;




		/**
		 *
		 * Creates a proxy for a DisplayObject that implements
		 * ITransitioningObject.
		 *
		 * @param obj
		 *     The object to decoratevent.
		 *
		 */
		public function TransitioningObjectBehavior(obj:DisplayObject)
		{
			this._obj = obj;
			this._addedToStageEventFixer = new AddedToStageEventFixer(obj);
			this._obj.addEventListener(Event.ADDED_TO_STAGE, this._init, false, 0, true);
		}




		//
		// accessors
		//


		/**
		 * @copy inky.components.transitioningObject.ITransitioningObject#intro
		 */
		public function get intro():IAsyncCommand
		{
			return this._intro;
		}
		/**
		 * @private
		 */
		public function set intro(intro:IAsyncCommand):void
		{
			this._intro = intro;

			var playTransition:Boolean = (this.state == TransitioningObjectState.PLAYING_INTRO) && (this._intro != intro);
			if (playTransition) 
				this._playTransition(intro);
		}


		/**
		 * @copy inky.components.transitioningObject.ITransitioningObject#outro
		 */
		public function get outro():IAsyncCommand
		{
			return this._outro;
		}
		/**
		 * @private	
		 */
		public function set outro(outro:IAsyncCommand):void
		{
			this._outro = outro;

			var playTransition:Boolean = (this.state == TransitioningObjectState.PLAYING_OUTRO) && (this._outro != outro);
			if (playTransition) 
				this._playTransition(outro);
		}


		/**
 		 * @copy inky.components.transitioningObject.ITransitioningObject#state
		 */
		public function get state():String
		{
			return this._state;
		}




		//
		// public methods
		//


		/**
		 * @copy inky.components.transitioningObject.ITransitioningObject#remove()
		 */
		public function remove():IAsyncToken
		{
			var token:IAsyncToken;
			
			if (this.state == TransitioningObjectState.PLAYING_OUTRO)
				token = this._removeToken;
			else if (this._outro)
				token = this._playTransition(this._outro);
			else
				token = this._removeNow(true);

			this._removeToken = token;
			return token;
		}




		//
		// private methods
		//


		/**
		 *
		 * Sets the state to STABLE when the transition finishes.
		 * 
		 */
		private function _actionFinishHandler(token:IAsyncToken):void
		{
			var transition:Object = this._transition;
			this._transition = null;
			var removeNow:Boolean = this._state == TransitioningObjectState.PLAYING_OUTRO;
			this._state = TransitioningObjectState.STABLE;
			this._dispatchFinishEvent(transition);
			if (removeNow)
				this._removeNow();
		}

		
		/**
		 *	
		 */
		private function _dispatchFinishEvent(transition:Object):void
		{
			this.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_FINISH, false, false, transition));
		}
		
		
		/**
		 *	
		 */
		private function _dispatchStartEvent(transition:Object):void
		{
			this.dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_START, false, false, transition));
		}
		
		
		/**
		 *
		 * Initializes the clip by playing the intro. Called when the clip is
		 * added to the stagevent.
		 * 
		 * @param event:Event
		 *     the ADDED_TO_STAGE event that triggered the handler.
		 *
		 */
		private function _init(event:Event = null):void
		{
			if (this._intro)
			{
				this._playTransition(this._intro);
			}
			else
			{
				this._dispatchStartEvent(null);
				this._dispatchFinishEvent(null);
			}
		}


		/**
		 *
		 * Plays a specific transition.
		 *
		 */
		private function _playTransition(transition:IAsyncCommand):IAsyncToken
		{
			var token:IAsyncToken;
			
			/*if (this._transition)
			{
				if (this._transition.cancelable)
					this._transition.cancel();
				else
					throw new Error('You cannot start a transition while an uncancelable transition is already playing. ' + this._transition);
			}*/
			
			this._transition = transition;

			if (transition)
			{
				this._state = this._transition == this.intro ? TransitioningObjectState.PLAYING_INTRO : this._transition == this.outro ? TransitioningObjectState.PLAYING_OUTRO : null;
				token = transition.execute();
				token.addResponder(this._actionFinishHandler);
				this._dispatchStartEvent(transition);
			}
			else
			{
				this._dispatchStartEvent(null);
				this._dispatchFinishEvent(null);
				token = new AsyncToken();
				token.callResponders();
			}
			
			return token;
		}


		/**
		 *
		 * Immediately removes the clip from the display list.
		 * 
		 */
		private function _removeNow(createToken:Boolean = false):IAsyncToken
		{
			var token:IAsyncToken;
			
			if (this._obj.parent)
			{
				this._obj.parent.removeChild(this._obj);
				if (createToken)
				{
					token = new AsyncToken();
					token.callResponders();
				}
			}
			
			return token;
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