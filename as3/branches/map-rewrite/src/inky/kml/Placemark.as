package inky.kml 
{
	import inky.kml.Feature;
	import inky.kml.Point;
	
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
	public class Placemark extends Feature
	{
		/**
		 *
		 */
		public function Placemark(xml:XML)
		{
			super(xml);
			this.mapElement("Point", "point");
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get point():Point
		{
			return this.getValueFor("point");
		}

	}
	
}