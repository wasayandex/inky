package inky.kml 
{
	import inky.kml.KMLObject;
	
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
	public class Coordinates extends KMLObject
	{
		
		/**
		 *
		 */
		public function Coordinates(xml:XML)
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
			return this.xml.toString().split(",")[2];
		}
		
		/**
		 * 
		 */
		public function get latitude():Number
		{
			return this.xml.toString().split(",")[1];
		}
		
		/**
		 * 
		 */
		public function get longitude():Number
		{
			return this.xml.toString().split(",")[0];
		}

	}
	
}