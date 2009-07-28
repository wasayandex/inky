package inky.layout
{
	import inky.collections.IList;
	import inky.layout.Alignment;
	import inky.layout.BaseLayoutManager;
	import inky.layout.GridLayoutConstraints;
	import inky.layout.Layout;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	/**
	 *
	 * GridLayout.as
	 *
	 *     Arranges DisplayObjects into a grid formation.
	 *
	 *     @langversion ActionScript 3
	 *     @playerversion Flash 9.0.0
	 *
	 *     @author     Eric Eldredge
	 *     @author     Matthew Tretter (matthew@exanimo.com)
	 *     @version    2007.10.01
	 *
	 */
	public class GridLayout extends BaseLayoutManager
	{
		private var _columnWidths:Array;
		private var _containers:Dictionary;
		private var _horizontalSpacing:Number;
		private var _numColumns:uint;
		private var _numRows:uint;
		private var _rowHeights:Array;
		private var _verticalSpacing:Number;




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
			this.numColumns = numColumns;
			this.numRows = numRows;
			this.horizontalSpacing = horizontalSpacing;
			this.verticalSpacing = verticalSpacing;
			this._containers = new Dictionary(true);
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get columnWidths():Array
		{
			return this._columnWidths;
		}


		/**
		 *
		 *
		 *
		 */
		public function set columnWidths(columnWidths:Array):void
		{
			this._columnWidths = columnWidths;
			this._invalidateAll();
		}


		/**
		 *
		 *
		 *
		 */
		public function get horizontalSpacing():Number
		{
			return this._horizontalSpacing;
		}


		/**
		 *
		 *
		 *
		 */
		public function set horizontalSpacing(horizontalSpacing:Number):void
		{
			this._horizontalSpacing = horizontalSpacing;
			this._invalidateAll();
		}


		/**
		 *
		 *
		 *
		 */
		public function get numColumns():uint
		{
			return this._numColumns;
		}


		/**
		 *
		 *
		 *
		 */
		public function set numColumns(numColumns:uint):void
		{
			this._numColumns = numColumns;
			this._invalidateAll();
		}


		/**
		 *
		 *
		 *
		 */
		public function get numRows():uint
		{
			return this._numRows;
		}


		/**
		 *
		 *
		 *
		 */
		public function set numRows(numRows:uint):void
		{
			this._numRows = numRows;
			this._invalidateAll();
		}


		/**
		 *
		 *
		 *
		 */
		public function get rowHeights():Array
		{
			return this._rowHeights;
		}


		/**
		 *
		 *
		 *
		 */
		public function set rowHeights(rowHeights:Array):void
		{
			this._rowHeights = rowHeights;
			this._invalidateAll();
		}


		/**
		 *
		 *
		 *
		 */
		public function get verticalSpacing():Number
		{
			return this._verticalSpacing;
		}


		/**
		 *
		 *
		 *
		 */
		public function set verticalSpacing(verticalSpacing:Number):void
		{
			this._verticalSpacing = verticalSpacing;
			this._invalidateAll();
		}




		//
		// public methods
		//


		/**
		 *
		 * Calculates the desired size and position of the supplied container's
		 * children.
		 *
		 * @param container
		 *     the container whose children you need layed out
		 *
		 * @return
		 *     a Layout object representing the desired size and position of
		 *     the specified container
		 *
		 * @throws RangeError
		 *     thrown if a child's constraints place it outside of the grid
		 *
		 */
		override public function calculateLayout(container:DisplayObjectContainer):Layout
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
			var layout:Layout = new Layout();
			var layoutItems:IList = this.getLayoutItems(container);
			var numRows:uint = this.numColumns == uint.MAX_VALUE ? 1 : this.numRows == uint.MAX_VALUE ? Math.ceil(layoutItems.length / this.numColumns) : this.numRows;
			var numColumns: uint = this.numColumns == uint.MAX_VALUE ? layoutItems.length : this.numColumns;
			var rowHeights:Array = [];
			var x:Number = 0;
			var y:Number = 0;

			// Sort the children so that GridLayoutConstraints are obeyed.

			for (i = 0; i < layoutItems.length; i++)
			{
				child = layoutItems.getItemAt(i) as DisplayObject;
				constraints = this.getConstraints(child);

				if (constraints)
				{
					if ((constraints.gridX >= this.numColumns) || (constraints.gridY >= this.numRows))
					{
						throw new RangeError('The supplied constraints place the DisplayObject outside of the GridLayout.');
					}
//TODO: Throw errors if: only one of gridX or gridY is -1.
//TODO: Throw errors if: gridX or gridY is < -1.
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

						constraints = this.getConstraints(child);
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

						// Get the object's bounds so that our positioning isn't
						// affected by the registration point. Set the width
						// and height to NaN, because they should remain
						// unchanged.
						bounds.x = x - bounds.x + xOffset;
						bounds.y = y - bounds.y + yOffset;
						bounds.width =
						bounds.height = NaN;
						layout.addItem(child.name, bounds);
					}
				}
			}

			return layout;
		}


		/**
		 *
		 * 
		 *
		 */
		override public function register(container:DisplayObjectContainer):void
		{
			this._containers[container] = true;
			super.register(container);
		}


		/**
		 *
		 * 
		 *
		 */
		override public function unregister(container:DisplayObjectContainer):void
		{
			delete this._containers[container];
			super.unregister(container);
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 *	
		 */
		private function _invalidateAll():void
		{
			for (var container:Object in this._containers)
			{
				this.invalidate(container as DisplayObjectContainer);
			}
		}




	}
}