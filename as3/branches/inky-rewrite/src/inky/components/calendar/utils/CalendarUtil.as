package inky.components.calendar.utils 
{

	
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
	public class CalendarUtil 
	{

		/**
		 *	
		 */
		public function CalendarUtil()
		{
			throw new Error('CalendarUtil contains static utility methods and cannot be instantialized.');
		}
		
		
		/**
		 *	
		 */
		public static function getNumDaysInMonth(date:Date):uint 
		{
			return new Date(date.getFullYear(), (date.getMonth() % 11) + 1, 0).date;
		}
		
		
		/**
		 *	
		 */
		public static function getWeekOfMonth(date:Date):uint
		{
			// TODO: this assumes the calendar week starts on saturday.
			// Make it possible to ajust the start day (via a startDay parameter?).
			var firstDayOfMonth = new Date(date.fullYear, date.month, 1);
			return Math.floor((date.date + firstDayOfMonth.day - 1) / 7);// % 2;
		}




	}
	
}
