﻿package inky.components.gallery.models
{
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.*;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.components.gallery.events.GalleryEvent;
	import inky.utils.EqualityUtil;
	import inky.utils.IEquatable;
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
		private var _selectedItem:Object;

		public function GalleryGroupModel()
		{
			this._items = new ArrayList();
			this._items.addEventListener(CollectionEvent.COLLECTION_CHANGE, this._collectionChangeHandler);
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


		public function get selectedItemModel():Object
		{
			var selectedItemModel:Object;
			for (var i:IIterator = this.items.iterator(); i.hasNext(); )
			{
				var item:Object = i.next();
				if (item.selected)
				{
					selectedItemModel = item;
					break;
				}
			}
			return selectedItemModel;
		}



		public function equals(obj:Object):Boolean
		{
			return obj == this;//EqualityUtil.propertiesAreEqual(this, obj);
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


		/**
		 *
		 */
		private function _collectionChangeHandler(e:CollectionEvent):void
		{
			var item:Object;
			switch (e.kind)
			{
				case CollectionEventKind.ADD:
				{
					for each (item in e.items)
					{
						item.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._itemPropertyChangeHandler, false, 0, true);
					}
					break;
				}
				case CollectionEventKind.REMOVE:
				{
					for each (item in e.items)
					{
						item.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._itemPropertyChangeHandler);
						break;
					}
				}
			}
		}


		/**
		 *
		 */
		private function _itemPropertyChangeHandler(e:PropertyChangeEvent):void
		{
			if (e.newValue && (e.property == "selected"))
			{
				var selectedItem:Object;
				for (var i:IIterator = this.items.iterator(); i.hasNext(); )
				{
					var item:Object = i.next();
					if (item == e.currentTarget)
					{
						if (!item.selected)
						{
							item.selected = true;
						}
						selectedItem = item;
					}
					else if (item.selected)
					{
						item.selected = false;
					}
					var selected:Boolean = item == e.currentTarget;
					if (selected != item.selected)
					{
						item.selected = selected;
					}
				}

				if (!EqualityUtil.objectsAreEqual(selectedItem, this._selectedItem))
				{
					this._selectedItem = selectedItem;
					this.dispatchEvent(new GalleryEvent(GalleryEvent.SELECTED_ITEM_CHANGE));
				}
			}
		}




	}
}