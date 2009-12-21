package inky.serialization.deserializers.xml
{
	import inky.serialization.deserializers.IDeserializer;
	
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
	public interface IXMLDeserializer extends IDeserializer
	{

		/**
		 *	
		 */
		function deserializeXML(data:XML):Object;


	}
	
}