package inky.components.calendar.models 
{
	import flash.events.EventDispatcher;
	import inky.binding.utils.BindingUtil;
	import inky.components.calendar.events.CalendarEvent;

	
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
	 *	@since  2009.03.20
	 *
	 */
	dynamic public class BaseCalendarModel extends EventDispatcher
	{
		BindingUtil.setPropertyBindingEvents(BaseCalendarModel, 'selectedDate', [CalendarEvent.SELECTED_DATE_CHANGE]);

		private var _selectedDate:Date;




		//
		// accessors
		//


		/**
		 *	
		 */
		public function get selectedDate():Date
		{
			if (this._selectedDate)
				return new Date(this._selectedDate.fullYear, this._selectedDate.month, this._selectedDate.date); 
			else
				return null;
		}




		//
		// public methods
		//


		/**
		 *	
		 */	
		public function selectDate(date:Date):void
		{
			this._selectedDate = date;
			this.dispatchEvent(new CalendarEvent(CalendarEvent.SELECTED_DATE_CHANGE));
		}
	}	
}
