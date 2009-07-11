package inky.components.gallery.models
{
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.*;
	import inky.utils.IEquatable;
	import inky.utils.EqualityUtil;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
	dynamic public class GalleryItemModel extends EventDispatcher implements IEquatable
	{
		private var _group:GalleryGroupModel;
		private var _images:ISearchableList;
		private var _selected:Boolean;



		public function GalleryItemModel()
		{
			this._images = new ArrayList();
		}



		gallery_model function setGroup(group:GalleryGroupModel):void
		{
			this._group = group;
		}

		public function get images():ISearchableList
		{
			return this._images;
		}


		public function get group():GalleryGroupModel
		{
			return this._group;
		}



		public function equals(obj:Object):Boolean
		{
			return this == obj;
		}


		/**
		 *
		 *
		 *
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			if (value != this._selected)
			{
				var oldValue:Boolean = this._selected;
				this._selected = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, 'selected', oldValue, value));
			}
		}


	}
}