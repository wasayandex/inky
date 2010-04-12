package inky.utils 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.11.24
	 *
	 */
	public interface IDestroyable
	{
		
		/**
		 * 
		 * Indicates that this object can be "destroyed." 
		 * 
		 * Calling this method doesn't result in the object being destroyed,
		 * but the implementation of the method could get rid of any 
		 * references that would prevent the object from being garbage collected.
		 * 
		 * This method is typically called at the end of an object's life cycle.
		 * For example, a DisplayObject might get destroyed when it is removed from stage.
		 * 
		 */
		function destroy():void;
		

		
	}
	
}
