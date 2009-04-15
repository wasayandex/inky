package inky.framework.components.calendar.parsers 
{
	import inky.framework.components.calendar.models.DateModel;

	public interface IDateDataParser
	{
		function get eventDataParserClass():Class;
		function set eventDataParserClass(value:Class):void;

		function parse(data:XML):DateModel
	}
	
}
