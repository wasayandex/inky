package inky.serialization.serializers
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
	public interface ISerializer
	{
		/**
		 *	Converts an object into a format that may be sent across a network.
		 *  The interface does not specify the target format so that different
		 *  serialization types may be exchanged for eachother. If you require
		 *  a specific type, implement one of the extending interfaces.
		 */
		function serialize(object:Object, deep:Boolean = false):Object;

		
	}
	
}
