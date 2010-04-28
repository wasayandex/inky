package inky.components.listViews.scrollableList
{
	import inky.collections.IList;
	import inky.components.scrollPane.BaseScrollPane;
	import inky.components.scrollBar.ScrollPolicy;
	import inky.components.listViews.IListView;
	import inky.components.scrollBar.events.ScrollEvent;
	import inky.layout.events.LayoutEvent;
	import inky.utils.EqualityUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import inky.components.scrollBar.IScrollBar;
	import inky.collections.events.CollectionEvent;
	import flash.utils.setTimeout;
	import inky.layout.utils.ValidationState;
	import inky.utils.describeObject;


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
// TODO: Figure out a way that will easily allow you to make a ScrollableList whose shown item is the centered on. Not only does this require a different validateContentPosition(), but also a different updateScrollBar(). see <http://inky.googlecode.com/svn/trunk/as3/trunk/examples/gallery/src/as3/main/MyScrollableList.as> -r1042 for validateContentPosition() implementation
		private static const HORIZONTAL:String = "horizontal"; // Should be in another class.
		private static const VERTICAL:String = "vertical";
		
		private static const CONTENT_POSITION:String = "contentPosition";
		private static const DISPLAY_LIST:String = "displayList";
		private static const SCROLL_POSITION:String = "scrollPosition";
		private static const SCROLL_PROPERTIES:String = "scrollProperties";
		
		private var __contentContainer:DisplayObjectContainer;
		private var _firstVisibleItemIndex:int;
		private var _itemRendererClass:Class;
		private var _indexes2Items:Object;
		private var _initializedForModel:Boolean;
		private var _items2Indexes:Dictionary;
		private var _dataProvider:IList;
		private var _orientation:String;
		private var _positionCache:Array;
		private var _unusedItems:Object;
		private var _recycleItemRenderers:Boolean;
		private var shownItem:int;
		private var showItemAtPending:Boolean;
		private var _sizeCache:Array;
		private var _spacing:Number;
		private var validationState:ValidationState;
		private var _widthOrHeight:String;
		private var _xOrY:String;
// FIXME: When recycleItemRenderers == true, you can see dataProvider being reset on first item.  The class does this in order to calculate the total size, but it shouldn't use items that are on stage.
// TODO: allow option that says the item views won't change size.  this way, you can calculate the container size using simple multiplication.

		/**
		 *	
		 */
		public function ScrollableList()
		{
			this.init();
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
		public function set dataProvider(value:IList):void
		{
			if (!EqualityUtil.objectsAreEqual(value, this._dataProvider))
			{
				if (this._dataProvider)
					this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.dataProvider_collectionChangeHandler);
				if (value)
					value.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.dataProvider_collectionChangeHandler, false, 0, true);
				
				this._dataProvider = value;
				this.reset();
				
				this.dispatchEvent(new Event("dataProviderChanged"));
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
		public function get recycleItemRenderers():Boolean
		{ 
			return this._recycleItemRenderers; 
		}
		public function set recycleItemRenderers(value:Boolean):void
		{
			this._recycleItemRenderers = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get itemRendererClass():Class
		{
			return this._itemRendererClass;
		}
		/**
		 * @private
		 */
		public function set itemRendererClass(itemRendererClass:Class):void
		{
			this._itemRendererClass = itemRendererClass;
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
			this.invalidateAllPositions();
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *
		 */
		public function getItemPosition(index:int):Number
		{
			var position:Number = this._positionCache[index];

			if (isNaN(position))
			{
				// Determine the position
				if (index == this._firstVisibleItemIndex)
					position = this._indexes2Items[index] ? this._indexes2Items[index][this._xOrY] : 0;
				else if ((index < this._firstVisibleItemIndex) && (index < this.dataProvider.length))
					position = this.getItemPosition(index + 1) - this.getItemSize(index) - this._spacing;
				else if ((index > this._firstVisibleItemIndex) && (index > 0))
					position = this.getItemPosition(index - 1) + this.getItemSize(index - 1) + this._spacing;
				else
					position = 0;

				this._positionCache[index] = position;
			}

			return position;
		}

		/**
		 *
		 */
		public function getItemSize(index:int):Number
		{
			var size:Number = this._sizeCache[index];
			if (isNaN(size))
			{
				var itemRenderer:Object = this.getItemRendererFor(index);
				var itemModel:Object = this.dataProvider.getItemAt(index);
				if (!EqualityUtil.objectsAreEqual(itemRenderer.model, itemModel))
					itemRenderer.model = itemModel;
				size = itemRenderer[this._widthOrHeight];
				this._sizeCache[index] = size;
			}
			return size;
		}

		/**
		 *	Invalidates the component, marking it for redrawing before the next frame.
		 */
		public function invalidate():void
		{
			this.validationState.markPropertyAsInvalid(DISPLAY_LIST);

			if (this.stage)
				this._invalidate()
			else
				this.addEventListener(Event.ADDED_TO_STAGE, this._invalidate);
		}

		/**
		 * Updates the contents of the container based on its position.
		 */
		public function redraw():void
		{
// TODO: redraw when the dataProvider is null.
			if (!this.dataProvider && !this._initializedForModel)
				return;

			if (!this.orientation)
				throw new Error("You must set the orientation on your ScrollableList");

			if (!this._initializedForModel)
				this.initializeForModel();
			
			var firstVisibleItemIndex:int = this._firstVisibleItemIndex;

			if (firstVisibleItemIndex == -1)
				firstVisibleItemIndex = 0;

			if (this.dataProvider && this.dataProvider.length)
			{
				var mask:DisplayObject = this.getScrollMask();
				var maskSize:Number = mask[this._widthOrHeight];
				var maskPosition:Number = mask[this._xOrY];
				var container:DisplayObjectContainer = this.getContentContainer();
				var containerPosition:Number = container[this._xOrY];

				if (this.getItemPosition(firstVisibleItemIndex) + this.getItemSize(firstVisibleItemIndex) + containerPosition < maskPosition)
				{
					while ((firstVisibleItemIndex < this.dataProvider.length) && (this.getItemPosition(firstVisibleItemIndex) + this.getItemSize(firstVisibleItemIndex) + containerPosition < maskPosition))
					{
						firstVisibleItemIndex++;
					}
				}
				else
				{
					while ((firstVisibleItemIndex > 0) && (this.getItemPosition(firstVisibleItemIndex) + containerPosition > maskPosition))
					{
						firstVisibleItemIndex--;
					}
				}
			}

			this.redrawFrom(firstVisibleItemIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function showItemAt(index:int):void
		{
			// Flag a public showItemAt update as pending; this will stop scrollBar updates from overriding the user-provided index.
			this.showItemAtPending = true;
			this._showItemAt(index, true);
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
		override protected function scrollHandler(event:ScrollEvent):void
		{
// TODO: Because the super constructor's bindings access something that calls this, orientation is null (not yet initialized). Should orientation have a default value?
if (!this.orientation) return;
			
			// If a public showItemAt update is pending, the user value overrides the calculated value from scrollbar, so ignore this update.
			if (this.showItemAtPending) 
				return;

			var index:Number = this.dataProvider ? Math.max(0, Math.min(this.dataProvider.length - 1, Math.round(this.getScrollPosition()))) : 0;
			this._showItemAt(index);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 *
		 */
		private function clearContent():void
		{
			while (this.__contentContainer.numChildren)
			{
				this.__contentContainer.removeChildAt(0);
			}
		}

		/**
		 * 
		 */
		private function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			this.reset(false);
		}

		/**
		 * Gets an instance of the item view class to be used for the provided
		 * index.
		 *	
		 * @param index
		 *     the index of the item
		 * @param markAsUsed
		 */
		private function getItemRendererFor(index:int):Object
		{
			var listItem:Object = this._indexes2Items[index] || this._unusedItems[index];

			if (!listItem && this.recycleItemRenderers)
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
				listItem = new this._itemRendererClass();
				this._unusedItems[index] = listItem;
			}

			return listItem;
		}

		/**
		 *
		 */
		private function getScrollBar():IScrollBar
		{
			return this[this._orientation + "ScrollBar"];
		}

		/**
		 *
		 */
		private function getScrollPosition():Number
		{
			return this[this._orientation + "ScrollPosition"];
		}

		/**
		 *	Called by the constructor.
		 */
		private function init():void
		{
			this.validationState = new ValidationState();
			this._recycleItemRenderers = true;
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
			this.__contentContainer.addEventListener(LayoutEvent.INVALIDATE, this.itemInvalidatedHandler);
		}

		/**
		 * 
		 */
		private function initializeForModel():void
		{
			if (!this.dataProvider) 
				return;
			
			this.updateScrollBar();
			this.clearContent();
			this._initializedForModel = true;
		}

		/**
		 * Schedule validation. Since the RENDER event can be unreliable, we
		 * use ENTER_FRAME as a backup.
		 */
		private function _invalidate(event:Event = null):void
		{
			this.stage.addEventListener(Event.RENDER, this.validate, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, this.validate, false, 0, true);
			this.stage.invalidate();
		}

		/**
		 *
		 */
		private function invalidateAllPositions():void
		{
			this._positionCache = [];
			this.invalidate();
		}

		/**
		 *
		 */
		private function itemInvalidatedHandler(e:LayoutEvent):void
		{
			if (e.target.parent == this.__contentContainer)
			{
				if (e.property == this._widthOrHeight)
				{
					this.invalidateItemSize(e.target);
				}
			}
		}

		/**
		 *
		 */
		private function invalidateItemSize(item:Object):void
		{
			// Get the item index.
			var index:Number = this._items2Indexes[item];
			if (!isNaN(index))
			{
				this.invalidateItemSizeAt(item, index);
			}
		}

		/**
		 *
		 */
		private function invalidateItemSizeAt(item:Object, index:int):void
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
		private function markItemUnused(item:Object, index:int):void
		{
			delete this._items2Indexes[item];
			delete this._indexes2Items[index];
			this._unusedItems[index] = item;
		}

		/**
		 *	A helper method for redraw(). Do not call this method directly.
		 */
		private function redrawFrom(startIndex:int):void
		{
			var listItem:Object;
			var index:int = startIndex;
			var mask:DisplayObject = this.getScrollMask();
			var maskSize:Number = mask[this._widthOrHeight];
			var i:int;
			var container:DisplayObjectContainer = this.getContentContainer();
			var pos:Number;

			// Mark earlier ones as unused.
// TODO: Because we don't yet know many list items will fit in the viewport, we don't know if we can reuse items with index > startindex. Figure out how to know. We could use getItemPosition to figure it out, but then we'd be constantly setting the model on instances that wouldn't be used with the model.
			for (i = 0; i < startIndex; i++)
			{
				listItem = this._indexes2Items[i];
				if (listItem)
				{
					this.markItemUnused(listItem, i);
				}
			}

			// Add and position items as needed.
			while (index < this.dataProvider.length)
			{
				listItem = this.getItemRendererFor(index);

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

				pos = this.getItemPosition(index);
				listItem[this._xOrY] = pos;
				var otherPositionProperty:String = this._xOrY == "x" ? "y" : "x";
				listItem[otherPositionProperty] = mask[otherPositionProperty];

				// The next item will need to know the new first visible item.
				this._firstVisibleItemIndex = startIndex;

				// If we have enough items to fill the entire viewable area (even when the first item is scrolling out), stop.
				if (pos - this.getItemPosition(startIndex + 1) > maskSize)
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
					this.markItemUnused(listItem, i);
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
		private function reset(resetScrollPosition:Boolean = true):void
		{
			this._unusedItems = {};
			this._sizeCache = [];
			this._indexes2Items = {};
			this._items2Indexes = new Dictionary(true);
			this._positionCache = [];
			this._initializedForModel = false;
			this._firstVisibleItemIndex = -1;

			if (resetScrollPosition)
				this._showItemAt(0, true);
			else
				this._showItemAt(Math.min(this.shownItem, this.dataProvider.length - 1));
			
			this.validationState.markPropertyAsInvalid(SCROLL_PROPERTIES);
		}

		/**
		 * 
		 */
		private function _showItemAt(index:int, invalidateScrollPosition:Boolean = false):void
		{
			this.shownItem = index;
			this.validationState.markPropertyAsInvalid(CONTENT_POSITION);
			if (invalidateScrollPosition)
				this.validationState.markPropertyAsInvalid(SCROLL_POSITION);
			this.invalidate();
		}

		/**
		 *	
		 */
		private function setScrollPosition(index:int):void
		{
			var capProp:String = this._orientation == "horizontal" ? "Horizontal" : "Vertical";
			this[this._orientation + "ScrollPosition"] = Math.min(index, this["max" + capProp + "ScrollPosition"]);
		}

		/**
		 * Updates the appearance of the scroll bars based on the combined size
		 * of the items in the list and the scroll policy.
		 */
		private function updateScrollBar():void
		{
			var mask:DisplayObject = this.getScrollMask();
			var scrollBar:IScrollBar = this.getScrollBar();
// TODO: Instead use this.maxHorizontalScrollPosition and horizontalPageSize
			if (scrollBar)
			{
				var scrollBarEnabled:Boolean;
				
				if (this.dataProvider)
				{
					// Determine the "selected index" when the last item is visible.
					var size:Number = 0;
					var i:int = this.dataProvider.length - 1;
					var maskSize:Number = mask[this._widthOrHeight];
					var spacing:Number = 0;
					
					do
					{
						size += this.getItemSize(i) + spacing;
						spacing = this.spacing;
						if (i > 0 && size + this.getItemSize(i - 1) + spacing < maskSize)
							i--;
						else
							break;
					}
					while (i >= 0);
					scrollBar.maxScrollPosition = Math.max(i, 0);
					scrollBar.pageSize = 1;

					var contentSize:Number = this.getItemSize(this._dataProvider.length - 1) + this.getItemPosition(this._dataProvider.length - 1);
					scrollBarEnabled = contentSize > mask[this._widthOrHeight];
				}
				else
				{
					scrollBarEnabled = false;
				}

				scrollBar.enabled = scrollBarEnabled;

				if (this[this._orientation + "ScrollPolicy"] == ScrollPolicy.AUTO)
					scrollBar.visible = scrollBar.enabled;
				else
					scrollBar.visible = this[this._orientation + "ScrollPolicy"] == ScrollPolicy.ON;
			}
		}

		/**
		 * 
		 */
		private function validate(event:Event):void
		{
			this.stage.removeEventListener(Event.RENDER, this.validate);
			this.removeEventListener(Event.ENTER_FRAME, this.validate);

			if (!this.validationState.hasInvalidProperty)
				return;

			var contentPositionIsInvalid:Boolean = this.validationState.propertyIsInvalid(CONTENT_POSITION);
			var scrollPositionIsInvalid:Boolean = this.validationState.propertyIsInvalid(SCROLL_POSITION);
			var scrollPropertiesAreInvalid:Boolean = this.validationState.propertyIsInvalid(SCROLL_PROPERTIES);
			var displayListIsInvalid:Boolean = this.validationState.propertyIsInvalid(DISPLAY_LIST);
			this.validationState.markAllPropertiesAsValid();

			if (scrollPropertiesAreInvalid)
				this.updateScrollBar();
			if (contentPositionIsInvalid)
				this.validateContentPosition();
			if (scrollPositionIsInvalid)
				this.validateScrollPosition();
			if (displayListIsInvalid)
				this.redraw();
			
			// If a property has become invalid during validation, revalidate.
			this.validate(null);

			// If a public showItemAt update is pending, assume it has been taken care of by this validation.
			if (this.showItemAtPending)
				this.showItemAtPending = false;
		}

		/**
		 * 
		 */
		private function validateContentPosition():void
		{
			var index:int = this.shownItem;

			// TODO: is this the right way to handle this situation?
			if (!this.dataProvider) return;

			if (!this.orientation)
				throw new Error("You must set the orientation on your ScrollableList");

			var newPos:Object = {x: this.__contentContainer.x, y: this.__contentContainer.y};

			if (this.dataProvider.length)
			{
				var mask:DisplayObject = this.getScrollMask();
				if (!isNaN(index))
				{
					if (this.dataProvider != null)
					{
						var target:Number = -this.getItemPosition(index);

						// Make sure we don't scroll "past" the content.
						var contentSize:Number = this.getItemPosition(this.dataProvider.length - 1) + this.getItemSize(this.dataProvider.length - 1);
						var maskSize:Number = mask[this._widthOrHeight];
						var minPosition:Number = Math.min(0, maskSize - contentSize);
						target = Math.max(minPosition, target);
						newPos[this._xOrY] = target;
					}
				}
			}

			this.moveContent(newPos.x, newPos.y);
			this.validationState.markPropertyAsInvalid(DISPLAY_LIST);
		}

		/**
		 * 
		 */
		private function validateScrollPosition():void
		{
			this.setScrollPosition(this.shownItem);
		}

	}
}