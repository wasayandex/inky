﻿package inky.framework.components.gallery.views{	import inky.framework.components.gallery.*;	import inky.framework.components.gallery.models.*;	import inky.framework.components.gallery.loading.*;	import inky.framework.components.gallery.events.*;	import inky.framework.components.listViews.scrollableListView.ScrollableListView;	import inky.framework.components.listViews.IListView;	import flash.display.*;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.filters.BlurFilter;	import flash.filters.BitmapFilterQuality;	import flash.geom.*;	import flash.net.URLRequest;	/**	 *	 *  ..	 *		 * 	@langversion ActionScript 3	 *	@playerversion Flash 9.0.0	 *	 *	@author Eric Eldredge	 *	@author Rich Perez	 *	@author Matthew Tretter	 *	@since  2009.01.12	 *	 */	public class ListViewGallery extends GallerySprite	{		private var _listView:IListView;		public function ListViewGallery()		{			this._init();		}		private function _init():void		{			for (var i:int = 0; i < this.numChildren; i++)			{				var child:DisplayObject = this.getChildAt(i);				if (child is IListView)				{					this._listView = child as IListView;					break;				}			}		}		public function set galleryItemViewClass(value:Class):void		{			this._listView.listItemViewClass = value;		}		override protected function selectedGroupChangeHandler():void		{			if (!this._listView.listItemViewClass)			{				throw new Error("galleryItemViewClass is not set!");			}			this._listView.model = this.model.selectedGroupData.items;		}/*		override protected function selectedItemChangeHandler():void		{			var data:GalleryItemModel = this.model.selectedItemData;			if (data)			{trace(data);				var loader:DisplayObject = this.loadManager.getItemLoader(data);				this.addChild(loader);				this.loadManager.loadItem(data);							}			else			{				// Clear it.trace("clear");			}		}*/	}}