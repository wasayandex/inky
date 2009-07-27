package inky.layout
{
	import inky.layout.Layout;
	import inky.layout.ILayoutRenderer;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;


	/**
	 *
	 * LayoutManager.as
	 *
	 *     ..
	 *	
	 *     @langversion ActionScript 3
	 *     @playerversion Flash 9.0.0
	 *
	 *     @author     Matthew Tretter (matthew@exanimo.com)
	 *     @version    2008.03.18
	 *
	 */
	public interface ILayoutManager extends IEventDispatcher
	{
		function get renderer():ILayoutRenderer;
		function set renderer(renderer:ILayoutRenderer):void;
		
		function addLayoutItem(item:DisplayObject):void;
		function calculateLayout(container:DisplayObjectContainer):Layout;
		function invalidate(container:DisplayObjectContainer):void;
		function layoutContainer(container:DisplayObjectContainer):void;
		function register(container:DisplayObjectContainer):void;
		function removeLayoutItem(item:DisplayObject):DisplayObject;
		function unregister(container:DisplayObjectContainer):void;
		function validateNow(container:DisplayObjectContainer):void;
	}
}
