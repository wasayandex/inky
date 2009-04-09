package inky.framework.components.calendar.models 
{
	import inky.framework.collections.E4XHashMap;
	import inky.framework.collections.IMap;
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
		private var _eventModels:IMap;
		private var _monthModel:MonthModel;
		private var _selected:Boolean;
		
		
		/**
		 *
		 */
		public function get eventModels():IMap
		{
			return this._eventModel = this._eventModel || new E4XHashMap();
		}
		/**
		 * @private
		 */
		public function set eventModels(value:IMap):void
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
			var date:Date = eventModel.selectedDate;
			var key:String = new Date(date.fullYear, date.month, date.date).toString();
			this.eventModels.putItemAt(eventModel, key);

eventModel.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._eventModelPropertyChangeHandler);

			return eventModel;
		}
		

		/**
		 *	
		 */	
		public function getEventModel(date:Date):EventModel
		{
			var key:String = date.toString();
			var eventModel:EventModel;
			
		 	eventModel = EventModel(this.eventModels.getItemByKey(key));

			/*if (!eventModel)
			{
				eventModel = new EventModel();
				eventModel.dateModel = this;
				eventModel.selectDate(date);
				this.addEventModel(eventModel);
			}*/

			return eventModel;
		}

/**
 *	
 */
private function _eventModelPropertyChangeHandler(e:PropertyChangeEvent):void
{
	
}
		
		
	}
	
}
