package
{
	import inky.components.map.view.InteractiveMap;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Exponential;
	import PlacemarkRenderer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.30
	 *
	 */
	public class Map extends InteractiveMap
	{

		/**
		 *
		 */
		public function Map()
		{
			this.placemarkRendererClass = PlacemarkRenderer;
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function validate():void
		{
			// Add some easing to the zooming.
			if (!this.settings.zoomingProxy)
				this.settings.zoomingProxy = new GTween(this.settings, 3, null, {ease: Exponential.easeOut}).proxy;

			super.validate();
		}
		
	}
	
}