package inky.components.map.models
{
	import flash.events.EventDispatcher;
	import inky.collections.ArrayList;
	import inky.binding.events.PropertyChangeEvent;

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
	}
}
