package inky.components.map.view 
{
	import inky.components.map.view.BaseMap;
	import inky.components.map.controller.MapController;
	
	/**
	 *
	 *  A basic implementation of IMap. This implementation is based on 
	 * 	BaseMap, but creates its own map controller for convenience. 
	 *  For more explicit control over the map controller, including 
	 *  when it is created and how it is implemented, use BaseMap instead.
	 * 
	 *  @see inky.components.map.view.IMap
	 * 	@see inky.components.map.view.BaseMap
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public class Map extends BaseMap
	{
		private var controller:MapController;

		/**
		 * Creates a new Map.
		 */
		public function Map()
		{
			this.controller = new MapController(this);
		}
		

		
	}
	
}