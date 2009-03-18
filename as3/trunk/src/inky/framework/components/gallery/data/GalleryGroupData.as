package com.exanimo.gallery.data
{
	import com.exanimo.collections.*;
	import com.exanimo.data.DynamicDTO;
	import com.exanimo.utils.IEquatable;
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
	dynamic public class GalleryGroupData
	{
		private var _items:IList;


		/**
		 *
		 *
		 */	
		public function get items():IList
		{
			if (!this._items)
			{
				this._items = new ArrayList();
			}
			return this._items;
		}
		/**
		 * @private
		 */
		public function set items(items:IList):void
		{
			this._items = items;
		}


	}
}