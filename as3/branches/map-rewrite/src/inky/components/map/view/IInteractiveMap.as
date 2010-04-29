package inky.components.map.view 
{
	import inky.components.map.view.IMap;
	import inky.components.tooltip.ITooltip;
	import flash.display.InteractiveObject;
	import flash.display.DisplayObjectContainer;
	
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
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Gets and sets the x value for the map content container.
		 */
		function get contentX():Number;
		function set contentX(value:Number):void;
		
		/**
		 * Gets and sets the y value for the map content container.
		 */
		function get contentY():Number;
		function set contentY(value:Number):void;
		
		/**
		 * 
		 */
		function get maximumZoom():Number;
		function set maximumZoom(value:Number):void;
		
		/**
		 * 
		 */
		function get minimumZoom():Number;
		function set minimumZoom(value:Number):void;

		/**
		 * 
		 */
		function get tooltip():ITooltip;
		function set tooltip(value:ITooltip):void;

		/**
		 * 
		 */
		function get zoom():Number;
		function set zoom(value:Number):void;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * 
		 */
		function moveContent(x:Number, y:Number):void;
		
		/**
		 * 
		 */
		function showPlacemark(placemark:Object):void;

	}
	
}