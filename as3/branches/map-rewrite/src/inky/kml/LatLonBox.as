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
	 *	@since  2010.04.26
	 *
	 */
	public class LatLonBox extends KMLObject
	{
		/**
		 *
		 */
		public function LatLonBox(xml:XML)
		{
			super(xml);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get east():Number
		{
			return this.getValueFor("east");
		}

		/**
		 * @inheritDoc
		 */
		public function get north():Number
		{
			return this.getValueFor("north");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get rotation():Number
		{
			return this.getValueFor("rotation");
		}

		/**
		 * @inheritDoc
		 */
		public function get south():Number
		{
			return this.getValueFor("south");
		}

		/**
		 * @inheritDoc
		 */
		public function get west():Number
		{
			return this.getValueFor("west");
		}

	}
	
}