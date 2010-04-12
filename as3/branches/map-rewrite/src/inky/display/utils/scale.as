package inky.display.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.01.28
	 *
	 */
	public function scale(sprite:Object, scale:Object, registrationPoint:Point = null, propertyMap:Object = null):void
	{
		var scaleX:Number;
		var scaleY:Number;

		if (scale is Number)
		{
			scaleX = scaleY = scale as Number;
		}
		else if (scale is Array)
		{
			scaleX = scale[0];
			scaleY = scale[1];
		}
		else if (scale == null)
		{
			throw new ArgumentError();
		}
		else
		{
			scaleX = scale.x;
			scaleY = scale.y;
		}

		registrationPoint = registrationPoint || new Point();
		
		propertyMap = propertyMap || {};
		propertyMap.x = propertyMap.x || "x";
		propertyMap.y = propertyMap.y || "y";
		propertyMap.scaleX = propertyMap.scaleX || "scaleX";
		propertyMap.scaleY = propertyMap.scaleY || "scaleY";
		propertyMap.rotation = propertyMap.rotation || "rotation";

		// The registration point in the parent's coordiante space.
		var oldLocation:Point = new Point(sprite[propertyMap.x] + sprite[propertyMap.scaleX] * registrationPoint.x, sprite[propertyMap.y] + sprite[propertyMap.scaleY] * registrationPoint.y);
		
		// The registration point in the parent's coordiante space, after the transformation.
		var newLocation:Point = new Point(sprite[propertyMap.x] + scaleX * registrationPoint.x, sprite[propertyMap.y] + scaleY * registrationPoint.y);

		if (sprite[propertyMap.rotation] != 0)
		{
			Helper.rotate(oldLocation, sprite[propertyMap.rotation]);
			Helper.rotate(newLocation, sprite[propertyMap.rotation]);
		}

		sprite[propertyMap.scaleX] = scaleX;
		sprite[propertyMap.scaleY] = scaleY;

		sprite[propertyMap.x] -= newLocation.x - oldLocation.x;
		sprite[propertyMap.y] -= newLocation.y - oldLocation.y;
	}



	
}




import flash.geom.Point;
class Helper {
	internal static function rotate(p:Point, r:Number):void
	{
		r *= Math.PI / 180;
		var cos:Number = Math.cos(r);
		var sin:Number = Math.sin(r);
		var oldX:Number = p.x;
		var oldY:Number = p.y;
		p.x = oldX * cos - oldY * sin;
		p.y = oldX * sin + oldY * cos;
	}
}