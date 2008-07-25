package inky.display
{
	/**
	 *
	 * The TransitioningObjectState class provides constant values to use for the <code>ITransitioningObject.state</code> property.
	 *	
	 * @see inky.display.ITransitioningObject#state
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2008.01.10
	 *
	 */
	public class TransitioningObjectState
	{
		/**
		 *
		 * Specifies that the object is currently playing its intro.
		 *	
		 */
		public static const PLAYING_INTRO:String = 'playingIntro';


		/**
		 *
		 * Specifies that the object is currently playing its outro.
		 *	
		 */
		public static const PLAYING_OUTRO:String = 'playingOutro';


		/**
		 *
		 * Specifies that the object is not playing its intro or outro.
		 *	
		 */
		public static const STABLE:String = 'stable';
	}
}