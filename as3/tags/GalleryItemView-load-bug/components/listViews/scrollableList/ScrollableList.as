package inky.framework.components.listViews.scrollableList
{
	import inky.framework.collections.*;
	import inky.framework.components.scrollPane.views.BaseScrollPane;
	import inky.framework.components.scrollBar.ScrollPolicy;
	import inky.framework.components.listViews.IListView;
	import inky.framework.components.scrollBar.events.ScrollEvent;
	import inky.framework.components.scrollPane.views.IScrollPane;
	import inky.framework.controls.*;
	import inky.framework.display.IDisplayObject;
	import inky.framework.layout.events.LayoutEvent;
	import inky.framework.utils.EqualityUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


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
		private var _itemViewClass:Class;
		private var _indexes2Items:Object;
		private var _initializedForModel:Boolean;
		private var _items2Indexes:Dictionary;
		private var _model:IList;
		private var _numItemsFinallyVisible:uint;  // The number of items visible at max scroll position.
		private var _orientation:String;
		private var _positionCache:Array;
		private var _unusedItems:Object;		
		private var _sizeCache:Array;
		private var _spacing:Number;
		private var _widthOrHeight:String;
		private var _xOrY:String;


		/**
		 *
		 *	
		 */
		public function ScrollableList()
		{
			this._init();
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get itemViewClass():Class
		{
			return this._itemViewClass;
		}
		/**
		 * @private
		 */
		public function set itemViewClass(itemViewClass:Class):void
		{
			this._itemViewClass = itemViewClass;
		}


		/**
		 * @inheritDoc
		 */
		public function get model():IList
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(model:IList):void
		{
			if (!EqualityUtil.objectsAreEqual(model, this._model))
			{
				this._model = model;
				this._firstVisibleItemIndex = -1;
				this._unusedItems = {};
				this._sizeCache = [];
				this._indexes2Items = {};
				this._items2Indexes = new Dictionary(true);
				this._positionCache = [];
				this._initializedForModel = false;
				this.invalidate();	
			}
		}


		/**
		 *
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
		 * The number of pixels between each item.
		 *
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




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public function getItemPosition(index:int):Number
		{
			return this._getItemPosition(index);
		}


		/**
		 *
		 *	
		 */
		public function getItemSize(index:int):Number
		{
			return this._getItemSize(index);
		}


		/**
		 *
		 *	Invalidates the component, marking it for redrawing before the next frame.
		 *	
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
		 *
		 * Updates the contents of the container based on its position.
		 *		
		 */
		public function redraw():void
		{
			if (!this.orientation)
			{
				throw new Error("You must set the orientation on your ScrollableList");
			}

			if (!this._initializedForModel)
			{
				this._initializeForModel();
			}
			
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
					while ((firstVisibleItemIndex< this.model.length) && (this._getItemPosition(firstVisibleItemIndex) + this._getItemSize(firstVisibleItemIndex) + containerPosition < maskPosition))
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

			this._redrawFrom(firstVisibleItemIndex);
		}


		/**
		 * @inheritDoc
		 */
		public function showItemAt(index:int):void
		{
			if (!this.orientation)
			{
				throw new Error("You must set the orientation on your ScrollableList");
			}
			
			if ((index < 0) || (index >= this.model.length))
			{
				throw new RangeError("The supplied index " + index + " is out of bounds.");
			}

			this._setScrollPosition(index);
			var newPos:Object = {x: this.__contentContainer.x, y: this.__contentContainer.y};
			var mask:DisplayObject = this.getScrollMask();

			if (!isNaN(index))
			{
				if (this.model != null)
				{
					var target:Number = -this._getItemPosition(index);

					// Make sure we don't scroll "past" the content.
					if (index >= this.model.length - this._numItemsFinallyVisible)
					{
// FIXME: 
						target = Math.max(target, mask[this._widthOrHeight] - this._getItemPosition(this.model.length - 1) - this._getItemSize(this.model.length - 1));
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




		//
		// protected methods
		//


		/**
		 *
		 */
		override protected function scrollHandler(e:ScrollEvent):void
		{
			var index:Number = Math.round(this._getScrollPosition());
			if (!isNaN(index))
			{
				this.showItemAt(index);
			}
		}




		//
		// private methods
		//


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
		 *
		 * Gets an instance of the item view class to be used for the provided
		 * index.
		 *	
		 * @param index
		 *     the index of the item
		 * @param markAsUsed
		 *	
		 */
		private function _getItemFor(index:int):Object
		{
			var listItem:Object = this._indexes2Items[index] || this._unusedItems[index];

			if (!listItem)
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
				listItem = new this._itemViewClass();
				this._unusedItems[index] = listItem;
			}

			return listItem;
		}


		/**
		 *
		 * Gets the position of an item at a particular index.
		 *	
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
				else if ((index < this._firstVisibleItemIndex) && (index < this.model.length))
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
}catch(f){trace("TELL MATTHEW YOU SAW THIS ERROR NUMBER: " +er)}
			return position;
		}


		/**
		 *
		 * Gets the size of an item at a particular index.
		 *	
		 */
		private function _getItemSize(index:int):Number
		{
			var size:Number = this._sizeCache[index];
			if (isNaN(size))
			{
				var item:Object = this._getItemFor(index);
				if (!EqualityUtil.objectsAreEqual(item.model, this.model.getItemAt(index)))
				{
					item.model = this.model.getItemAt(index);
				}
				size = item[this._widthOrHeight];
				this._sizeCache[index] = size;
			}

			return size;
		}


		/**
		 *
		 */
		private function _getScrollPosition():Number
		{
			return this[this._orientation + "ScrollPosition"];
		}


		/**
		 *
		 *	Called by the constructor.
		 *	
		 */
		private function _init():void
		{
			this._spacing = 0;
			
			if (this.horizontalScrollBar && this.verticalScrollBar)
			{
// FIXME: should work with both, in case for example items in a vertically oriented list are too wide.
				throw new Error("A ScrollableList can have either a horizontal or vertical scroll bar, but not both (yet)");
			}
			
			if (this.horizontalScrollBar)
			{
				this.orientation = HORIZONTAL;
			}
			else if (this.verticalScrollBar)
			{
				this.orientation = VERTICAL;
			}

			this.__contentContainer = this.getContentContainer();
			this.__contentContainer.addEventListener(LayoutEvent.INVALIDATE, this._itemInvalidatedHandler);
		}


		private function _initializeForModel():void
		{
			// Determine the number of items that are visible at max scroll position.
// TODO: Move this to its own function, because it needs to be called when one of the finallyVisibleItem's size changes
			var mask:DisplayObject = this.getScrollMask();
			var maskSize:Number = mask[this._widthOrHeight];
			var numItems:int = 0;
			var combinedSize:Number = 0;
			var j:int = this.model.length - 1;
			while ((j >= 0) && (combinedSize < maskSize))
			{
				numItems++;
				combinedSize += this._getItemSize(j);
				j--;
			}
			this._numItemsFinallyVisible = numItems;
			this._updateScrollBar();
			this._clearContent();
			this._initializedForModel = true;
		}


		/**
		 *
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
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
			}

			this.redraw()
		}


		/**
		 *
		 *	A helper method for redraw(). Do not call this method directly.
		 *	
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
			while (index < this.model.length)
			{
				listItem = this._getItemFor(index);

				var model:Object = this.model.getItemAt(index);
				if (!EqualityUtil.objectsAreEqual(listItem.model, model))
				{
					listItem.model = model;
				}

				if (listItem.parent != this.__contentContainer)
				{
					this.__contentContainer.addChild(listItem as DisplayObject);
				}

				listItem.visible = true;

				// Mark the item as used.
				delete this._unusedItems[index];
				this._indexes2Items[index] = listItem;
				this._items2Indexes[listItem] = index;

				pos = this._getItemPosition(index);
				listItem[this._xOrY] = pos;

				// The next item will need to know the new first visible item.
				this._firstVisibleItemIndex = startIndex;

				// If we have enough items to fill the entire viewable area (even when the first item is scrolling out), stop.
				if (pos - this._getItemPosition(startIndex + 1) > maskSize)
				{
					break;
				}

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
		 *	
		 */
		private function _setScrollPosition(index:int):void
		{
			var capProp:String = this._orientation == "horizontal" ? "Horizontal" : "Vertical";
			this[this._orientation + "ScrollPosition"] = Math.min(index, this["max" + capProp + "ScrollPosition"]);
		}


		/**
		 *
		 * Updates the appearance of the scroll bars based on the combined size
		 * of the items in the list and the scroll policy.
		 *	
		 */
		private function _updateScrollBar():void
		{
			if (model)
			{
// TODO: Instead use this.maxHorizontalScrollPosition and horizontalPageSize
				if (this[this._orientation + "ScrollBar"])
				{
					this[this._orientation + "ScrollBar"].maxScrollPosition = this.model.length - this._numItemsFinallyVisible + 1;
					this[this._orientation + "ScrollBar"].pageSize = this._numItemsFinallyVisible;
				}
			}
		/*
			var contentSize:Number = listItem[this._xOrY] + listItem[this._widthOrHeight];
			this[this._orientation + "ScrollBar"].enabled = this.__contentContainer[this._widthOrHeight] > mask[this._widthOrHeight];

			if (this[this._orientation + "ScrollPolicy"] == ScrollPolicy.AUTO)
			{
				this[this._orientation + "ScrollBar"].visible = this[this._orientation + "ScrollBar"].enabled;
			}
			else
			{
				this[this._orientation + "ScrollBar"].visible = this[this._orientation + "ScrollPolicy"] == ScrollPolicy.ON;
			}*/
		}




	}
}
