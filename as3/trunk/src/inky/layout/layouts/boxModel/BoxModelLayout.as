package inky.layout.layouts.boxModel
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import inky.layout.ILayout;
	import inky.layout.layouts.AbstractConstrainedLayout;
	import inky.layout.layouts.boxModel.BoxModelLayoutConstraints;
	import inky.layout.layouts.boxModel.BoxModelLayoutPosition;


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
	public class BoxModelLayout extends AbstractConstrainedLayout implements ILayout
	{
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function layoutContainer(container:DisplayObjectContainer, clients:Array = null):void
		{
			if (!clients)
			{
				clients = [];
				for (var i:int = 0; i < container.numChildren; i++)
				{
					clients.push(container.getChildAt(i));
				}
			}
			
			var containerBounds:Rectangle = container.getBounds(container);
			var child:DisplayObject;

			for each (child in clients)
			{
				var constraints:BoxModelLayoutConstraints = this.getConstraints(child) as BoxModelLayoutConstraints;
				var bounds:Rectangle;

				if (constraints)
				{
					switch (constraints.position)
					{
// TODO: Calculate relative to first box model ancestor.
						case BoxModelLayoutPosition.ABSOLUTE:
						{
							bounds = this._getAbsoluteBounds(child, container, containerBounds, constraints);
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
					bounds = child.getBounds(container);
				}
	
				child.x = bounds.x;
				child.y = bounds.y;
			}
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