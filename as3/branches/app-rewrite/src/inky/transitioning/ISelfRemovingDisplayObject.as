package inky.transitioning 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.14
	 *
	 */
	public interface ISelfRemovingDisplayObject
	{
		/**
		 * Removes this object from the display list. Unlike calling the
		 * parent's <code>removeChild()</code> method, calling this method may
		 * not immediately result in the object being removed from the display
		 * list. Instead, an outro action may be started. When the action
		 * finishes, the object will be removed from the stage via a call to
		 * its parent's <code>removeChild()</code> method.
		 *	
		 * @return		true if the removal was instantaeous, otherwise false.
		 * @see flash.display.DisplayObjectContainer#removeChild()
		 */
		function remove():Boolean;
	}
	
}
