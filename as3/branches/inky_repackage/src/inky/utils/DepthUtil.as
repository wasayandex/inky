package inky.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	
	
	/**
	 *
	 * Utility functions for dealing with depth
	 *
	 * @author     matthew at exanimo dot com
	 * @author     Ryan Sprake
	 *
	 */	
	public class DepthUtil
	{
		/**
		 * @private
		 */
		public function DepthUtil()
		{
			throw new Error('DepthUtil contains static utility methods and cannot be instantialized.');
		}


		/**
		 *
		 * Brings a DisplayObject to the front within its parent.
		 *
		 * @param child
		 *     the DisplayObject to reposition
		 *
		 */
		public static function bringToFront(child:DisplayObject):void
		{
			var parent:DisplayObjectContainer;
			if (!(parent = child.parent)) return;
			parent.setChildIndex(child, parent.numChildren - 1);
		}


		/**
		 *
		 * Sends a DisplayObject to the back within its parent.
		 *
		 * @param child
		 *     the DisplayObject to reposition
		 *
		 */
		public static function sendToBack(child:DisplayObject):void
		{
			var parent:DisplayObjectContainer;
			if (!(parent = child.parent)) return;
			parent.setChildIndex(child, 0);
		}




	}
}