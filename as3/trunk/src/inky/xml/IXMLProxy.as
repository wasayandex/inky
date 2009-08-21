package inky.xml 
{
	import flash.events.IEventDispatcher;
	import inky.utils.IEquatable;
	import inky.xml.IXMLListProxy;
	import inky.xml.IXMLProxy;

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




		//
		// xml methods
		//
// TODO: Add more XML methods! http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/XML.html

		/**
		 *	
		 */
		function appendChild(child:Object):void;
// TODO: What should this return? Model it after E4X or DOM (https://developer.mozilla.org/En/DOM/Node.removeChild)

		
		/**
		 *	
		 */
		function removeChild(child:Object):void;
// TODO: What should this return? Model it after E4X or DOM (https://developer.mozilla.org/En/DOM/Node.removeChild)


		/**
		 *	
		 */
		function child(propertyName:Object):IXMLListProxy;


		/**
		 *	
		 */
		function childIndex():int;


		/**
		 *	
		 */
		function children():IXMLListProxy;


		/**
		 *	
		 */
		function localName():Object;


		/**
		 *	
		 */
		function parent():*;


		/**
		 * @copy XML#toXMLString()
		 */
		function toXMLString():String;


		/**
		 *	
		 */
		function insertChildAfter(child1:Object, child2:Object):void;


		/**
		 *	
		 */
		function insertChildBefore(child1:Object, child2:Object):void;







	}
}