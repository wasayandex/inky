﻿package inky.framework.components.listViews.scrollableListView{	import inky.framework.collections.*;	import inky.framework.components.scrollPane.views.BaseScrollPane;	import inky.framework.components.scrollBar.ScrollPolicy;	import inky.framework.components.listViews.IListView;	import inky.framework.components.listViews.IListItemView;	import inky.framework.components.scrollPane.views.IScrollPane;	import inky.framework.controls.*;	import inky.framework.display.IDisplayObject;	import inky.framework.components.scrollBar.events.ScrollEvent;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;	import flash.geom.Rectangle;	/**	 *	 *  		 * @author Eric Eldredge	 * @author Rich Perez	 * @author Matthew Tretter	 *	 * @langversion ActionScript 3	 * @playerversion Flash 9.0.0	 *		 */	public class ScrollableListView extends BaseScrollPane implements IListView	{		private var __contentContainer:DisplayObjectContainer;		private var _defaultListItemHeight:Number;		private var _dataProvider:IList;		private var _listItems:Object;		private var _listItemViewClass:Class;		private var _numItemsInitiallyVisible:uint;		public function ScrollableListView()		{			this._init();		}		private function _init():void		{			this._defaultListItemHeight = 0;			this._listItems = {};			this.__contentContainer = this.getContentContainer();//			this.source = this.getContentContainer();			this.verticalLineScrollSize = 1;		}		/**		 * @inheritDoc		 */		public function get dataProvider():IList		{			return this._dataProvider;		}		/**		 * @private		 */		public function set dataProvider(dataProvider:IList):void		{			this._dataProvider = dataProvider;			this._setContent();		}		/**		 * @inheritDoc		 */		public function get listItemViewClass():Class		{			return this._listItemViewClass;		}		/**		 * @private		 */		public function set listItemViewClass(listItemViewClass:Class):void		{			this._listItemViewClass = listItemViewClass;		}		private function _setContent():void		{			this.addEventListener(Event.ENTER_FRAME, this._setContentNow);		}						private function _setContentNow(e:Event):void		{			e.currentTarget.removeEventListener(e.type, arguments.callee);			this._clearContent();			if (this._dataProvider == null) return;			if (this._listItemViewClass == null)			{				throw new Error("listItemViewClass is not set!");			}			this.verticalScrollBar.minScrollPosition = 0			this._updateContent(0, true);			this.update();		}		private function _clearContent():void		{			while (this.__contentContainer.numChildren)			{				this.__contentContainer.removeChildAt(0);			}		}		/**		 * @inheritDoc		 */			override public function update():void		{			if (dataProvider)			{				if (this.verticalScrollBar)				{					this.verticalScrollBar.maxScrollPosition = this.dataProvider.length - this._numItemsInitiallyVisible + 1;				}				if (this.horizontalScrollBar)				{				}			}		}		override protected function scrollHandler(e:ScrollEvent):void		{			var verticalPosition:Number = Math.round(this.verticalScrollPosition);			var x:Number = this.__contentContainer.x;			var y:Number = this.__contentContainer.y;			var mask:DisplayObject = this.getScrollMask();						if (!isNaN(verticalPosition))			{//!// this should happen after the conent is moved so that we can accurately determine if items are shown. but how can we move the content without knowing the things in it? (namely, their size)// You need to move the content to know which elements will still be within the mask.// But how do you know what to move it to without updating the content?				this._updateContent(verticalPosition);				/*var listItem:DisplayObject = this._listItems[verticalPosition];				var p:Point;				if (listItem)				{					// If the item exists in the list.					p = this.__contentContainer.globalToLocal(listItem.localToGlobal(new Point(0, 0)));					var bounds:Rectangle = this.__contentContainer.getBounds(this.__contentContainer);					y = Math.min(0, -Math.min(p.y - mask.y, bounds.height + bounds.y - mask.height));				}*/if (this.dataProvider != null)y = Math.min(0, -Math.min(this._defaultListItemHeight * verticalPosition, this._defaultListItemHeight * this.dataProvider.length - mask.height));			}			this.moveContent(x, y);		}private var _firstVisibleItemIndex:int;private function _updateContent(startIndex:int, firstTime:Boolean = false):void{	if (!firstTime && (startIndex == this._firstVisibleItemIndex))	{		// Already showing the correct units.		return;	}	var listItem:IListItemView;	var tmp:IListItemView;	var index:int = startIndex;	var roomForMore:Boolean = true;	var usedItems:Object = [];	var combinedHeight:Number = 0;	var mask:DisplayObject = this.getScrollMask();	var maskHeight:Number = mask.height;	var maskY:Number = mask.y;	while ((index < this.dataProvider.length) && (combinedHeight < maskHeight))	{//trace("LOOKING FOR VIEW FOR\t\t\t" + index);		listItem = this._listItems[index];				if (listItem == null)		{			// Find one to reuse			for (var j:int = 1; j < this.dataProvider.length; j++)			{				var k:int = (this.dataProvider.length - j + index + this.dataProvider.length) % this.dataProvider.length;				tmp = this._listItems[k];//trace('\t' + k + '?');				if (tmp != null)				{					var isUsed:Boolean = usedItems.indexOf(tmp) != -1;										if (!isUsed)					{						var p:Point = mask.globalToLocal(tmp.localToGlobal(new Point(0, 0)));						var bottom:Number = p.y + tmp.height;//						var isShowing:Boolean = (p.y + tmp.height > 0) && (p.y < maskHeight + maskY);var isShowing:Boolean = false;						if (!isShowing)						{//trace("\t\tREUSING\t" + k);							listItem = tmp;							delete this._listItems[k];							break;						}//else trace("\tCANT RESUSE\t" + k + "\tBC\tisShowing");					}//else trace("\tCANT RESUSE\t" + k + "\tBC\tisUsed");				}//else trace("\tCANT RESUSE\t" + k + "\tBC\t" + "null");			}					// If no item could be reused, make a new one.			if (listItem == null)			{//trace("\tCREATING\t" + index);				listItem = new this._listItemViewClass();				this.__contentContainer.addChild(listItem as DisplayObject);				this._defaultListItemHeight = listItem.height;			}						listItem.dataProvider = this.dataProvider.getItemAt(index);			this._listItems[index] = listItem;		}		usedItems.push(listItem);		combinedHeight += listItem.height;		listItem.y = this._defaultListItemHeight * index;		index++;	}	var contentHeight:Number = listItem.y + listItem.height;	this.verticalScrollBar.enabled = this.__contentContainer.height > mask.height;	if (this.verticalScrollPolicy == ScrollPolicy.AUTO)	{		this.verticalScrollBar.visible = this.verticalScrollBar.enabled;	}	else	{		this.verticalScrollBar.visible = this.verticalScrollPolicy == ScrollPolicy.ON;	}	if (firstTime)	{		var numItemsInitiallyVisible = index - this.verticalScrollPosition		this.verticalScrollBar.pageSize = numItemsInitiallyVisible;		this.verticalPageScrollSize = numItemsInitiallyVisible - 1;		this._numItemsInitiallyVisible = numItemsInitiallyVisible;	}		this._firstVisibleItemIndex = startIndex;}		protected function updateContent():void		{//			this._updateContent();		}	}}