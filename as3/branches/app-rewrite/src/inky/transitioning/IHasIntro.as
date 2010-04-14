package inky.transitioning 
{
    /**
     * Dispatched when an intro starts.
     */
	[Event(name="introStart")]
	
    /**
     * Dispatched when an intro finishes.
     */
	[Event(name="introFinish")]
	
	/**
	 *
	 *  Indicates that the implementor has an outro animation.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.14
	 *
	 */
	public interface IHasIntro
	{
		/**
		 * Plays the object's intro. Many implementors will call this
		 * automatically when added to the stage.
		 * 
		 * @return		true if the intro was instantaneous. otherwise, false
		 */
		function playIntro():Boolean;
	}
	
}
