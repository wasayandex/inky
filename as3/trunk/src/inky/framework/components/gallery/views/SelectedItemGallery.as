﻿package inky.framework.components.gallery.views
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.loading.*;
	import inky.framework.components.gallery.events.*;
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



		public function SelectedItemGallery()
		{
			this.addEventListener(MouseEvent.CLICK, this._clickHandler);
		}
		private function _clickHandler(e:MouseEvent):void
		{
			this.model.selectItemAt((this.model.selectedItemIndex + 1) % this.model.selectedGroupData.items.length);
		}

		override protected function selectedItemChangeHandler():void
		{
			var data:GalleryItemModel = this.model.selectedItemData;
			if (data)
			{
				var loader:DisplayObject = this.loadManager.getItemLoader(data);
				this.addChild(loader);
				this.loadManager.loadItem(data);
			}
			else
			{
				// Clear it.
			}
		}




	}
}