package inky.kml 
{
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
	public class Container extends Feature
	{
		/**
		 *
		 */
		public function Container(xml:XML)
		{
			super(xml);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * TODO: doc
		 */
		public function get features():Array
		{
			var children:XMLList = this.xml.children();
			var features:Array = [];
			for each (var child:XML in children)
			{
				var feature:Feature = this.getFeatureFor(child);
				if (feature)
					features.push(feature);
			}
			return features;
		}

		
	}
	
}