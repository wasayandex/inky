package inky.app.bootstrapper 
{
	import inky.serialization.deserializers.IDeserializer;
	import inky.app.inky;
	import inky.app.config;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.24
	 *
	 */
	public class ConfigDataDeserializer implements IDeserializer
	{

		/**
		 * @inheritDoc
		 */
		public function deserialize(data:Object):Object
		{
			var xml:XML = new XML(data);
			var configData:Object = {};

			// Parse out the application controller class.
			var applicationControllerClass:String = xml.@config::applicationControllerClass.length() ? xml.@config::applicationControllerClass : null;
			if (applicationControllerClass)
				configData.applicationControllerClass = applicationControllerClass;
			
			configData.debug = false;
			if (xml.@config::debug.length())
				configData.debug = xml.@config::debug == "true" ? true : false;
			
			return configData;
		}

		
	}
	
}