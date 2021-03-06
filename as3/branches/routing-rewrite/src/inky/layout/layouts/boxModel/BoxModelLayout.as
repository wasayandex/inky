package inky.layout
{
	import inky.layout.BaseLayoutManager;
	import inky.layout.Layout;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import inky.collections.IIterator;
	import inky.collections.IList;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import inky.layout.BoxModelLayoutPosition;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.27
	 *
	 */
	public class BoxModelLayout extends BaseLayoutManager
	{



		/**
		 *
		 * 
		 *
		 */
		public function BoxModelLayout()
		{
		}



		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		override public function calculateLayout(container:DisplayObjectContainer):Layout
		{
			var layout:Layout = new Layout();
			var layoutItems:IList = this.getLayoutItems(container);
			var containerBounds:Rectangle = container.getBounds(container);

			for (var i:IIterator = layoutItems.iterator(); i.hasNext(); )
			{
				var layoutItem:DisplayObject = i.next() as DisplayObject;
				var constraints:BoxModelLayoutConstraints = this.getConstraints(layoutItem) as BoxModelLayoutConstraints;
				var bounds:Rectangle;

				if (constraints)
				{
					switch (constraints.position)
					{
// TODO: Calculate relative to first box model ancestor.
						case BoxModelLayoutPosition.ABSOLUTE:
						{
							bounds = this._getAbsoluteBounds(layoutItem, container, containerBounds, constraints);
							break;
						}
						case BoxModelLayoutPosition.STATIC:
						{

						}
						default:
						{
							throw new Error();
						}
					}
				}
				else
				{
					bounds = layoutItem.getBounds(container);
				}
	
				layout.addItem(layoutItem.name, bounds);
			}
			
			return layout;
		}



		private function _getStaticBounds():Rectangle
		{
			// if layoutItem display is block
			//    y = current row y value + currentrow height.
			//    x = 0;
			//    increment current row
			// if layoutItem display is inline
			//    y = current row y value
			//    x = last item right value.
			return null;
		}


		private function _getAbsoluteBounds(layoutItem:DisplayObject, container:DisplayObjectContainer, containerBounds:Rectangle, constraints:BoxModelLayoutConstraints):Rectangle
		{
			var bounds:Rectangle = layoutItem.getBounds(container);
			
			if (!isNaN(constraints.top))
			{
				bounds.y = constraints.top;
			}
			else if (!isNaN(constraints.bottom))
			{
				bounds.y = containerBounds.bottom - layoutItem.getBounds(container).height;
			}
			
			if (!isNaN(constraints.left))
			{
				bounds.x = constraints.left;
			}
			else if (!isNaN(constraints.right))
			{
				bounds.x = containerBounds.right - layoutItem.getBounds(container).width;
			}
			
			return bounds;
		}



	}
}