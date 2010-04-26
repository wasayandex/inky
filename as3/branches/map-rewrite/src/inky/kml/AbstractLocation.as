package inky.kml 
{
	import inky.kml.Geometry;
	import inky.kml.kml;
	
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
	public class AbstractLocation extends Geometry
	{
		/**
		 *
		 */
		public function AbstractLocation(xml:XML)
		{
			super(xml);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get coordinates():Array
		{
			var coordinates:Array;
			var coordsList:XMLList = this.xml.kml::coordinates;
			for each (var coords:XML in coordsList)
			{
				if (coords.toString().length < 5)
					continue;

				if (!coordinates)
					coordinates = [];

				coordinates.push(new Coordinates(coords));
			}

			return coordinates;
		}

		
	}
	
}