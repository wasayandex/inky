package inky.components.map.view 
{
	import inky.components.map.view.IMap;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.19
	 *
	 */
	public interface IInteractiveMap extends IMap
	{
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * TODO: Doc this.
		 */
		function showPlacemark(placemark:Object):void;

	}
	
}