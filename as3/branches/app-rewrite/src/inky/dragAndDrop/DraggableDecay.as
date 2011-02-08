package inky.dragAndDrop 
{
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.events.DragEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2011.02.07
	 *
	 */
	public class DraggableDecay
	{
		// The number of seconds to sample.
		private static const SAMPLE_SIZE:Number = 0.33;
		
		private static const DRAGGING:String = "dragging";
		private static const STARTING_friction:String = "startingfriction";
		private static const frictionING:String = "frictioning";
		private static const NONE:String = "none";

		private var _friction:Number = 0.1;		
		private var state:String;
		private var draggable:Draggable;
		private var xHistory:Array;
		private var yHistory:Array;
		private var sprite:DisplayObject;
		private var offset:Point;
		
		// The number of frames to sample. (Calculated from SAMPLE_SIZE)
		private var sampleSize:int;
		
		/**
		 *
		 */
		public function DraggableDecay(draggable:Draggable, sprite:DisplayObject)
		{
			this.sprite = sprite;
			this.offset = new Point();
			this.state = NONE;
			this.draggable = draggable;
			draggable.addEventListener(DragEvent.START_DRAG, this.draggable_startDragHandler);
			draggable.addEventListener(DragEvent.STOP_DRAG, this.draggable_stopDragHandler);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		

		/**
		 * The amount of friction applied to the decay effect (in percent per
		 * frame). If the friction is 1, there will be no decay effect. If the
		 * friction is 0, the sprite will never stop.
		 */
		public function get friction():Number { return this._friction; }
		/** @private */
		public function set friction(value:Number):void { this._friction = value; }


		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function draggable_startDragHandler(event:DragEvent):void
		{
			this.sampleSize = SAMPLE_SIZE * this.sprite.stage.frameRate;
			this.state = DRAGGING;
			this.xHistory = [];
			this.yHistory = [];
			this.sprite.addEventListener(Event.ENTER_FRAME, this.sprite_enterFrameHandler);
			this.sprite_enterFrameHandler();
		}
		
		/**
		 * 
		 */
		private function draggable_stopDragHandler(event:DragEvent):void
		{
			this.state = STARTING_friction;
		}
		
		/**
		 * 
		 */
		private function sprite_enterFrameHandler(event:Event = null):void
		{
			if (this.state == DRAGGING)
			{
				// Store dragging history.
				this.xHistory.push(this.sprite.stage.mouseX);
				this.yHistory.push(this.sprite.stage.mouseY);
				
				// Only keep SAMPLE_SIZE seconds worth of data.
				if (this.xHistory.length > this.sampleSize)
				{
					this.xHistory = this.xHistory.slice(-this.sampleSize);
					this.yHistory = this.yHistory.slice(-this.sampleSize);
				}
			}
			else if (this.state == STARTING_friction)
			{
				if (this.xHistory.length < 2)
				{
					// Not enough history to calculate anything!
					this.offset.x = 0;
					this.offset.y = 0;
				}
				else
				{
					// Calculate the offset by taking the average offset of the
					// last 1/3 second.
					var len:int = this.xHistory.length;
					var xSum:Number = 0;
					var ySum:Number = 0;
					for (var i:int = 1; i < len; i++)
					{
						xSum += this.xHistory[i] - this.xHistory[i - 1];
						ySum += this.yHistory[i] - this.yHistory[i - 1];
					}
					this.offset.x = xSum / (len - 1);
					this.offset.y = ySum / (len - 1);
				}
				
				// Change the state and reprocess the frame.
				this.state = frictionING;
				arguments.callee();
			}
			else if (this.state == frictionING)
			{
				this.offset.x *= 1 - this.friction;
				this.offset.y *= 1 - this.friction;
				var newX:Number = this.sprite.x + this.offset.x;
				var newY:Number = this.sprite.y + this.offset.y;

				if (this.draggable.bounds)
				{
					newX = Math.max(Math.min(newX, this.draggable.bounds.x + this.draggable.bounds.width), this.draggable.bounds.x);
					newY = Math.max(Math.min(newY, this.draggable.bounds.y + this.draggable.bounds.height), this.draggable.bounds.y);
				}
				
				var xDiff:Number = newX - this.sprite.x;
				var yDiff:Number = newY - this.sprite.y;
				if (xDiff < 0.3 && xDiff > -0.3)
					this.offset.x = 0;
				if (yDiff < 0.3 && yDiff > -0.3)
					this.offset.y = 0;

				this.sprite.x = newX;
				this.sprite.y = newY;

				if (this.offset.x == 0 && this.offset.y == 0)
				{
					this.state = NONE;
					this.sprite.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				}
			}
		}
		

	}
	
}