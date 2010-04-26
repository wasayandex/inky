package inky.kml 
{
	import inky.kml.Feature;
	import inky.kml.Icon;
	
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
	public class Overlay extends Feature
	{
		/**
		 *
		 */
		public function Overlay(xml:XML)
		{
			super(xml);
			this.mapElement("Icon", "icon");
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get icon():Icon
		{
			return this.getValueFor("icon");
		}

	}
	
}