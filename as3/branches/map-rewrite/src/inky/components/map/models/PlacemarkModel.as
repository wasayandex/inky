package inky.components.map.models
{
	import flash.events.EventDispatcher;
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
	dynamic public class PlacemarkModel extends EventDispatcher
	{
		private var _point:Object;
		private var _selected:Boolean;
		private var _snippet:Object;

		/**
		 *
		 */
		public function PlacemarkModel()
		{
		}

		/**
		 *
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		public function set selected(value:Boolean):void
		{
			var oldValue:Boolean = this._selected;
			if (value != this._selected)
			{
				this._selected = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, value));
			}
		}

		/**
		*	Gets/Sets the point of where the Placemark should be position. Currently, supports (x, y) coordinantes.
		*
		*/
		public function get point():Object
		{
			return this._point;
		}
		public function set point(value:Object):void
		{
			this._point = value;
		}
	}
}
