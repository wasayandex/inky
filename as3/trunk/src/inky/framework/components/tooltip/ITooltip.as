package inky.framework.components.tooltip

{
	import flash.display.InteractiveObject;


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
	public interface ITooltip
	{
		function set target(target:InteractiveObject):void;
		function hide():void;
		function show():void;
	}
}