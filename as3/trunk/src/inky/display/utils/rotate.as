package inky.display.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import fl.motion.MatrixTransformer;
	import flash.geom.Rectangle;
	
	/**
	 *
	 *  @param pivot The coordinates of the pivot point in the coordinate space of the sprite.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.01.28
	 *
	 */
	public function rotate(sprite:DisplayObject, rotation:Number, pivot:Point = null):void
	{
		if (isNaN(rotation))
			throw new ArgumentError();
		if (!sprite)
			throw new ArgumentError();
		if (!sprite.parent)
			throw new ArgumentError();

		pivot = pivot || new Point();
		var pivotRelativeToParent:Point = sprite.parent.globalToLocal(sprite.localToGlobal(pivot));
		var matrix:Matrix = new Matrix(sprite.scaleX, 0, 0, sprite.scaleY, pivotRelativeToParent.x - pivot.x * sprite.scaleX, pivotRelativeToParent.y - pivot.y * sprite.scaleY);
		MatrixTransformer.rotateAroundExternalPoint(matrix, pivotRelativeToParent.x, pivotRelativeToParent.y, rotation);
		sprite.transform.matrix = matrix;
	}


	
}