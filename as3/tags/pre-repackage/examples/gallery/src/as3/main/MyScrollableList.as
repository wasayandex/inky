﻿package
{
	import inky.framework.collections.*;
	import caurina.transitions.Tweener;
	import inky.framework.components.listViews.scrollableList.ScrollableList;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 *
	 *	
	 */
	public class MyScrollableList extends ScrollableList
	{

		public function MyScrollableList()
		{
			this.spacing = 10;
		}


		
		/**
		 * @private
		 */
		override public function set model(model:IList):void
		{
			super.model = model;

			if (model)
				this["max" + (this.orientation == "horizontal" ? "Horizontal" : "Vertical") + "ScrollPosition"] = Math.max(0, model.length - 1);
		}



		/**
		 *
		 */
		override protected function moveContent(x:Number, y:Number):void
		{
			var contentContainer:DisplayObjectContainer = this.getContentContainer();
			Tweener.addTween(contentContainer, {x: x, y: y, time: 1, onUpdate: this.invalidate});
		}


		/**
		 * @inheritDoc
		 */
		override public function showItemAt(index:int):void
		{
			if ((index < 0) || (index >= this.model.length))
			{
				throw new RangeError("The supplied index " + index + " is out of bounds.");
			}

			this._setScrollPosition(index);
			var contentContainer:DisplayObjectContainer = this.getContentContainer();
			var mask:DisplayObject = this.getScrollMask();
			var widthOrHeight:String;
			var xOrY:String;
			if (this.orientation == "horizontal")
			{
				xOrY = "x";
				widthOrHeight = "width";
			}
			else
			{
				xOrY = "y";
				widthOrHeight = "height";
			}
			var newPos:Object = {x: contentContainer.x, y: contentContainer.y};

			if (!isNaN(index) && this.model)
			{
				var pos:Number = mask[xOrY] + mask[widthOrHeight] / 2 - this.getItemPosition(index) - this.getItemSize(index) / 2;
				var max:Number = 0;
				var min:Number = mask[xOrY] + mask[widthOrHeight] - this.getItemPosition(this.model.length - 1) - this.getItemSize(this.model.length - 1);
				newPos[xOrY] = Math.max(Math.min(pos, max), min);
			}

			this.moveContent(newPos.x, newPos.y);
			this.invalidate();
		}


		private function _setScrollPosition(index:int):void
		{
			var capProp:String = this.orientation == "horizontal" ? "Horizontal" : "Vertical";
			this[this.orientation + "ScrollPosition"] = Math.min(index, this["max" + capProp + "ScrollPosition"]);
		}




	}
}
