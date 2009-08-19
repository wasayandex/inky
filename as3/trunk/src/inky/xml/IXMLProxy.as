package inky.xml 
{
	import flash.events.IEventDispatcher;
	import inky.utils.IEquatable;
	import inky.xml.IXMLListProxy;

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
	public interface IXMLProxy extends IEquatable, IEventDispatcher
	{
// TODO: Does this need to have a source setter? Because we can't include the constructor signature.


		/**
		 *	
		 */
		function get source():XML;


		/**
		 *	@copy Object#toString()
		 */
		function toString():String;



		//
		// xml methods
		//


		/**
		 *	
		 */
		function child(propertyName:Object):IXMLListProxy;


		/**
		 *	
		 */
		function children():IXMLListProxy;


		/**
		 *	
		 */
		function parent():*;


		/**
		 * @copy XML#toXMLString()
		 */
		function toXMLString():String;










	}
}