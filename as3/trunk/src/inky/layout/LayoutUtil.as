package inky.layout 
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;


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