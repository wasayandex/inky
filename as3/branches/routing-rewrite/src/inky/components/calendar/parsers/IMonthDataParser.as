package inky.components.calendar.parsers 
{
	import inky.components.calendar.models.MonthModel;

	public interface IMonthDataParser 
	{
		
		function get dateDataParserClass():Class;
		function set dateDataParserClass(value:Class):void;
		
		function get eventDataParserClass():Class;
		function set eventDataParserClass(value:Class):void;
		
		function parse(data:XML):MonthModel;

	}
	
}
