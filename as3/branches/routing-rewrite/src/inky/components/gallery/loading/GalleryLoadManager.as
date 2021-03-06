﻿package inky.components.gallery.loading
{
	import inky.components.gallery.*;
	import inky.components.gallery.models.*;
	import inky.components.gallery.loading.*;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;


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
	public class GalleryLoadManager extends EventDispatcher implements IGalleryLoadManager
	{
		private static var _loaders:Dictionary = new Dictionary(true);
		
		
		public function GalleryLoadManager():void
		{
			this._init();
		}
		
		private function _init():void
		{
			GalleryLoadManager._loaders[this] = {};
		}



		public function getItemLoaderInfo(data:GalleryItemModel):IEventDispatcher
		{
			if (!data)
			{
				throw new ArgumentError();
			}
			var ldr:Loader = this._getItemLoader(data);
			return ldr ? ldr.contentLoaderInfo : null;
		}


		public function getItemLoader(data:GalleryItemModel):DisplayObject
		{
			return this._getItemLoader(data);
		}
			
		private function _getItemLoader(data:GalleryItemModel):Loader
		{
// FIXME: use data (not source) as key and match using .equals
			for each (var o:Object in GalleryLoadManager._loaders)
			{
				for (var prop:Object in o)
				{
					if (prop == data.source)
					{
						return o[prop];
					}
				}
			}

			// Loader not found. Create one.
			var ldr:Loader = new Loader();
			GalleryLoadManager._loaders[this][data.source] = ldr;
			return ldr;
		}

		public function loadItem(data:GalleryItemModel):void
		{
trace(data.images.getItemAt(0) + "\t" + data.images.getItemAt(0).source);
			/*var ldr:Loader = this.getItemLoader(data) as Loader;
			ldr.load(new URLRequest(data.source));*/
		}









	}
}