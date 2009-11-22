package inky.binding.events
{
	/**
	 *
	 * The PropertyChangeEventKind class provides constant values to use for the <code>PropertyChangeEvent.kind</code> property.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2008.04.18
	 *
	 */
	public class PropertyChangeEventKind
	{
		/**
		 *
		 * Specifies that the property has changed by being deleted.
         * 
		 */
		public static const DELETE:String = 'delete';


		/**
		 *
		 * Specifies that the property has changed by being given a new value.
	     * 
		 */
		public static const UPDATE:String = 'update';
	}
}
