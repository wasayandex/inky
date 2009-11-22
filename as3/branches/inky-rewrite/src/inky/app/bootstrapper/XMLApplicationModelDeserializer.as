package inky.app.bootstrapper 
{
	import inky.serialization.deserializers.IDeserializer;
	import inky.app.model.ApplicationModel;
	
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
	public class XMLApplicationModelDeserializer implements IDeserializer
	{
		
		/**
		 *	@inheritDoc
		 */
		public function deserialize(object:Object):Object
		{
			var data:XML = new XML(object);
//			trace(data.toXMLString());

			return new ApplicationModel(data);
		}




	}
	
}