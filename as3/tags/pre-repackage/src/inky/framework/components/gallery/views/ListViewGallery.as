package inky.framework.components.gallery.views
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.loading.*;
	import inky.framework.components.gallery.events.*;
	import inky.framework.components.listViews.IListView;
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
	public class ListViewGallery extends GallerySprite
	{
		private var _listView:IListView;


		public function ListViewGallery()
		{
			this._init();
		}



		private function _init():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:DisplayObject = this.getChildAt(i);

				if (child is IListView)
				{
					this._listView = child as IListView;
					break;
				}
			}
		}



		public function get listView():IListView
		{
			return this._listView;
		}


		public function set galleryItemViewClass(value:Class):void
		{
			this._listView.itemViewClass = value;
		}


		override protected function selectedGroupChanged():void
		{
if (!this.model) return;			
			var data:GalleryGroupModel;
			if (this.model && (data = this.model.selectedGroupModel))
			{
				if (!this._listView.itemViewClass)
				{
					throw new Error("galleryItemViewClass is not set!");
				}
				this._listView.model = this.model.selectedGroupModel.items;
			}
			else
			{
				// Clear it?
			}
		}


		override protected function selectedItemChanged():void
		{
if (!this.model) return;
			var index:uint;
			if (this.model && ((index = this.model.selectedItemIndex) >= 0))
			{
				this._listView.showItemAt(this.model.selectedItemIndex);
				super.selectedItemChanged();
			}
			else
			{
				// Clear it?
			}
		}


	}
}