﻿package inky.framework.components.gallery.data{	import inky.framework.collections.*;	import inky.framework.utils.IEquatable;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.Loader;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.net.URLRequest;	/**	 *	 *  ..	 *		 * 	@langversion ActionScript 3	 *	@playerversion Flash 9.0.0	 *	 *	@author Eric Eldredge	 *	@author Rich Perez	 *	@author Matthew Tretter	 *	@since  2009.01.12	 *	 */	dynamic public class GalleryItemData	{		private var _group:GalleryGroupData;				public function get group():GalleryGroupData		{			return this._group;		}		public function set group(value:GalleryGroupData):void		{			this._group = value;		}	}}