package inky.serialization.deserializers 
{
	import inky.serialization.deserializers.IDeserializer;
	
	/**
	 *
	 *  Deserializes elements of a collection.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.19
	 *
	 */
	public interface ICollectionDeserializer
	{
// TODO: I don't like this approach. Is there any way this could just be a normal deserializer with delegates? In any case, I think this should be considered an implementation detail subject to change.


		/**
		 * @param type    the class or class name of the objects to deserialize. For example, passing "Array" will only deserialize the Arrays.
		 */
		function deserializeType(type:Object):Array;
		
		
		/**
		 * 
		 */
		function deserializeAll():Array;
		
		
		/**
		 * 
		 */
		function registerTypeDeserializer(type:Object, deserializer:IDeserializer):void;
	}
	
}