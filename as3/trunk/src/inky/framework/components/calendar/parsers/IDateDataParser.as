package inky.framework.components.calendar.parsers 
{
	import inky.framework.components.calendar.models.DateModel;

	public interface IDateDataParser
	{
		function parse(data:XML):DateModel
	}
	
}
