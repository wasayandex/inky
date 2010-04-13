package inky.layers.strategies 
{
	import flash.display.DisplayObject;
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
	public interface IAdditionStrategy
	{
		
		/**
		 * 
		 */
		function add(layer:DisplayObject, stack:LayerStack):void;
		
	}
	
}