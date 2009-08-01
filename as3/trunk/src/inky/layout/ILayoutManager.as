package inky.layout 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.07.31
	 *
	 */
	public interface ILayoutManager
	{
		
		/*function get renderer():ILayoutRenderer;
		function set renderer(renderer:ILayoutRenderer):void;
		
		function addLayoutItem(item:DisplayObject):void;
		function calculateLayout(container:DisplayObjectContainer):Layout;
		function invalidate(container:DisplayObjectContainer):void;*/
		function layoutContainer(container:DisplayObjectContainer):void;
		/*function register(container:DisplayObjectContainer):void;
		function removeLayoutItem(item:DisplayObject):DisplayObject;
		function unregister(container:DisplayObjectContainer):void;
		function validateNow(container:DisplayObjectContainer):void;*/

		
	}
	
}