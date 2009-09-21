package inky.components.calendar.models 
{
	import inky.components.calendar.models.BaseCalendarModel;
	import inky.components.calendar.models.DateModel;
	import inky.collections.IMap;
	import inky.collections.E4XHashMap;
	import inky.components.calendar.events.CalendarEvent;
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
	 *	@since  2009.03.18
	 *
	 */
	dynamic public class MonthModel extends BaseCalendarModel
	{
		private var _dateModels:IMap;


		/**
		 *
		 */
		public function get dateModels():IMap
		{
			return this._dateModels = this._dateModels || new E4XHashMap();
		}
		/**
		 * @private
		 */
		public function set dateModels(value:IMap):void
		{
			this._dateModels = value;
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 *	
		 */
		public function addDateModel(dateModel:DateModel):DateModel
		{
			var date:Date = dateModel.selectedDate;
			var key:String = new Date(date.fullYear, date.month, date.date).toString();
			this.dateModels.putItemAt(dateModel, key);
			dateModel.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._dateModelPropertyChangeHandler);
			return dateModel;
		}


		/**
		 *	
		 */	
		public function getDateModel(date:Date):DateModel
		{
			var key:String = new Date(date.fullYear, date.month, date.date).toString();
			var dateModel:DateModel;
		 	dateModel = DateModel(this.dateModels.getItemByKey(key));
			if (!dateModel)
			{
				dateModel = new DateModel();
				dateModel.monthModel = this;
				dateModel.selectDate(date);
				this.addDateModel(dateModel);
			}
			return dateModel;
		}




		//
		// private methods
		//

		
		/**
		 *	
		 */
		private function _dateModelPropertyChangeHandler(e:PropertyChangeEvent):void
		{
			if (e.property == 'selected' && (this.selectedDate.toString() != e.target.selectedDate.toString()))
			{
				this.selectDate(e.target.selectedDate);
			}
		}


	}
	
}
