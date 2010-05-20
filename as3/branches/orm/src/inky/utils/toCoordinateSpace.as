package inky.utils 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 *
	 *  Converts a point from one coordinate space to another.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.10
	 *
	 */
	public function toCoordinateSpace(point:Point, source:DisplayObject, target:DisplayObject):Point
	{
		if (source == target)
			return point.clone();
		else
			return target.globalToLocal(source.localToGlobal(point));
	}
	
}
