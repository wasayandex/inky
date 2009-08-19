package inky.xml 
{
	import inky.collections.IList;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.17
	 *
	 */
	public interface IXMLListProxy extends IList
	{
// TODO: Does this need to have a source setter? Because we can't include the constructor signature.


		/**
		 *	
		 */
		function get source():XMLList;


		/**
		 *	@copy Object#toString()
		 */
		function toString():String;


		//
		// xml methods
		//


		/**
		 * @copy XML#toXMLString()
		 */
		function toXMLString():String;










	}
}