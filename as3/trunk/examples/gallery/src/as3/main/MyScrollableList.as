package
{
	import inky.framework.collections.*;
	import caurina.transitions.Tweener;
	import inky.framework.components.listViews.scrollableList.ScrollableList;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;


	/**
	 *
	 *	
	 */
	public class MyScrollableList extends ScrollableList
	{

		public function MyScrollableList()
		{
//			this.spacing = 10;
		}




		
		/**
		 * @private
		 */
		override public function set model(model:IList):void
		{
			super.model = model;

/*if (model && model.length)
this.maxHorizontalScrollPosition = model.length - 1;
trace('..........' + this.maxHorizontalScrollPosition)*/
		}



		/**
		 *
		 */
		override protected function moveContent(x:Number, y:Number):void
		{
			var contentContainer:DisplayObjectContainer = this.getContentContainer();
			Tweener.addTween(contentContainer, {x: x, y: y, time: 3, onUpdate: this.updateContent});
		}


		/*
		 *
		 *
		override public function scrollTo(index:int):void
		{
			if ((index < 0) || (index >= this.model.length))
			{
				throw new RangeError();
			}

			var contentContainer:DisplayObjectContainer = this.getContentContainer();
			var newPos:Object = {x: contentContainer.x, y: contentContainer.y};
			var mask:DisplayObject = this.getScrollMask();

			if (!isNaN(index))
			{
				if (this.model != null)
				{
					var pos:Number = -this.getItemPosition(index);
					newPos[this.orientation == "horizontal" ? "x" : "y"] = pos;
				}
			}

			this.moveContent(newPos.x, newPos.y);
			this.updateContent();
		}


*/

	}
}
