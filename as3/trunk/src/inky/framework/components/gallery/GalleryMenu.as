package com.hzdg.citypalms.gallery.controls
{
	import caurina.transitions.Tweener;
	import com.exanimo.events.DataChangeEvent;
	import com.exanimo.events.DataChangeType;
	import com.exanimo.layout.*;
	import com.exanimo.gallery.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import inky.framework.actions.*;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.12
	 *
	 */
	public class SlideshowGalleryMenu extends GallerySprite
	{
		private var _actionQueue:ActionSequence;
		private var _captionField:TextField;
		private var _layout:GridLayout;
		private var _thumbnailsMask:Sprite;
		private var _thumbnailsContainer:Sprite;
		private var _nextButton:Sprite;
		private var _nextButton2:Sprite;
		private var _previousButton:Sprite;
		private var _previousButton2:Sprite;
		private var _selectedItemIndex:int;
		

		/**
		 *
		 *	
		 */
		public function SlideshowGalleryMenu()
		{
			this._init();
//this.minus.addEventListener('click', this._minus);
		}
/*private function _minus(e:Event):void
{
	this.controller['selectGroupByName']('0');
}*/




		//
		// accessors
		//


		/**
		 * @private
		 */
		override public function set controller(controller:IGalleryController):void
		{
			if (this.controller)
			{
				this.controller.removeEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._selectedItemChangeHandler);
				this.controller.removeEventListener(DataChangeEvent.DATA_CHANGE, this._dataChangeHandler);
			}
			if (controller)
			{
				controller.addEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._selectedItemChangeHandler);
				controller.addEventListener(DataChangeEvent.DATA_CHANGE, this._dataChangeHandler, false, 0, true);
			}
			super.controller = controller;
			this._controllerChangeHandler();
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public function next():void
		{
			var index:int = (this.selectedItemIndex + 1) % this.numItems;
			this.selectItemAt(index);
		}


		/**
		 *
		 *	
		 */
		public function previous():void
		{
			var index:int = (this.selectedItemIndex - 1 + this.numItems) % this.numItems;
			this.selectItemAt(index);
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _addItemNowAt(info:Object, index:int):void
		{
			var thumbnail:IGalleryItem = new SlideshowGalleryThumbnail();
			thumbnail.source = this.controller.getItemLoader(info.source);
			thumbnail.addEventListener(MouseEvent.CLICK, this._thumbnailClickHandler);
			this._thumbnailsContainer.addChild(thumbnail as DisplayObject);
			this.controller.loadItem(info.source);
			if (index == this._selectedItemIndex)
			{
				if (thumbnail is ISelectableGalleryItem)
				{
					ISelectableGalleryItem(thumbnail).selected = true;
				}
			}
		}


		/**
		 *
		 *	
		 */
		private function _addItemsAt(items:Array, startIndex:int):void
		{
			var i:int;
			var a:ActionGroup = new ActionGroup();
			for (i = 0; i < items.length; i++)
			{
				a.addItem(new FunctionAction(this._addItemNowAt, [items[i], i + startIndex]));
			}
			this._actionQueue.addItem(a);
			this._actionQueue.addItem(new FunctionAction(this._setup));					
			this._actionQueue.start();

			var g:Graphics = this._thumbnailsContainer.graphics;
			g.clear();
			g.beginFill(0xffffff, 0.5);
			for (i = 0; i < 18; i++)
			{
				g.drawRect(i * 46, 0, 45, 45);
			}
			g.endFill();
		}


		/**
		 * 
		 */
		private function _controllerChangeHandler():void
		{
// TODO: Remove the current thumbnails.
			if (this.controller && (this.numItems > 0))
			{
				for (var i:int = 0; i < this.numItems; i++)
				{
					var info:Object = this.controller.dataProvider.getItemAt(i);
					this._addItemNowAt(info, i);
				}
				this._layout.layoutContainer(this._thumbnailsContainer);
			}
		}


		/**
		 *
		 *	
		 */
		private function _dataChangeHandler(e:DataChangeEvent):void
		{
			switch (e.changeType)
			{
				case DataChangeType.ADD:

					this._addItemsAt(e.items, e.startIndex);

					break;
				case DataChangeType.REMOVE:
				case DataChangeType.REMOVE_ALL:

// TODO: if REMOVE_ALL, clear out the queue before adding action.
					this._removeThumbnails(e.startIndex, e.endIndex);

					break;
				case DataChangeType.CHANGE:
				case DataChangeType.INVALIDATE:
				case DataChangeType.INVALIDATE_ALL:
				case DataChangeType.REPLACE:
				case DataChangeType.SORT:
					break;
			}
		}


		/**
		 *
		 *	
		 */
		private function _init():void
		{
			this._actionQueue = new ActionSequence();

			this._layout = new GridLayout();
			this._layout.horizontalSpacing = 1;

			this._thumbnailsMask = this.getChildByName('thumbnailsMask') as Sprite;
			
			var s:Sprite = new Sprite();
			this.addChild(s);
			s.x = this._thumbnailsMask.x;
			s.y = this._thumbnailsMask.y;
			s.mask = this._thumbnailsMask;
			this._thumbnailsContainer = s;
			
			this._nextButton = this.getChildByName('nextButton') as Sprite;
			this._nextButton.addEventListener(MouseEvent.CLICK, this._nextButtonClickHandler);

			this._previousButton = this.getChildByName('previousButton') as Sprite;
			this._previousButton.addEventListener(MouseEvent.CLICK, this._previousButtonClickHandler);
			
			this._selectedItemIndex = -1;
		}


		/**
		 *
		 *	
		 */
		private function _nextButtonClickHandler(e:MouseEvent):void
		{
			this.next();
		}


		/**
		 *
		 *	
		 */
		private function _previousButtonClickHandler(e:MouseEvent):void
		{
			this.previous();
		}


		/**
		 *
		 *	
		 */
		private function _removeThumbnails(startIndex:int, endIndex:int):void
		{
			var g:ActionGroup = new ActionGroup();
			var t:TweenerAction;
			var f:FunctionAction;
// TODO: Only animate out visible thumbs.
			for (var i:int = startIndex; i <= endIndex; i++)
			{
				t = new TweenerAction({alpha: 0, time: 0.5, delay: 0.1 * (i - startIndex)});
				f = new FunctionAction(this._setTweenTarget, [t, i]);
				g.addItem(f);
				g.addItem(t);
			}

			this._actionQueue.addItem(g);
			this._actionQueue.addItem(new FunctionAction(this._removeThumbnailsNow, [startIndex, endIndex]));
			this._actionQueue.addItem(new FunctionAction(this._setup));					
			this._actionQueue.start();
		}


		/**
		 *
		 *	
		 */
		private function _removeThumbnailsNow(startIndex:int, endIndex:int):void
		{
			for (var i:int = endIndex; i >= startIndex; i--)
			{
				this._thumbnailsContainer.removeChildAt(i);
			}
		}


		/**
		 *
		 *	
		 */
		private function _selectedItemChangeHandler(e:GalleryEvent):void
		{
			var index:int = e.currentTarget.selectedItemIndex;
			if (index == -1)
			{
				this._selectedItemIndex = index;
			}
			else if (index != this._selectedItemIndex)
			{
				if (this._selectedItemIndex != -1)
				{
					var oldThumbnail:IGalleryItem = this._thumbnailsContainer.getChildAt(this._selectedItemIndex) as IGalleryItem;
					if (oldThumbnail is ISelectableGalleryItem)
					{
						ISelectableGalleryItem(oldThumbnail).selected = false;
					}
				}

				var thumbnail:IGalleryItem = this._thumbnailsContainer.getChildAt(index) as IGalleryItem;
				if (thumbnail is ISelectableGalleryItem)
				{
					ISelectableGalleryItem(thumbnail).selected = true;
				}
				this._selectedItemIndex = index;

				// Move the thumbnails container to show the seleceted thumbnail.
				var bounds:Rectangle = thumbnail.getBounds(this._thumbnailsContainer);
				var max:Number = 0;
				var min:Number = Math.min(max, this._thumbnailsMask.width - this._thumbnailsContainer.width);
				var ideal:Number = this._thumbnailsMask.width / 2 - bounds.x - bounds.width / 2;
				var x:Number = Math.max(min, Math.min(max, ideal));
				Tweener.addTween(this._thumbnailsContainer, {x: this._thumbnailsMask.x + x, time: 1});
			}
		}


		/**
		 *
		 *	
		 */
		private function _setTweenTarget(t:TweenerAction, i:int):void
		{
			t.target = this._thumbnailsContainer.getChildAt(i);
			t.onCompleteParams = [t.target];
		}


		/**
		 *
		 *	Lays out the grid based on the elements currently present.
		 *	
		 */
		private function _setup():void
		{
// If the thumbnails are not behind the mask, move the thumbnailsContainer
this._thumbnailsContainer.x = this._thumbnailsMask.x;
			this._layout.layoutContainer(this._thumbnailsContainer);
		}


		/**
		 *
		 *	
		 */
		private function _thumbnailClickHandler(e:MouseEvent):void
		{
			var index:int = this._thumbnailsContainer.getChildIndex(e.currentTarget as DisplayObject);
			this.selectItemAt(index);
		}




	}
}