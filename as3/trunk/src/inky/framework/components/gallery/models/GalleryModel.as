package inky.framework.components.gallery.models
{
	import inky.framework.collections.*;
	import inky.framework.utils.IEquatable;
	import inky.framework.components.gallery.events.*;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import inky.framework.binding.utils.*;


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
	dynamic public class GalleryModel extends EventDispatcher
	{
		// Mark bindable properties.
		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedItemIndex', [GalleryEvent.SELECTED_ITEM_CHANGE]);
		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedGroupName', [GalleryEvent.SELECTED_GROUP_CHANGE]);
		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedItemModel', [GalleryEvent.SELECTED_ITEM_CHANGE]);
		BindingUtil.setPropertyBindingEvents(GalleryModel, 'selectedGroupData', [GalleryEvent.SELECTED_GROUP_CHANGE]);


		private var _selectedGroupData:GalleryGroupModel;
		private var _selectedItemModel:GalleryItemModel;
		private var _groups:IMap;
		private var _name:String;




		//
		// accessors
		//


		/**
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
		public function set name(value:String):void
		{
			this._name = value;
		}



		/**
		 *
		 *	
		 */
		public function get groups():IMap
		{
			return this._groups;
		}
		/**
		 * @private
		 */
		public function set groups(value:IMap):void
		{
			this._groups = value;
//! clear selection
		}


		/**
		 *
		 *	
		 */
		public function get selectedGroupName():String
		{
			return this._selectedGroupData ? this._selectedGroupData.name : null;
		}


		/**
		 *
		 *	
		 */
		public function get selectedGroupData():GalleryGroupModel
		{
			return this._selectedGroupData;
		}



		/**
		 *
		 *	
		 */
		public function get selectedItemModel():GalleryItemModel
		{
			return this._selectedItemModel;
		}


		public function get selectedItemIndex():int
		{
			return this._selectedItemModel ? this._selectedItemModel.group.items.getItemIndex(this._selectedItemModel) : -1;
		}





		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function selectGroupByName(name:String):void
		{
if (name == null)
{
	trace("NULL"); return;
}
			if (!this._groups || !this._groups.containsKey(name))
			{
				throw new ArgumentError("There is no gallery group named " + name);
			}
			else if (this.selectedGroupName != name)
			{
				var newData:GalleryGroupModel = this._groups.getItemByKey(name) as GalleryGroupModel;
				if (!newData.equals(this.selectedGroupData))
				{
					var oldData:GalleryGroupModel = this._selectedGroupData;
					this._selectedGroupData = newData;
					if (oldData)
					{
						oldData.selected = false;
					}
					newData.selected = true;
					this.dispatchEvent(new GalleryEvent(GalleryEvent.SELECTED_GROUP_CHANGE));
				}
			}
		}


		/**
		 * @inheritDoc
		 */
		public function selectItemAt(index:uint):void
		{
			if (!this._groups || !this._selectedGroupData)
			{
				throw new ArgumentError("You cannot select an item unless you've first selected a group");
			}
			else
			{
				if (index < -1 || index >= this.selectedGroupData.items.length)
				{
					throw new RangeError("Index " + index + " out of bounds.");
				}
				else
				{
					var newData:GalleryItemModel = this.selectedGroupData.items.getItemAt(index) as GalleryItemModel;
					if (!newData.equals(this.selectedItemModel))
					{
						var oldData:GalleryItemModel = this.selectedItemModel;
						this._selectedItemModel = newData;
						if (oldData)
						{
							oldData.selected = false;
						}
						newData.selected = true;
						this.dispatchEvent(new GalleryEvent(GalleryEvent.SELECTED_ITEM_CHANGE));
					}
				}
			}
		}




	}
}