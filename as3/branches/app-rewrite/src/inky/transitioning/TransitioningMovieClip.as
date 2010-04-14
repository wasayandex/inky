package inky.transitioning
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import inky.transitioning.IHasIntro;
	import inky.transitioning.IHasOutro;
	import inky.transitioning.ISelfRemovingDisplayObject;
	import inky.transitioning.commands.PlayFrameLabelCommand;


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
	public class TransitioningMovieClip extends MovieClip implements IHasIntro, IHasOutro, ISelfRemovingDisplayObject
	{
		protected var transitioningObjectBehavior:TransitioningObjectBehavior;

		/**
		 * Creates an instance of TransitioningMovieClip.
		 */
		public function TransitioningMovieClip()
		{
			// Create the TransitioningObjectBehavior
			this.transitioningObjectBehavior = new TransitioningObjectBehavior(this);
			
			// Determine whether the clip has "intro" and "outro" labels.
			var hasIntroLabel:Boolean = false;
			var hasOutroLabel:Boolean = false;
			for each (var label:FrameLabel in this.currentLabels)
			{
				hasIntroLabel = hasIntroLabel || (label.name == "intro");
				hasOutroLabel = hasOutroLabel || (label.name == "outro");
			}

			// Set the default transitions.
			if (hasIntroLabel)
			{
				this.transitioningObjectBehavior.intro = new PlayFrameLabelCommand("intro", this);
				this.stop();
			}
			if (hasOutroLabel)
			{
				this.transitioningObjectBehavior.outro = new PlayFrameLabelCommand("outro", this);
				this.stop();
			}
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get transitioningState():String
		{
			return this.transitioningObjectBehavior.transitioningState;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function playIntro():Boolean
		{
			return this.transitioningObjectBehavior.playIntro();
		}

		/**
		 * @inheritDoc
		 */
		public function playOutro():Boolean
		{
			return this.transitioningObjectBehavior.playOutro();
		}

		/**
		 * @inheritDoc
		 */
		public function remove():Boolean
		{
			return this.transitioningObjectBehavior.remove();
		}

	}
}