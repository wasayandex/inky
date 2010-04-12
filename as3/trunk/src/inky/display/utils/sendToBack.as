package inky.display.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * Sends a DisplayObject to the back within its parent.
	 *
	 * @param child
	 *     the DisplayObject to reposition
	 * 
	 * @author     matthew at exanimo dot com
	 * @author     Ryan Sprake
	 */
	public function sendToBack(child:DisplayObject):void
	{
		var parent:DisplayObjectContainer;
		if (!(parent = child.parent)) return;
		parent.setChildIndex(child, 0);
	}




}