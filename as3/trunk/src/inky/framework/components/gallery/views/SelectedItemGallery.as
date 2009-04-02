﻿package inky.framework.components.gallery.views
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.loading.*;
	import inky.framework.components.gallery.events.*;
	import inky.framework.components.gallery.views.IGalleryItemView;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.*;
	import flash.net.URLRequest;


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
	public class SelectedItemGallery extends GallerySprite
	{
		private var _itemViews:Array;


		public function SelectedItemGallery()
		{
			this._init();
		}
		
		
		private function _init():void
		{
			this._itemViews = [];
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				if (child is IGalleryItemView)
				{
					this._itemViews.push(child);
				}
			}
			
this.addEventListener(MouseEvent.CLICK, this._clickHandler);
		}



private function _clickHandler(e:MouseEvent):void
{
	this.model.selectItemAt((this.model.selectedItemIndex + 1) % this.model.selectedGroupModel.items.length);
}


		override protected function selectedItemChangeHandler():void
		{
			var data:GalleryItemModel = this.model.selectedItemModel;
			if (data)
			{
				// Update the gallery item view(s)
				for each (var itemView:IGalleryItemView in this._itemViews)
				{
					itemView.model = data;
				}
			}
			else
			{
				// Clear it?
			}
		}




	}
}