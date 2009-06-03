package inky.framework.components.tooltip

{
	import flash.display.InteractiveObject;
	import inky.framework.display.IDisplayObject;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Zack Dolin
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2008.01.14
	 *
	 */
	public interface ITooltip extends IDisplayObject
	{
		function set target(target:InteractiveObject):void;
		function hide():void;
		function show():void;
	}
}