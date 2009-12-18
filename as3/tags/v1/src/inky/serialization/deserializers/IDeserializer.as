package inky.serialization.deserializers 
{
	
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
	public interface IDeserializer
	{
		
		/**
		 *	Converts a serialized format back into an object. The interface
		 *  does not specify the source format so that different serialization
		 *  types may be exchanged for eachother. If you require a specific
		 *  type, implement one of the extending interfaces.
		 */
		function deserialize(object:Object):Object;
		
	}
	
}
