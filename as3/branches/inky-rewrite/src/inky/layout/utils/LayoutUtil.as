package inky.layout.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.Stage;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.08.04
	 *
	 */
	public class LayoutUtil
	{
// TODO: Rename to MeasurementUtil?
// TODO: actually try to use real maxSize, minSize, and preferredSize values (if display object implements some interface)
		public static function getMaximumSize(c:DisplayObject):Rectangle
		{
			return new Rectangle(0, 0, c.width, c.height);
		}

		public static function getMinimumSize(c:DisplayObject):Rectangle
		{
			return new Rectangle(0, 0, c.width, c.height);
		}

		public static function getPreferredSize(c:DisplayObject):Rectangle
		{
			return new Rectangle(0, 0, c.width, c.height);
		}


	}
}