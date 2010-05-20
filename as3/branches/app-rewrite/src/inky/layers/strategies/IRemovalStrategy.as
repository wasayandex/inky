package inky.layers.strategies 
{
	import inky.layers.LayerStack;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	
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
	public interface IRemovalStrategy
	{
		/**
		 * 
		 */
		function get isInstantaneous():Boolean;
		
		
		/**
		 * 
		 */
		function remove(layer:DisplayObject, stack:LayerStack, dispatcher:IEventDispatcher = null):void;
		
	}
	
}