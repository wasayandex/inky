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
	public function scale(sprite:Object, scale:Object, registrationPoint:Point = null):void
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
		
		// The registration point in the parent's coordiante space.
		var oldLocation:Point = new Point(sprite.x + sprite.scaleX * registrationPoint.x, sprite.y + sprite.scaleY * registrationPoint.y);
		
		// The registration point in the parent's coordiante space, after the transformation.
		var newLocation:Point = new Point(sprite.x + scaleX * registrationPoint.x, sprite.y + scaleY * registrationPoint.y);

		if (sprite.rotation != 0)
		{
			Helper.rotate(oldLocation, sprite.rotation);
			Helper.rotate(newLocation, sprite.rotation);
		}

		sprite.scaleX = scaleX;
		sprite.scaleY = scaleY;
		
		sprite.x -= newLocation.x - oldLocation.x;
		sprite.y -= newLocation.y - oldLocation.y;
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