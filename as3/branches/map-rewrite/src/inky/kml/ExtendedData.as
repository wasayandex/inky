package inky.kml 
{
	import inky.kml.KMLObject;
	import inky.kml.Data;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.26
	 *
	 */
	public class ExtendedData extends KMLObject
	{
		/**
		 *
		 */
		public function ExtendedData(xml:XML)
		{
			super(xml);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function getProperty(propName:*):*
		{
			var dataList:XMLList = this.xml.children().(attribute('name').toString() == propName);
			if (dataList.length())
				return new Data(dataList[0]);
			return null;
		}

		
	}
	
}