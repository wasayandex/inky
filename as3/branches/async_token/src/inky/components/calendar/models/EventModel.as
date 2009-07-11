package inky.components.calendar.models 
{
	import inky.components.calendar.models.BaseCalendarModel;
	import inky.components.calendar.models.DateModel;
	import inky.binding.events.PropertyChangeEvent;

	
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
	 *	@since  2009.03.19
	 *
	 */
	dynamic public class EventModel extends BaseCalendarModel
	{
		private var _dateModel:DateModel;


		/**
		 *
		 */
		public function get dateModel():DateModel
		{
			return this._dateModel;
		}
		/**
		 * @private
		 */
		public function set dateModel(value:DateModel):void
		{
			this._dateModel = value;
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
			if (value != this._selected)
			{
				var oldValue:Boolean = this._selected;
				this._selected = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, 'selected', oldValue, value));
			}
		}

	}
	
}
