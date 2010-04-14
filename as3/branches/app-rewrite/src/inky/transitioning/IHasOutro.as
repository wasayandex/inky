package inky.transitioning 
{
    /**
     * Dispatched when an outro starts.
     */
	[Event(name="outroStart")]
	
    /**
     * Dispatched when an outro finishes.
     */
	[Event(name="outroFinish")]
	
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
	public interface IHasOutro
	{
		/**
		 * Plays the object's outro.
		 * 
		 * @return		true if the outro was instantaneous. otherwise, false
		 */
		function playOutro():Boolean;
	}
	
}
