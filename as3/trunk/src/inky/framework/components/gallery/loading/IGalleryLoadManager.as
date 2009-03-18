package inky.framework.components.gallery.loading
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
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
	public interface IGalleryLoadManager
	{
		function getItemLoaderInfo(data:GalleryItemData):IEventDispatcher;
		function getItemLoader(data:GalleryItemData):DisplayObject;
		function loadItem(data:GalleryItemData):void;
	}
}