package inky.layers 
{
	import inky.layers.LayerStack;
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
	public interface ILayerDefinition extends IEventDispatcher
	{
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * 
		 */
		function get addIsInstantaneous():Boolean;

		/**
		 * 
		 */
		function get forceRefresh():Boolean;
		/**
		 * @private
		 */
		function set forceRefresh(value:Boolean):void;

		/**
		 * 
		 */
		function get onAddComplete():Function;
		/**
		 * @private
		 */
		function set onAddComplete(value:Function):void;
		
		/**
		 * 
		 */
		function get onBeforeAdd():Function;
		/**
		 * @private
		 */
		function set onBeforeAdd(value:Function):void;
		
		/**
		 * 
		 */
		function get onBeforeRemove():Function;
		/**
		 * @private
		 */
		function set onBeforeRemove(value:Function):void;

		/**
		 * 
		 */
		function get onRemoveComplete():Function;
		/**
		 * @private
		 */
		function set onRemoveComplete(value:Function):void;
		
		/**
		 * 
		 */
		function get removeIsInstantaneous():Boolean;

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
		function clone():ILayerDefinition;
		
		/**
		 * 
		 */
		function replaces(layer:Object):Boolean;
		
		/**
		 * 
		 */
		function removeFrom(stack:LayerStack):void;
	}
	
}