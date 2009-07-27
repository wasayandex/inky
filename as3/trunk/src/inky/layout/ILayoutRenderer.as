package inky.layout
{
	import inky.layout.Layout;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	public interface ILayoutRenderer extends IEventDispatcher
	{
	
		function drawLayout(layout:Layout, container:DisplayObjectContainer):void;
		
	}
	
	
	
}
