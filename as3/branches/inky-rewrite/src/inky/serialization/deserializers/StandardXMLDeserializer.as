package inky.serialization.deserializers 
{
	import inky.serialization.deserializers.IXMLDeserializer;
	import flash.utils.getDefinitionByName;
	
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
	public class StandardXMLDeserializer implements IXMLDeserializer
	{
		

		/**
		 *	@inheritDoc
		 */
		public function deserializeXML(data:XML):Object
		{
			var qName:QName = data.name();
			var className:String = String(qName.uri).replace("*", "") + qName.localName;
			var cls:Class = getDefinitionByName(className) as Class;

			var result:Object = new cls();
			
			
			
			return result;
		}
		
		
		
		/**
		 *	@inheritDoc
		 */
		public function deserialize(object:Object):Object
		{
			if (!(object is XML))
				throw new ArgumentError();

			return this.deserializeXML(object as XML);
		}



	
	}
	
}