package inky.components.calendar.parsers 
{
	import inky.components.calendar.models.EventModel;

	
	/**
	 *
	 */
	public interface IEventDataParser 
	{
		function parse(data:XML):EventModel;
		
	}
	
}
