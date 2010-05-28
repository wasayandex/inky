package inky.components.map.view.helpers 
{
	
	public class PanHelper
	{
		public static var draggable:Object;

		/**
		 * 
		 */
		public static function toHorizontalPan(x:Number):Number
		{
			if (!PanHelper.draggable)
				throw new Error("PanHelper has no draggable target.");

			return x / PanHelper.draggable.bounds.x;
		}

		/**
		 * 
		 */
		public static function toVerticalPan(y:Number):Number
		{
			if (!PanHelper.draggable)
				throw new Error("PanHelper has no draggable target.");

			return y / PanHelper.draggable.bounds.y;
		}

		/**
		 * 
		 */
		public static function toXPosition(horizontalPan:Number):Number
		{
			if (!PanHelper.draggable)
				throw new Error("PanHelper has no draggable target.");

			return horizontalPan * PanHelper.draggable.bounds.x;
		}

		/**
		 * 
		 */
		public static function toYPosition(verticalPan:Number):Number
		{
			if (!PanHelper.draggable)
				throw new Error("PanHelper has no draggable target.");

			return verticalPan * PanHelper.draggable.bounds.y;
		}

	}	
}
