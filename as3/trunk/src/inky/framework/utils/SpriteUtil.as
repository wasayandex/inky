/**
 *
 * SpriteUtil.as
 *
 *     todo:
 *         - startDrag
 *             - add support for lockCenter
 *
 *     @author     matthew at exanimo dot com
 *     @author     Ryan Sprake
 *     @version    2007.11.05
 *
 */
package inky.framework.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	
	
	public class SpriteUtil
	{
		/**
		 *
		 *	
		 */
		public function SpriteUtil()
		{
			throw new Error('SpriteUtil contains static utility methods and cannot be instantialized.');
		}




		/////////////////////////////////////////////////////////////////////////////
		//
		// drag and drop functions: startDrag, stopDrag
		//
		/////////////////////////////////////////////////////////////////////////////


		private static var _dragSprite:DisplayObject;
		private static var _dragBounds:Rectangle;
		private static var _clickOffset:Point;
		
		
		/**
		 *
		 * Starts dragging a Sprite. Works like <Sprite>.startDrag but doesn't cause
		 * the sprite to be snapped to the nearest pixel.
		 *
		 * @param sprite:DisplayObject
		 *     the Sprite to drag
		 * @param lockCenter:Boolean
		 *     Specifies whether the draggable sprite is locked to the center
		 *     of the mouse position (true), or locked to the point where the
		 *     user first clicked the sprite (false).
		 * @param bounds:Rectangle
		 *     Value relative to the coordinates of the Sprite's parent that
		 *     specify a constraint rectangle for the Sprite.
		 *
		 */
		public static function startDrag(sprite:DisplayObject, lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			SpriteUtil.stopDrag(SpriteUtil._dragSprite);
			if (sprite)
			{
				sprite.addEventListener(Event.ENTER_FRAME, SpriteUtil._updateDrag);
				SpriteUtil._clickOffset = new Point(sprite.parent.mouseX - sprite.x, sprite.parent.mouseY - sprite.y);
				SpriteUtil._dragSprite = sprite;
				SpriteUtil._dragBounds = bounds;
			}
		}
		
		
		/**
		 *
		 * Stops a Sprite from following the cursor.
		 *
		 * @param sprite:DisplayObject
		 *     the Sprite that was following the cursor.
		 *
		 */
		public static function stopDrag(sprite:DisplayObject = null):void
		{
			if (sprite)
			{
				sprite.removeEventListener(Event.ENTER_FRAME, SpriteUtil._updateDrag);
				SpriteUtil._dragSprite = null;
			}
		}
		
		
		/**
		 *
		 * Called each frame to update the position of the item being dragged.
		 *
		 */
		private static function _updateDrag(e:Event = null):void
		{
			var parent:DisplayObject = SpriteUtil._dragSprite.parent;

			var x:Number = parent.mouseX - SpriteUtil._clickOffset.x;
			var y:Number = parent.mouseY - SpriteUtil._clickOffset.y;
			
			if (SpriteUtil._dragBounds)
			{
				x = Math.max(Math.min(x, SpriteUtil._dragBounds.x + SpriteUtil._dragBounds.width), SpriteUtil._dragBounds.x);
				y = Math.max(Math.min(y, SpriteUtil._dragBounds.y + SpriteUtil._dragBounds.height), SpriteUtil._dragBounds.y);
			}
			
			SpriteUtil._dragSprite.x = x;
			SpriteUtil._dragSprite.y = y;
		}




	}
}