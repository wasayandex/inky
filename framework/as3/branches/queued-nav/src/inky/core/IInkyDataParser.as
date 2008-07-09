package inky.core
{


	/**
	 *
	 * <p>Provides a mechanism for defining custom parsing of the inky XML. In
	 * normal circumstances, the following snippet will cause the framework to
	 * create an instance of the Dog class and set its name property to
	 * "Winston".</p>
	 *	
	 * <listing>
	 * &lt;ns:Dog name="winston" />
	 * </listing>
	 *	
	 * <p>However, if the Dog class implements IInkyDataParser, the framework will instead
	 * create an instance of Dog and then call the instance's <code>parseData</code>
	 * method, passing the above XML node as an argument.</p>
	 *	
	 * <p>It is recommended that this functionality be used sparingly, and in
	 * a way that doesn't violate the user's expectations regarding their
	 * XML.</p>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2008.06.26
	 *
	 */
	public interface IInkyDataParser
	{
		/**
		 *
		 * Parses the inky XML node that corresponds to this object.
		 *	
		 * @param data
		 *     The inky XML node that corresponds to this object.
		 * 
		 */
		function parseData(data:XML):void




	}
}