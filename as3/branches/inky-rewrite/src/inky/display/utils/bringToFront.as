package inky.display.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * Brings a DisplayObject to the front within its parent.
	 *
	 * @param child
	 *     the DisplayObject to reposition
	 * 
	 * @author     matthew at exanimo dot com
	 * @author     Ryan Sprake
	 */
	public function bringToFront(child:DisplayObject):void
	{
		var parent:DisplayObjectContainer;
		if (!(parent = child.parent)) return;
		parent.setChildIndex(child, parent.numChildren - 1);
	}




}