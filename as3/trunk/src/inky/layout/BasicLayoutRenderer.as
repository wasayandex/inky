package inky.layout
{
	import inky.layout.ILayoutRenderer;
	import inky.layout.Layout;
	import inky.layout.events.LayoutRendererEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;


	/**
	 *
	 *
	 *
	 */
	public class BasicLayoutRenderer extends EventDispatcher implements ILayoutRenderer
	{
		//
		// public methods
		//


		/**
		 *
		 *
		 *
		 */
		public function drawLayout(layout:Layout, container:DisplayObjectContainer):void
		{
			this.drawLayoutNow(layout, container);
			this.dispatchEvent(new LayoutRendererEvent(LayoutRendererEvent.UPDATE, false, false, container));
			this.dispatchEvent(new LayoutRendererEvent(LayoutRendererEvent.FINISH, false, false, container));
		}


		/**
		 *
		 *
		 *
		 */
		public function move(child:DisplayObject, x:Number, y:Number):void
		{
			if (!isNaN(x))
			{
				child.x = x;
			}
			if (!isNaN(y))
			{
				child.y = y;
			}
		}


		/**
		 *
		 *
		 *
		 */
		public function setSize(child:DisplayObject, width:Number, height:Number):void
		{
			if (!isNaN(width))
			{
				child.width = width;
			}
			if (!isNaN(height))
			{
				child.height = height;
			}
		}




		//
		// protected methods
		//


		/**
		 *
		 *
		 *
		 */
		protected function drawLayoutNow(layout:Layout, container:DisplayObjectContainer):void
		{
			if (!layout) return;

			var bounds:Rectangle;
			var id:String;
			var child:DisplayObject;
			var newDepth:uint;
			var usableIndexes:Array;
			var i:uint;

			// This container may contain children that aren't part of the
			// layout. We don't want to reorder them, so we'll make a list of
			// usable indexes and only sort within them. In case the container
			// has two children of the same name (only the first will be layed
			// out), we'll keep track of which names we've found.
			if (layout.length != container.numChildren)
			{
				usableIndexes = [];
				var isFound:Object = {};

				for (i = 0; i < container.numChildren; i++)
				{
					child = container.getChildAt(i);
					if (layout.containsId(child.name) && !isFound[child.name])
					{
						usableIndexes.push(i);
						isFound[child.name] = true;
					}
					if (usableIndexes.length == layout.length) break;
				}
			}

			for (i = 0; i < layout.length; i++)
			{
				bounds = layout.getItemAt(i);
				id = layout.getItemId(i);
				if (!bounds)
					throw new Error("No bounds set for " + id + ". Probably an error in your layout manager.");
				child = container.getChildByName(id);
				newDepth = usableIndexes ? usableIndexes[i] : i;

				// Make sure the depth is correct.
				var index:uint = container.getChildIndex(child);
				if (index != newDepth)
				{
					container.swapChildrenAt(index, newDepth);
				}

				this.move(child, bounds.x, bounds.y);
				this.setSize(child, bounds.width, bounds.height);
			}
		}




	}
}
