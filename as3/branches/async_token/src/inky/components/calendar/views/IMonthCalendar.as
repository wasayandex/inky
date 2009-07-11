package inky.components.calendar.views
{
	import inky.utils.IDisplayObject;
	import inky.components.calendar.views.IDateCalendar;
	import inky.components.calendar.models.MonthModel;

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
	 *	@since  2009.03.17
	 *
	 */
	public interface IMonthCalendar extends IDisplayObject
	{
		
		/**
		 *	
		 */
		function get dateCalendarClass():Class
		/**
		 *	@private
		 */
		function set dateCalendarClass(value:Class):void


		/**
		 *
		 */
		function get model():MonthModel
		/**
		 *	@private
		 */
		function set model(model:MonthModel):void


	}
	
}
