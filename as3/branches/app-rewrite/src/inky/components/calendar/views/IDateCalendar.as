package inky.components.calendar.views
{
	import inky.utils.IDisplayObject;
	import inky.components.calendar.models.DateModel;

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
	public interface IDateCalendar extends IDisplayObject
	{

		/**
		 *
		 */
		function get model():DateModel
		/**
		 *	@private
		 */
		function set model(model:DateModel):void


	}
	
}
