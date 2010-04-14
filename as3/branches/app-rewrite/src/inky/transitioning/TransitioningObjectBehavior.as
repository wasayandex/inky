package inky.transitioning
{
	import inky.utils.AddedToStageEventFixer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import inky.transitioning.events.TransitioningEvent;
	import inky.sequencing.commands.IAsyncCommand;
	import inky.transitioning.TransitioningState;


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
		private var addedToStageEventFixer:AddedToStageEventFixer;
		private var _autoPlayIntro:Boolean;
		private var _intro:IAsyncCommand;
		private var displayObject:DisplayObject;
		private var eventDispatcher:IEventDispatcher;
		private var _outro:IAsyncCommand;
		private var pendingRemoval:Boolean;
		private var _transitioningState:String;

		/**
		 *
		 * Creates a proxy for a DisplayObject that implements
		 * ITransitioningObject.
		 *
		 * @param obj
		 *     The object to decorate.
		 *
		 */
		public function TransitioningObjectBehavior(displayObject:DisplayObject, autoPlayIntro:Boolean = true, eventDispatcher:IEventDispatcher = null)
		{
			this.displayObject = displayObject;
			this.autoPlayIntro = autoPlayIntro;
			this.addedToStageEventFixer = new AddedToStageEventFixer(displayObject);
			this.eventDispatcher = eventDispatcher || displayObject;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * Whether the intro should automatically be played when the object is
		 * added to the stage. If the object is already on the stage, the intro
		 * will be delayed by a frame to allow you to set another value.
		 */
		public function get autoPlayIntro():Boolean
		{ 
			return this._autoPlayIntro; 
		}
		/**
		 * @private
		 */
		public function set autoPlayIntro(value:Boolean):void
		{
			if (value != this._autoPlayIntro)
			{
				this._autoPlayIntro = value;
				
				if (value)
				{
					if (this.displayObject.stage)
						this.displayObject.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
					else
						this.displayObject.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
				}
				else
				{
					this.displayObject.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
					this.displayObject.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
				}
			}
		}

		/**
		 * 
		 */
		public function get intro():IAsyncCommand
		{
			return this._intro;
		}
		/**
		 * @private
		 */
		public function set intro(value:IAsyncCommand):void
		{
			if (value != this._intro)
			{
				if (this._intro)
					this._intro.removeEventListener(Event.COMPLETE, this.intro_completeHandler);
				this._intro = value;
				if (value)
					value.addEventListener(Event.COMPLETE, this.intro_completeHandler);
			}
		}

		/**
		 * 
		 */
		public function get outro():IAsyncCommand
		{
			return this._outro;
		}
		/**
		 * @private	
		 */
		public function set outro(value:IAsyncCommand):void
		{
			if (value != this._outro)
			{
				if (this._outro)
					this._outro.removeEventListener(Event.COMPLETE, this.outro_completeHandler);
				this._outro = value;
				if (value)
					value.addEventListener(Event.COMPLETE, this.outro_completeHandler);
			}
		}


		/**
 		 * 
		 */
		public function get transitioningState():String
		{
			return this._transitioningState;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function playIntro():Boolean
		{
			this.dispatch(TransitioningEvent.INTRO_START);
			
			var isAsync:Boolean = false;
			if (this.intro)
			{
				this.intro.execute();
				isAsync = this.intro.isAsync;
			}

			if (!this.intro || !isAsync)
				this.dispatch(TransitioningEvent.INTRO_FINISH);

			return !isAsync;
		}
		
		/**
		 * @inheritDoc
		 */
		public function playOutro():Boolean
		{
			this.dispatch(TransitioningEvent.OUTRO_START);
			
			var isAsync:Boolean = false;
			if (this.outro)
			{
				this.outro.execute();
				isAsync = this.outro.isAsync;
			}
			
			if (!this.outro || !isAsync)
			{
				this.dispatch(TransitioningEvent.OUTRO_FINISH);
				this.checkRemove();
			}

			return !isAsync;
		}

		/**
		 * @copy inky.components.transitioningObject.ITransitioningObject#remove()
		 */
		public function remove():Boolean
		{
			this.pendingRemoval = true;
			return this.playOutro();
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function intro_completeHandler(event:Event):void
		{
			this.dispatch(TransitioningEvent.INTRO_FINISH);
		}

		/**
		 * 
		 */
		private function outro_completeHandler(event:Event):void
		{
			this.dispatch(TransitioningEvent.OUTRO_FINISH);
			this.checkRemove();
		}

		/**
		 * 
		 */
		private function addedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.playIntro();
		}
		
		/**
		 * 
		 */
		private function dispatch(type:String):void
		{
			this._transitioningState = {
				introStart: TransitioningState.PLAYING_INTRO,
				introFinish: TransitioningState.IDLE,
				outroStart: TransitioningState.PLAYING_OUTRO,
// FIXME: What should the state be after the outro?
				outroFinish: null
			}[type];

			this.eventDispatcher.dispatchEvent(new TransitioningEvent(type));
		}

		/**
		 * 
		 */
		private function enterFrameHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.playIntro();
		}

		/**
		 * Immediately removes the clip from the display list.
		 */
		private function checkRemove():void
		{
			if (this.pendingRemoval)
			{
				this.pendingRemoval = false;

				if (this.displayObject.parent)
					this.displayObject.parent.removeChild(this.displayObject);
			}
		}

	}
}