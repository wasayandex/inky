package inky.display.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.InteractiveObject;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.01.25
	 *
	 */
	public class DragEvent extends MouseEvent
	{
		public static const DRAG:String = "drag";
		public static const PRE_DRAG:String = "preDrag";
		public static const START_DRAG:String = "startDrag";
		public static const STOP_DRAG:String = "stopDrag";

		public var deltaX:Number;
		public var deltaY:Number;




		/**
		 *  Constructor.
		 */
		public function DragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, deltaX:Number = NaN, deltaY:Number = NaN, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0)
		{
			this.deltaX = deltaX;
			this.deltaY = deltaY;
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new DragEvent(this.type, this.bubbles, this.cancelable, this.deltaX, this.deltaY, this.localX, this.localY, this.relatedObject, this.ctrlKey, this.altKey, this.shiftKey, this.buttonDown, this.delta);
		}


		/**
		 * 
		 */
		public static function createDragEvent(original:MouseEvent, type:String, deltaX:Number = NaN, deltaY:Number = NaN):DragEvent
		{
			return new DragEvent(type, false, true, deltaX, deltaY, original.localX, original.localY, original.relatedObject, original.ctrlKey, original.altKey, original.shiftKey, original.buttonDown, original.delta);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("DragEvent", "type", "bubbles", "cancelable");
		}




	}
}