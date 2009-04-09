package inky.framework.components.calendar.models 
{
	import flash.events.EventDispatcher;
	import inky.framework.binding.utils.BindingUtil;
	import inky.framework.components.calendar.events.CalendarEvent;

	
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
			return this._selectedDate; 
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
