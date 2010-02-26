package inky.components.map.models
{
	import flash.events.EventDispatcher;
	import inky.collections.ArrayList;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.*;
	import inky.components.map.events.MapEvent;

	/**
	 *
	 *  ..
	 *
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.19
	 *
	 */
	dynamic public class DocumentModel extends EventDispatcher
	{
		private var _categories:ArrayList;
		private var _placemarks:ArrayList;
		private var _selected:Boolean;
		private var _selectedPlacemark:Object;

		/**
		 *
		 */
		public function DocumentModel()
		{
			this._categories = new ArrayList();
			this._placemarks = new ArrayList();
			this._placemarks.addEventListener(CollectionEvent.COLLECTION_CHANGE, this._collectionChangeHandler);
		}

		//
		// accessors
		//

		public function get categories():ArrayList
		{
			return this._categories;
		}
		public function get placemarks():ArrayList
		{
			return this._placemarks;
		}

		/**
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
			var oldValue:Boolean = this._selected;
			if (value != this._selected)
			{
				this._selected = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, value));
			}
		}

		//
		// private functions
		//

		private function _collectionChangeHandler(event:CollectionEvent):void
		{
			var placemark:Object;
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
				{
					for each (placemark in this.placemarks.toArray())
						placemark.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._itemPropertyChangeHandler);
					break;
				}
				case CollectionEventKind.REMOVE:
				{
					for each (placemark in this.placemarks.toArray())
						placemark.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._itemPropertyChangeHandler);
					break;
				}
			}
		}

		/**
		 *
		 */
		private function _itemPropertyChangeHandler(event:PropertyChangeEvent):void
		{
			if (event.newValue && (event.property == "selected"))
			{
				if (this._selectedPlacemark) this._selectedPlacemark.selected = false;
				this._selectedPlacemark = event.currentTarget;
				this._selectedPlacemark.selected = true;

				var id:Object = this.placemarks.getItemIndex(this._selectedPlacemark);
				this.dispatchEvent(new MapEvent(MapEvent.SELECTED_PLACEMARK_CHANGE, false, true, id));
			}
		}

	}
}
