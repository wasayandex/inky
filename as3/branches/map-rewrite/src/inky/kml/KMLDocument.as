package inky.kml 
{
	import inky.kml.KMLObject;
	import inky.kml.Feature;

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
	public class KMLDocument extends KMLObject
	{
		/**
		 *
		 */
		public function KMLDocument(xml:XML)
		{
			super(xml);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get rootFeature():Feature
		{
			return this.getFeatureFor(this.xml.children()[0]);
		}
	}
	
}