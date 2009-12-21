package inky.serialization.serializers.xml
{
	import inky.serialization.serializers.ISerializer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.16
	 *
	 */
	public interface IXMLSerializer extends ISerializer
	{
		/**
		 *	
		 */
		function serializeToXML(object:Object, deep:Boolean = false):XML;
		
	}
	
}