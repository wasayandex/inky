﻿package inky.framework.components.gallery.models{	import inky.framework.collections.*;	import inky.framework.utils.IEquatable;	import inky.framework.components.gallery.events.*;	import inky.framework.components.gallery.collections.*;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.Loader;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.net.URLRequest;	import inky.framework.binding.utils.*;	/**	 *	 *  ..	 *		 * 	@langversion ActionScript 3	 *	@playerversion Flash 9.0.0	 *	 *	@author Eric Eldredge	 *	@author Rich Perez	 *	@author Matthew Tretter	 *	@since  2009.01.12	 *	 */	dynamic public class GalleryModel extends EventDispatcher	{		// Mark bindable properties.		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedItemIndex', [GalleryEvent.SELECTED_ITEM_CHANGE]);		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedGroupName', [GalleryEvent.SELECTED_GROUP_CHANGE]);		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedItemData', [GalleryEvent.SELECTED_ITEM_CHANGE]);		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedGroupData', [GalleryEvent.SELECTED_GROUP_CHANGE]);		private var _selectedGroupData:GalleryGroupModel;		private var _selectedItemData:GalleryItemModel;		private var _groups:GalleryGroupMap;		private var _name:String;		//		// accessors		//		/**		 *		 *			 */		public function get name():String		{			return this._name;		}		/**		 * @private		 */		public function set name(value:String):void		{			this._name = value;		}		/**		 *		 *			 */		public function get groups():GalleryGroupMap		{			return this._groups;		}		/**		 * @private		 */		public function set groups(value:GalleryGroupMap):void		{			this._groups = value;//! clear selection		}		/**		 *		 *			 */		public function get selectedGroupName():String		{			return this._selectedGroupData ? this._selectedGroupData.name : null;		}		/**		 *		 *			 */		public function get selectedGroupData():GalleryGroupModel		{			return this._selectedGroupData;		}		/**		 *		 *			 */		public function get selectedItemData():GalleryItemModel		{			return this._selectedItemData;		}		public function get selectedItemIndex():int		{			return this._selectedItemData ? this._selectedItemData.group.items.getItemIndex(this._selectedItemData) : -1;		}		//		// public methods		//		/**		 * @inheritDoc		 */		public function selectGroupByName(name:String):void		{			if (!this._groups || !this._groups.containsKey(name))			{				throw new ArgumentError("There is no gallery group named " + name);			}			else if (this.selectedGroupName != name)			{				this._selectedGroupData = this._groups.getItemByKey(name) as GalleryGroupModel;				this.dispatchEvent(new GalleryEvent(GalleryEvent.SELECTED_GROUP_CHANGE));			}		}		/**		 * @inheritDoc		 */		public function selectItemAt(index:uint):void		{			if (!this._groups || !this._selectedGroupData)			{				throw new ArgumentError("You cannot select an item unless you've first selected a group");			}			else			{				if (index < -1 || index >= this.selectedGroupData.items.length)				{					throw new RangeError("Index " + index + " out of bounds.");				}				else				{					this._selectedItemData = this.selectedGroupData.items.getItemAt(index) as GalleryItemModel;					this.dispatchEvent(new GalleryEvent(GalleryEvent.SELECTED_ITEM_CHANGE));				}			}		}	}}