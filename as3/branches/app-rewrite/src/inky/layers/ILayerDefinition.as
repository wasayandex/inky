package inky.layers 
{
	import inky.layers.LayerStack;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.12
	 *
	 */
	public interface ILayerDefinition
	{
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * 
		 */
		function get forceRefresh():Boolean;
		/**
		 * @private
		 */
		function set forceRefresh(value:Boolean):void;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		function addTo(stack:LayerStack):void;
		
		/**
		 * 
		 */
		function removeFrom(stack:LayerStack):void;
	}
	
}