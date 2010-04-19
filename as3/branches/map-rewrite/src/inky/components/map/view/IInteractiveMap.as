package inky.components.map.view 
{
	import inky.components.map.view.IMap;
	import inky.components.tooltip.ITooltip;
	import flash.display.InteractiveObject;
	
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
		function get zoomInButton():InteractiveObject;
		function set zoomInButton(value:InteractiveObject):void;
		
		/**
		 * 
		 */
		function get zoomInterval():Number;
		function set zoomInterval(value:Number):void;
		
		/**
		 * 
		 */
		function get zoomOutButton():InteractiveObject;
		function set zoomOutButton(value:InteractiveObject):void;
		
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
		function scaleContent(scaleX:Number, scaleY:Number):void;
		
		/**
		 * 
		 */
		function showPlacemark(placemark:Object):void;

	}
	
}