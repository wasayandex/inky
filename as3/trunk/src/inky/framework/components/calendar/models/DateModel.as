package inky.framework.components.calendar.models 
{
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.ICollection;
	import inky.framework.components.calendar.models.BaseCalendarModel;
	import inky.framework.components.calendar.models.EventModel;
	import inky.framework.components.calendar.models.MonthModel;
	import inky.framework.binding.events.PropertyChangeEvent;

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
	 *	@since  2009.03.18
	 *
	 */
	dynamic public class DateModel extends BaseCalendarModel
	{
		private var _eventModels:ICollection;
		private var _monthModel:MonthModel;
		private var _selected:Boolean;
		
		/**
		 *
		 */
		public function get eventModels():ICollection
		{
			return this._eventModel = this._eventModel || new ArrayList();
		}
		/**
		 * @private
		 */
		public function set eventModels(value:ICollection):void
		{
			this._eventModels = value;
		}
		

		/**
		 *
		 */
		public function get monthModel():MonthModel
		{
			return this._monthModel;
		}
		/**
		 * @private
		 */
		public function set monthModel(value:MonthModel):void
		{
			this._monthModel = value;
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
		

		//
		// public methods
		//

		
		/**
		 *	
		 */
		public function addEventModel(eventModel:EventModel):EventModel
		{
			this.eventModels.addItem(eventModel);
			return eventModel;
		}
		



	}
	
}
