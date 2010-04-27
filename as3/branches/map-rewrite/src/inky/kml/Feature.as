package inky.kml 
{
	import inky.kml.KMLObject;
	import inky.kml.ExtendedData;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.23
	 *
	 */
	public class Feature extends KMLObject
	{
		
		/**
		 * 
		 */
		public function Feature(xml:XML)
		{
			super(xml);
			this.mapElement("ExtendedData", "extendedData");
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get address():String
		{
			return this.getValueFor("address");
		}

		/**
		 * @inheritDoc
		 */
		public function get description():String
		{
			return this.getValueFor("description");
		}

		/**
		 * @inheritDoc
		 */
		public function get extendedData():ExtendedData
		{
			return this.getValueFor("extendedData")
		}

		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return this.getValueFor("name");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get phoneNumber():String
		{
			return this.getValueFor("phoneNumber");
		}
		
	}
	
}