package inky.components.listViews.scrollableList
{
	import inky.collections.*;
	import inky.components.scrollPane.views.BaseScrollPane;
	import inky.components.scrollBar.ScrollPolicy;
	import inky.components.listViews.IListView;
	import inky.components.scrollBar.events.ScrollEvent;
	import inky.layout.events.LayoutEvent;
	import inky.utils.EqualityUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import inky.components.scrollBar.views.IScrollBar;


	/**
	 *
	 *  	
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *	
	 */
	public class ScrollableList extends BaseScrollPane implements IListView
	{
		private static var HORIZONTAL:String = "horizontal"; // Should be in another class.
		private static var VERTICAL:String = "vertical";
		
		private var __contentContainer:DisplayObjectContainer;
		private var _firstVisibleItemIndex:int;
		private var _rendererClass:Class;
		private var _indexes2Items:Object;
		private var _initializedForModel:Boolean;
		private var _items2Indexes:Dictionary;
		private var _dataProvider:IList;
		private var _numItemsFinallyVisible:uint;  // The number of items visible at max scroll position.
		private var _orientation:String;
		private var _positionCache:Array;
		private var _unusedItems:Object;
		private var _recycleRenderers:Boolean;
		private var _sizeCache:Array;
		private var _spacing:Number;
		private var _widthOrHeight:String;
		private var _xOrY:String;
// FIXME: When recycleRenderers == true, you can see dataProvider being reset on first item.  The class does this in order to calculate the total size, but it shouldn't use items that are on stage.
// TODO: allow option that says the item views won't change size.  this way, you can calculate the container size using simple multiplication.

		/**
		 *	
		 */
		public function ScrollableList()
		{
			this._init();
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get dataProvider():IList
		{
			return this._dataProvider;
		}
		/**
		 * @private
		 */
		public function set dataProvider(dataProvider:IList):void
		{
			if (!EqualityUtil.objectsAreEqual(dataProvider, this._dataProvider))
			{
				this._dataProvider = dataProvider;
				this._firstVisibleItemIndex = -1;
				this._unusedItems = {};
				this._sizeCache = [];
				this._indexes2Items = {};
				this._items2Indexes = new Dictionary(true);
				this._positionCache = [];
				this._initializedForModel = false;
				this._setScrollPosition(0);
				this.invalidate();	
			}
		}

		/**
		 *	
		 */
		public function get orientation():String
		{
			return this._orientation;
		}
		/**
		 *
		 */
		public function set orientation(value:String):void
		{
// FIXME: when can this be set?
			this._orientation = value;
			
			if (value == HORIZONTAL)
			{
				this._widthOrHeight = "width";
				this._xOrY = "x";
			}
			else if (value == VERTICAL)
			{
				this._widthOrHeight = "height";
				this._xOrY = "y";
			}
			else
			{
				throw new Error("ScrollableList orientation can only be horizontal or vertical");
			}
			
			if (this[this._orientation + "ScrollBar"])
				this[this._orientation + 'LineScrollSize'] = 1;
		}


		/**
		 *
		 */
		public function get recycleRenderers():Boolean
		{ 
			return this._recycleRenderers; 
		}
		public function set recycleRenderers(value:Boolean):void
		{
			this._recycleRenderers = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rendererClass():Class
		{
			return this._rendererClass;
		}
		/**
		 * @private
		 */
		public function set rendererClass(rendererClass:Class):void
		{
			this._rendererClass = rendererClass;
		}

		/**
		 * The number of pixels between each item.
		 */
		public function get spacing():Number
		{
			return this._spacing;
		}
		/**
		 * @private
		 */
		public function set spacing(value:Number):void
		{
			this._spacing = value;
			this._invalidateAllPositions();
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *
		 */
		public function getItemPosition(index:int):Number
		{
			return this._getItemPosition(index);
		}

		/**
		 *
		 */
		public function getItemSize(index:int):Number
		{
			return this._getItemSize(index);
		}

		/**
		 *	Invalidates the component, marking it for redrawing before the next frame.
		 */
		public function invalidate():void
		{
			if (this.stage)
			{
				this._invalidate()
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, this._invalidate);
			}
		}

		/**
		 * Updates the contents of the container based on its position.
		 */
		public function redraw():void
		{
// TODO: redraw when the dataProvider is null.
			if (!this.orientation)
				throw new Error("You must set the orientation on your ScrollableList");

			if (!this._initializedForModel)
				this._initializeForModel();
			
			var firstVisibleItemIndex:int = this._firstVisibleItemIndex;
			
			if (firstVisibleItemIndex == -1)
			{
				firstVisibleItemIndex = 0;
			}
			else
			{
				var mask:DisplayObject = this.getScrollMask();
				var maskSize:Number = mask[this._widthOrHeight];
				var maskPosition:Number = mask[this._xOrY];
				var container:DisplayObjectContainer = this.getContentContainer();
				var containerPosition:Number = container[this._xOrY];

				if (this._getItemPosition(firstVisibleItemIndex) + this._getItemSize(firstVisibleItemIndex) + containerPosition < maskPosition)
				{
					while ((firstVisibleItemIndex< this.dataProvider.length) && (this._getItemPosition(firstVisibleItemIndex) + this._getItemSize(firstVisibleItemIndex) + containerPosition < maskPosition))
					{
						firstVisibleItemIndex++;
					}
				}
				else
				{
					while ((firstVisibleItemIndex > 0) && (this._getItemPosition(firstVisibleItemIndex) + containerPosition > maskPosition))
					{
						firstVisibleItemIndex--;
					}
				}
			}
			
			this._updateLayout();
			this._redrawFrom(firstVisibleItemIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function showItemAt(index:int):void
		{
// TODO: is this the right way to handle this situation?
if (!this.dataProvider) return;

			if (!this.orientation)
				throw new Error("You must set the orientation on your ScrollableList");

			if ((index < 0) || (index >= this.dataProvider.length))
				throw new RangeError("The supplied index " + index + " is out of bounds.");

			this._setScrollPosition(index);
			var newPos:Object = {x: this.__contentContainer.x, y: this.__contentContainer.y};
			var mask:DisplayObject = this.getScrollMask();

			if (!isNaN(index))
			{
				if (this.dataProvider != null)
				{
					var target:Number = -this._getItemPosition(index);

					// Make sure we don't scroll "past" the content.
					if (index >= this.dataProvider.length - this._numItemsFinallyVisible)
					{
// FIXME: 
						target = Math.max(target, mask[this._widthOrHeight] - this._getItemPosition(this.dataProvider.length - 1) - this._getItemSize(this.dataProvider.length - 1));
					}
					newPos[this._xOrY] = Math.min(0, target);
				}
			}

			this.moveContent(newPos.x, newPos.y);
			this.invalidate();
		}

		/**
		 * @inheritDoc
		 */	
		override public function update():void
		{
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 *
		 */
		override protected function scrollHandler(e:ScrollEvent):void
		{
// TODO: Because the super constructor's bindings access something that calls this, orientation 
// is null (not yet initialized). Should orientation have a default value?
if (!this.orientation) return;
			var index:Number = Math.round(this._getScrollPosition());
			if (!isNaN(index))
				this.showItemAt(index);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 *
		 */
		private function _clearContent():void
		{
			while (this.__contentContainer.numChildren)
			{
				this.__contentContainer.removeChildAt(0);
			}
		}

		/**
		 * Gets an instance of the item view class to be used for the provided
		 * index.
		 *	
		 * @param index
		 *     the index of the item
		 * @param markAsUsed
		 */
		private function _getRendererFor(index:int):Object
		{
			var listItem:Object = this._indexes2Items[index] || this._unusedItems[index];

			if (!listItem && this.recycleRenderers)
			{
				// Recycle the first unused item.
				for (var p:String in this._unusedItems)
				{
					listItem = this._unusedItems[p];
					delete this._unusedItems[p];
					this._unusedItems[index] = listItem;
					break;
				}
			}

			// If there are no unused items to recycle, create a new one.
			if (!listItem)
			{
				listItem = new this._rendererClass();
				this._unusedItems[index] = listItem;
			}

			return listItem;
		}

		/**
		 * Gets the position of an item at a particular index.
		 */
		private function _getItemPosition(index:int):Number
		{
var er;
er = 1;
			var position:Number = this._positionCache[index];
try {
			if (isNaN(position))
			{
er = 2;
				// Determine the position
				if (index == this._firstVisibleItemIndex)
				{
er = 3;
					position = this._indexes2Items[index] ? this._indexes2Items[index][this._xOrY] : 0;
				}
				else if ((index < this._firstVisibleItemIndex) && (index < this.dataProvider.length))
				{
er = 4;
					position = this._getItemPosition(index + 1) - this._getItemSize(index) - this._spacing;
				}
				else if ((index > this._firstVisibleItemIndex) && (index > 0))
				{
er = 5;
					position = this._getItemPosition(index - 1) + this._getItemSize(index - 1) + this._spacing;
				}
				else
				{
er = 6;
					position = 0;
				}
er = 7;
				this._positionCache[index] = position;
			}
}catch(f){trace("TELL MATTHEW YOU SAW THIS ERROR NUMBER: " + er)}
			return position;
		}

		/**
		 * Gets the size of an item at a particular index.
		 */
		private function _getItemSize(index:int):Number
		{
			var size:Number = this._sizeCache[index];
			if (isNaN(size))
			{
				var renderer:Object = this._getRendererFor(index);
				if (!EqualityUtil.objectsAreEqual(renderer.model, this.dataProvider.getItemAt(index)))
					renderer.model = this.dataProvider.getItemAt(index);
				size = renderer[this._widthOrHeight];
				this._sizeCache[index] = size;
			}

			return size;
		}

		/**
		 *
		 */
		private function _getScrollBar():IScrollBar
		{
			return this[this._orientation + "ScrollBar"];
		}

		/**
		 *
		 */
		private function _getScrollPosition():Number
		{
			return this[this._orientation + "ScrollPosition"];
		}

		/**
		 *	Called by the constructor.
		 */
		private function _init():void
		{
			this._recycleRenderers = true;
			this._spacing = 0;
			
			if (this.horizontalScrollBar && this.verticalScrollBar)
			{
// FIXME: should work with both, in case for example items in a vertically oriented list are too wide.
				throw new Error("A ScrollableList can have either a horizontal or vertical scroll bar, but not both (yet)");
			}

			if (this.horizontalScrollBar)
				this.orientation = HORIZONTAL;
			else if (this.verticalScrollBar)
				this.orientation = VERTICAL;

			this.__contentContainer = this.getContentContainer();
			this.__contentContainer.addEventListener(LayoutEvent.INVALIDATE, this._itemInvalidatedHandler);
		}

		/**
		 * 
		 */
		private function _initializeForModel():void
		{
			if (!this.dataProvider) 
				return;
			
			this._updateLayout();
			this._clearContent();
			this._initializedForModel = true;
		}

		/**
		 *
		 */
		private function _invalidate(e:Event = null):void
		{
			this.stage.addEventListener(Event.RENDER, this._redraw, false, 0, true);
			this.stage.invalidate();
		}

		/**
		 *
		 */
		private function _invalidateAllPositions():void
		{
			this._positionCache = [];
			this.invalidate();
		}

		/**
		 *
		 */
		private function _itemInvalidatedHandler(e:LayoutEvent):void
		{
			if (e.target.parent == this.__contentContainer)
			{
				if (e.property == this._widthOrHeight)
				{
					this._invalidateItemSize(e.target);
				}
			}
		}

		/**
		 *
		 */
		private function _invalidateItemSize(item:Object):void
		{
			// Get the item index.
			var index:Number = this._items2Indexes[item];
			if (!isNaN(index))
			{
				this._invalidateItemSizeAt(item, index);
			}
		}

		/**
		 *
		 */
		private function _invalidateItemSizeAt(item:Object, index:int):void
		{
			// If the item's size hasn't actually changed, don't redraw.
			if (this._sizeCache[index] == item[this._widthOrHeight]) return;

			if (index < this._firstVisibleItemIndex)
			{
				// If the item is not visible, we need to validate previous items (because position is determined relative to visible items)
				for (var i:int = 0; i <= index; i++)
				{
					delete this._positionCache[i];
				}
			}
			else
			{
				// If the item is visible, we need to invalidate subsequent items.
				this._positionCache.length = index;				
			}
			
			delete this._sizeCache[index];
			this.invalidate();
		}

		/**
		 *	
		 */
		private function _markItemUnused(item:Object, index:int):void
		{
			delete this._items2Indexes[item];
			delete this._indexes2Items[index];
			this._unusedItems[index] = item;
		}

		/**
		 *
		 */
		private function _redraw(e:Event):void
		{
			if (e)
				e.currentTarget.removeEventListener(e.type, arguments.callee);

			if (this.dataProvider || this._initializedForModel)
				this.redraw()
		}

		/**
		 *	A helper method for redraw(). Do not call this method directly.
		 */
		private function _redrawFrom(startIndex:int):void
		{
			var listItem:Object;
			var index:int = startIndex;
			var mask:DisplayObject = this.getScrollMask();
			var maskSize:Number = mask[this._widthOrHeight];
			var i:int;
			var container:DisplayObjectContainer = this.getContentContainer();
			var pos:Number;

			// Mark earlier ones as unused.
// TODO: Because we don't yet know many list items will fit in the viewport, we don't know if we can reuse items with index > startindex. Figure out how to know. We could use _getItemPosition to figure it out, but then we'd be constantly setting the model on instances that wouldn't be used with the model.
			for (i = 0; i < startIndex; i++)
			{
				listItem = this._indexes2Items[i];
				if (listItem)
				{
					this._markItemUnused(listItem, i);
				}
			}

			// Add and position items as needed.
			while (index < this.dataProvider.length)
			{
				listItem = this._getRendererFor(index);

				var model:Object = this.dataProvider.getItemAt(index);
				if (!EqualityUtil.objectsAreEqual(listItem.model, model))
					listItem.model = model;

				if (listItem.parent != this.__contentContainer)
					this.__contentContainer.addChild(listItem as DisplayObject);

				listItem.visible = true;

				// Mark the item as used.
				delete this._unusedItems[index];
				this._indexes2Items[index] = listItem;
				this._items2Indexes[listItem] = index;

				pos = this._getItemPosition(index);
				listItem[this._xOrY] = pos;
				var otherPositionProperty:String = this._xOrY == "x" ? "y" : "x";
				listItem[otherPositionProperty] = mask[otherPositionProperty];

				// The next item will need to know the new first visible item.
				this._firstVisibleItemIndex = startIndex;

				// If we have enough items to fill the entire viewable area (even when the first item is scrolling out), stop.
				if (pos - this._getItemPosition(startIndex + 1) > maskSize)
					break;

				index++;
			}

			// Update list of unused items.
			var endIndex:int = index;
			for (var p:String in this._indexes2Items)
			{
				i = parseInt(p);
				if (i < startIndex || i > endIndex)
				{
					listItem = this._indexes2Items[i];
					this._markItemUnused(listItem, i);
				}
			}

			// Hide the unused items.
			for each (listItem in this._unusedItems)
			{
				listItem.visible = false;
			}
		}

		/**
		 *	
		 */
		private function _setScrollPosition(index:int):void
		{
			var capProp:String = this._orientation == "horizontal" ? "Horizontal" : "Vertical";
			this[this._orientation + "ScrollPosition"] = Math.min(index, this["max" + capProp + "ScrollPosition"]);
		}

		/**
		 *	Updates the ScrollPane layout.
		 */
		private function _updateLayout():void
		{
			// Determine the number of items that are visible at max scroll position.
			var mask:DisplayObject = this.getScrollMask();
			var maskSize:Number = mask[this._widthOrHeight];
			var numItems:int = 0;
			var combinedSize:Number = 0;
			var j:int = this.dataProvider.length - 1;

			while ((j >= 0) && (combinedSize < maskSize))
			{
				numItems++;
				combinedSize += this._getItemSize(j);
				j--;
			}

			if (numItems != this._numItemsFinallyVisible)
			{
				this._numItemsFinallyVisible = numItems;
				this._updateScrollBar();
			}
		}

		/**
		 * Updates the appearance of the scroll bars based on the combined size
		 * of the items in the list and the scroll policy.
		 */
		private function _updateScrollBar():void
		{
			if (this.dataProvider)
			{
				var mask:DisplayObject = this.getScrollMask();
				var scrollBar:IScrollBar = this._getScrollBar();
// TODO: Instead use this.maxHorizontalScrollPosition and horizontalPageSize
				if (scrollBar)
				{
					scrollBar.maxScrollPosition = this.dataProvider.length - this._numItemsFinallyVisible + 1;
					scrollBar.pageSize = this._numItemsFinallyVisible;
				}
				var contentSize:Number = this._getItemSize(this._dataProvider.length - 1) + this._getItemPosition(this._dataProvider.length - 1);
			
				scrollBar.enabled = contentSize > mask[this._widthOrHeight];

				if (this[this._orientation + "ScrollPolicy"] == ScrollPolicy.AUTO)
					scrollBar.visible = scrollBar.enabled;
				else
					scrollBar.visible = this[this._orientation + "ScrollPolicy"] == ScrollPolicy.ON;
			}
		}




	}
}