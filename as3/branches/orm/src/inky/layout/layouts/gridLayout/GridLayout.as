package inky.layout.layouts.gridLayout
{
	import inky.layout.layouts.gridLayout.Alignment;
	import inky.layout.layouts.gridLayout.GridLayoutConstraints;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import inky.layout.ILayout;
	import inky.layout.layouts.AbstractConstrainedLayout;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.07.31
	 *
	 */
	public class GridLayout extends AbstractConstrainedLayout implements ILayout
	{
		private var _columnWidths:Array;
		private var _horizontalSpacing:Number;
		private var _numColumns:uint;
		private var _numRows:uint;
		private var _rowHeights:Array;
		private var _verticalSpacing:Number;
		private var _x:Number;
		private var _y:Number;

		/**
		 *
		 * Creates a new Grid.
		 *
		 * @param numColumns
		 *     (optional) the number of columns the Grid should contain
		 * @param numRows
		 *     (optional) the number of rows the Grid should contain
		 * @param horizontalSpacing
		 *     (optional) the number of pixels between each column
		 * @param verticalSpacing
		 *     (optional) the number of pixels between each row
		 *
		 */
		public function GridLayout(numColumns:uint = uint.MAX_VALUE, numRows:uint = uint.MAX_VALUE, horizontalSpacing:Number = 0, verticalSpacing:Number = 0)
		{
			this._x =
			this._y = 0;
			this.numColumns = numColumns;
			this.numRows = numRows;
			this.horizontalSpacing = horizontalSpacing;
			this.verticalSpacing = verticalSpacing;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get columnWidths():Array
		{
			return this._columnWidths;
		}
		/**
		 * @private
		 */
		public function set columnWidths(columnWidths:Array):void
		{
			this._columnWidths = columnWidths;
		}

		/**
		 *
		 */
		public function get horizontalSpacing():Number
		{
			return this._horizontalSpacing;
		}
		/**
		 * @private
		 */
		public function set horizontalSpacing(horizontalSpacing:Number):void
		{
			this._horizontalSpacing = horizontalSpacing;
		}

		/**
		 *
		 */
		public function get numColumns():uint
		{
			return this._numColumns;
		}
		/**
		 * @private
		 */
		public function set numColumns(numColumns:uint):void
		{
			this._numColumns = numColumns;
		}

		/**
		 *
		 */
		public function get numRows():uint
		{
			return this._numRows;
		}
		/**
		 * @private
		 */
		public function set numRows(numRows:uint):void
		{
			this._numRows = numRows;
		}

		/**
		 *
		 */
		public function get rowHeights():Array
		{
			return this._rowHeights;
		}
		/**
		 * @private
		 */
		public function set rowHeights(rowHeights:Array):void
		{
			this._rowHeights = rowHeights;
		}

		/**
		 *
		 */
		public function get verticalSpacing():Number
		{
			return this._verticalSpacing;
		}
		/**
		 * @private
		 */
		public function set verticalSpacing(verticalSpacing:Number):void
		{
			this._verticalSpacing = verticalSpacing;
		}

		/**
		 *
		 */
		public function get x():Number
		{ 
			return this._x; 
		}
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			this._x = value;
		}

		/**
		 *
		 */
		public function get y():Number
		{ 
			return this._y; 
		}
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			this._y = value;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *	@inheritDoc
		 */
		override public function layoutContainer(container:DisplayObjectContainer, layoutItems:Array = null):void
		{
			var bounds:Rectangle;
			var child:DisplayObject;
			var childrenToPlaceRelatively:Array = [];
			var columnWidths:Array = [];
			var constraints:GridLayoutConstraints;
			var elements:Array = [];
			var firstOpenPosition:uint = 0;
			var i:uint;
			var j:uint;
			var k:uint;
			var p:uint;

			// If no layout items are provided, lay out all the container's children.
			if (!layoutItems)
			{
				layoutItems = [];
				for (i = 0; i < container.numChildren; i++)
				{
					layoutItems.push(container.getChildAt(i));
				}
			}

			var numRows:uint = this.numColumns == uint.MAX_VALUE ? 1 : this.numRows == uint.MAX_VALUE ? Math.ceil(layoutItems.length / this.numColumns) : this.numRows;
			var numColumns: uint = this.numColumns == uint.MAX_VALUE ? layoutItems.length : this.numColumns;
			var rowHeights:Array = [];
			var x:Number = this.x;
			var y:Number = this.y;

			// Sort the children so that GridLayoutConstraints are obeyed.

			for (i = 0; i < layoutItems.length; i++)
			{
				child = layoutItems[i] as DisplayObject;
				constraints = this.getConstraints(child) as GridLayoutConstraints;

				if (constraints)
				{
					if ((constraints.gridX >= this.numColumns) || (constraints.gridY >= this.numRows))
					{
						throw new RangeError('The supplied constraints place the DisplayObject outside of the GridLayout.');
					}
// TODO: Throw errors if: only one of gridX or gridY is -1.
// TODO: Throw errors if: gridX or gridY is < -1.
					else if (constraints.gridX == -1 || constraints.gridY == -1)
					{
						childrenToPlaceRelatively.push(child);
					}
					else
					{
						p = numColumns * constraints.gridY + constraints.gridX;
						elements[p] = elements[p] || [];
						elements[p].push(child);
					}
				}
				else
				{
					childrenToPlaceRelatively.push(child);
				}
			}

			while (childrenToPlaceRelatively.length)
			{
				while (elements[firstOpenPosition])
				{
					firstOpenPosition++;
				}
				elements[firstOpenPosition] = elements[firstOpenPosition] || [];
				elements[firstOpenPosition].push(childrenToPlaceRelatively.shift());
			}

			// If the column widths or row heights haven't been set, figure them
			// out.

			if (!this.columnWidths || !this.rowHeights)
			{
				for (i = 0; i < elements.length; i++)
				{
					j = i % numColumns;
					k = Math.floor(i / numColumns);

					columnWidths[j] = this.columnWidths ? this.columnWidths[j % this.columnWidths.length] : columnWidths[j] || 0;
					rowHeights[k] = this.rowHeights ? this.rowHeights[k % this.rowHeights.length] : rowHeights[k] || 0;

					for (p = 0; elements[i] && (p < elements[i].length); p++)
					{
						child = elements[i][p];

						if (!this.columnWidths)
						{
							columnWidths[j] = child ? Math.max(columnWidths[j], child.width) : columnWidths[j];
						}

						if (!this.rowHeights)
						{
							rowHeights[k] = child ? Math.max(rowHeights[k], child.height) : rowHeights[k];
						}
					}
				}
			}

			// Arrange the children.

			for (i = 0; i < elements.length; i++)
			{
				j = i % numColumns;
				k = Math.floor(i / numColumns);

				x = !j ? 0: x + columnWidths[(j - 1) % columnWidths.length] + this.horizontalSpacing;
				y = !j && k ? y + rowHeights[(k - 1) % rowHeights.length] + this.verticalSpacing : y;

				for (p = 0; elements[i] && (p < elements[i].length); p++)
				{
					child = elements[i][p];

					if (child)
					{
						bounds = child.getBounds(child);

						// Adjust the positioning based on alignment.

						constraints = this.getConstraints(child) as GridLayoutConstraints;
						var xOffset:Number = 0;
						var yOffset:Number = 0;

						if (constraints)
						{
							switch (constraints.horizontalAlignment)
							{
								case Alignment.RIGHT:
									xOffset = columnWidths[j % columnWidths.length] - bounds.width;
									break;
								case Alignment.CENTER:
									xOffset = (columnWidths[j % columnWidths.length] - bounds.width) / 2;
									break;
								case Alignment.LEFT:
								default:
									break;
							}

							switch (constraints.verticalAlignment)
							{
								case Alignment.BOTTOM:
									yOffset = rowHeights[k % rowHeights.length] - bounds.height;
									break;
								case Alignment.CENTER:
									yOffset = (rowHeights[k % rowHeights.length] - bounds.height) / 2;
									break;
								case Alignment.TOP:
								default:
									break;
							}
						}

/*						// Get the object's bounds so that our positioning isn't
						// affected by the registration point. Set the width
						// and height to NaN, because they should remain
						// unchanged.
						bounds.x = x - bounds.x + xOffset;
						bounds.y = y - bounds.y + yOffset;
						bounds.width =
						bounds.height = NaN;*/

						child.x = x;
						child.y = y;
					}
				}
			}
		}

	}
}