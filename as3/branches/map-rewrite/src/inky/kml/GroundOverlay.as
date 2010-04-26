package inky.kml 
{
	import inky.kml.Overlay;
	import inky.kml.LatLonBox;
	
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
	public class GroundOverlay extends Overlay
	{
		/**
		 *
		 */
		public function GroundOverlay(xml:XML)
		{
			super(xml);
			this.mapElement("LatLonBox", "latLonBox");
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get latLonBox():LatLonBox
		{
			return this.getValueFor("latLonBox");
		}

	}
	
}