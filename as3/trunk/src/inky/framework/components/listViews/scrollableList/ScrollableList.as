﻿package inky.framework.components.listViews.scrollableList
{
	import inky.framework.collections.*;
	import inky.framework.components.scrollPane.views.BaseScrollPane;
	import inky.framework.components.scrollBar.ScrollPolicy;
	import inky.framework.components.listViews.IListView;
	import inky.framework.components.IComponentView;
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
		private var _isValidating:Boolean;
		private var _indexes2Items:Object;
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
			this._model = model;
			this._setContent();
		}


		/**
		 *
		 *
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
		 * @inheritDoc
		 */	
		override public function update():void
		{
			if (model)
			{
				if (this[this._orientation + "ScrollBar"])
				{
					this[this._orientation + "ScrollBar"].maxScrollPosition = this.model.length - this._numItemsFinallyVisible + 1;
this[this._orientation + "ScrollBar"].pageSize = this._numItemsFinallyVisible;
				}
			}
		}




		//
		// protected methods
		//


		/**
		 *
		 * Updates the contents of the container based on its position.
		 *		
		 */
		protected function updateContent():void
		{
var firstVisibleItemIndex:int = this._firstVisibleItemIndex;
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
this._updateContent(firstVisibleItemIndex);

			/*var container:DisplayObjectContainer = this.getContentContainer();
			var mask:DisplayObject = this.getScrollMask();

			// Get the index of the first visible item.
			var firstVisibleItemIndex:int = 0;
			var combinedSize:Number = 0;
			var y:Number = container[this._xOrY];

			while (container[this._xOrY] + this._getItemPosition(firstVisibleItemIndex + 1) < mask[this._xOrY])
			{
				firstVisibleItemIndex++;
			}

			this._updateContent(firstVisibleItemIndex);*/
		}


		/**
		 *
		 */
		override protected function scrollHandler(e:ScrollEvent):void
		{
			var pos:Number = Math.round(this[this._orientation + "ScrollPosition"]);
			var newPos:Object = {x: this.__contentContainer.x, y: this.__contentContainer.y};
			var mask:DisplayObject = this.getScrollMask();

			if (!isNaN(pos))
			{
				if (this.model != null)
				{
					var target:Number = -this._getItemPosition(pos);
					
					// Make sure we don't scroll "past" the content.
					if (pos >= this.model.length - this._numItemsFinallyVisible)
					{
// FIXME: 
						target = Math.max(target, mask[this._widthOrHeight] - this._getItemPosition(this.model.length - 1) - this._getItemSize(this.model.length - 1));
					}
					newPos[this._xOrY] = Math.min(0, target);
				}
			}

			this.moveContent(newPos.x, newPos.y);
			this.updateContent();
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
		private function _getItemFor(index:int):IComponentView
		{
			var listItem:IComponentView = this._indexes2Items[index] || this._unusedItems[index];

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
//!return index * 10;
			var position:Number = this._positionCache[index];

			if (isNaN(position))
			{
				// Determine the position
				if (this._firstVisibleItemIndex == -1)
				{
					position = 0;
				}
				else if (index == this._firstVisibleItemIndex)
				{
					position = this._indexes2Items[index].y;
				}
				else if (index < this._firstVisibleItemIndex)
				{
					position = this._getItemPosition(index + 1) - this._getItemSize(index) - this._spacing;
				}
				else if (index > this._firstVisibleItemIndex)
				{
					position = this._getItemPosition(index - 1) + this._getItemSize(index - 1) + this._spacing;
				}
				
				this._positionCache[index] = position;
			}

			return position;
		}


		/**
		 *
		 * Gets the size of an item at a particular index.
		 *	
		 */
		private function _getItemSize(index:int):Number
		{
//			var size:Number = NaN;//this._sizeCache[index];
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
				this._orientation = HORIZONTAL;
				this._widthOrHeight = "width";
				this._xOrY = "x";
			}
			else
			{
				this._orientation = VERTICAL;
				this._widthOrHeight = "height";
				this._xOrY = "y";
			}

			this.__contentContainer = this.getContentContainer();
			this.__contentContainer.addEventListener(LayoutEvent.INVALIDATE, this._invalidateHandler);
			this[this._orientation + 'LineScrollSize'] = 1;
		}


private function _invalidateHandler(e:LayoutEvent):void
{
	if (e.target.parent == this.__contentContainer)
	{
		if (e.property == this._widthOrHeight)
		{
			this._invalidateItemSize(e.target as IComponentView);
		}
	}
}


private function _invalidateAllPositions():void
{
	this._positionCache = [];
	this._redraw();
}

		/**
		 *
		 *	
		 */
		private function _invalidateItemSize(item:IComponentView):void
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
			this._redraw();
		}


		/**
		 *
		 *	
		 */
		private function _setContent():void
		{
			this._isValidating = false;
			this._firstVisibleItemIndex = -1;
			this._unusedItems = {};
			this._sizeCache = [];
			this._indexes2Items = {};
			this._items2Indexes = new Dictionary(true);
			this._positionCache = [];
			
			// Determine the number of items that are visible at max scroll position.
			var mask:DisplayObject = this.getScrollMask();
			var maskSize:Number = mask[this._widthOrHeight];
			var numItems:int = 0;
			var combinedSize:Number = 0;
			var j:int = this.model.length - 1;
			while (combinedSize < maskSize)
			{
				numItems++;
				combinedSize += this._getItemSize(j);
				j--;
			}
			this._numItemsFinallyVisible = numItems;

			this.addEventListener(Event.ENTER_FRAME, this._setContentNow);			
		}
		

		/**
		 *
		 */
		private function _setContentNow(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this._clearContent();

			if (this._model == null) return;
			if (this._itemViewClass == null)
			{
				throw new Error("itemViewClass is not set!");
			}

			this[this._orientation + 'ScrollBar'].minScrollPosition = 0
			this._updateContent(0);
			this.update();
		}


		/**
		 *
		 *	
		 */
		private function _updateContent(startIndex:int):void
		{
			if (this._isValidating) return;
			this._isValidating = true;
			this.__updateContent(startIndex);
			this._isValidating = false;
		}


		/**
		 *
		 *	
		 */
		private function __updateContent(startIndex:int):void
		{
			/*if (startIndex == this._firstVisibleItemIndex)
			{
				// Already showing the correct units.
				return;
			}*/

			var listItem:IComponentView;
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
				listItem.visible = true;
				if (listItem.parent != this.__contentContainer)
				{
					this.__contentContainer.addChild(listItem as DisplayObject);
				}
				var model:Object = this.model.getItemAt(index);
				if (!EqualityUtil.objectsAreEqual(listItem.model, model))
				{
					listItem.model = model;
				}

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
//				listItem.visible = false;
			}

			this._updateScrollBars();

		}





		private function _markItemUnused(item:IComponentView, index:int):void
		{
			delete this._items2Indexes[item];
			delete this._indexes2Items[index];
			this._unusedItems[index] = item;
		}



		private function _redraw():void
		{
			this._updateContent(this._firstVisibleItemIndex);
		}


		/**
		 *
		 * Updates the appearance of the scroll bars based on the combined size
		 * of the items in the list and the scroll policy.
		 *	
		 */
		private function _updateScrollBars():void
		{
		/*
		// FIXME: this needs to be based on what the height would be with all the elements, not what it is!
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
