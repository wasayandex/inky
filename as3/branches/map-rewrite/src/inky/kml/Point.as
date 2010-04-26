package inky.kml 
{
	import inky.kml.kml;
	import inky.kml.Coordinates;
	import inky.kml.AbstractLocation;
	
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
	public class Point extends AbstractLocation
	{
		/**
		 *
		 */
		public function Point(xml:XML)
		{
			super(xml);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function get altitude():Number
		{
			var value:Number;
			if (this.coordinates && this.coordinates.length)
				value = this.coordinates[0].altitude;
			return value;
		}

		/**
		 * 
		 */
		public function get latitude():Number
		{
			var value:Number;
			if (this.coordinates && this.coordinates.length)
				value = this.coordinates[0].latitude;
			return value;
		}

		/**
		 * 
		 */
		public function get longitude():Number
		{
			var value:Number;
			if (this.coordinates && this.coordinates.length)
				value = this.coordinates[0].longitude;
			return value;
		}

	}
	
}