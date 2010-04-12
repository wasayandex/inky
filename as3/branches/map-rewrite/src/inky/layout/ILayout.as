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
	public interface ILayout
	{
		/**
		 *	
		 */
		function layoutContainer(container:DisplayObjectContainer, clients:Array = null):void;
	
	}
}