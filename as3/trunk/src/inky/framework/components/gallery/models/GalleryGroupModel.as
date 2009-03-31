package inky.framework.components.gallery.models
{
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.collections.*;
	import inky.framework.utils.EqualityUtil;
	import inky.framework.utils.IEquatable;
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
	dynamic public class GalleryGroupModel extends EventDispatcher implements IEquatable
	{
		private var _name:String;
		private var _items:ISearchableList;
		private var _selected:Boolean;

		public function GalleryGroupModel()
		{
			this._items = new ArrayList();
		}


		/**
		 *
		 *
		 *
		 */
		public function get name():String
		{
			return this._name;
		}
		/**
		 * @private
		 */
		public function set name(name:String):void
		{
			this._name = name;
		}


		/**
		 *
		 *
		 */	
		public function get items():ISearchableList
		{
			return this._items;
		}





		public function equals(obj:Object):Boolean
		{
			return EqualityUtil.propertiesAreEqual(this, obj);
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