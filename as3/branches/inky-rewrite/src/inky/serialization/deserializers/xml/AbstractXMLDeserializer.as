package inky.serialization.deserializers.xml 
{
	import inky.serialization.deserializers.xml.IXMLDeserializer;
	
	/**
	 *
	 *  Provides an implementation with a pre-defined deserialize() method, appropriate for XML deserializers.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.19
	 *
	 */
	public class AbstractXMLDeserializer implements IXMLDeserializer
	{
		
		/**
		 * @inheritDoc
		 */
		public function deserialize(object:Object):Object
		{
			if (!(object is XML))
				throw new ArgumentError(this + " can only deserialize XML");
			return this.deserializeXML(object as XML);
		}


		/**
		 * @inheritDoc
		 */
		public function deserializeXML(data:XML):Object
		{
			throw new Error("You must override AbstractXMLDeserializer.deserializeXML");
		}

		
	}
	
}