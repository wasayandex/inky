package inky.framework.components.gallery.models
{
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.collections.*;
	import inky.framework.utils.IEquatable;
	import inky.framework.utils.EqualityUtil;
	import inky.framework.components.gallery.models.*;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import inky.framework.loading.loaders.IAssetLoader;
	import inky.framework.loading.loaders.ImageLoader;


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
	dynamic public class GalleryImageModel extends EventDispatcher implements IEquatable
	{
		private var _item:GalleryItemModel;
		private var _loader:IAssetLoader;
		private var _source:String;


		public function get item():GalleryItemModel
		{
			return this._item;
		}



		public function equals(obj:Object):Boolean
		{
			return EqualityUtil.propertiesAreEqual(this, obj);
		}


		gallery_model function setItem(item:GalleryItemModel):void
		{
			this._item = item;
		}




		/**
		 *
		 *
		 *
		 */
		public function get loader():IAssetLoader
		{
			if (!this._loader)
			{
				this._loader = new ImageLoader();
				this._loader.source = this.source;
			}
			return this._loader;
		}


		/**
		 *
		 *
		 *
		 */
		public function get source():String
		{
			return this._source;
		}
		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			this._source = value;
		}


	}
}