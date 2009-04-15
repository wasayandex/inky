package inky.framework.components.calendar.parsers 
{
	import inky.framework.components.calendar.models.DateModel;
	import inky.framework.components.calendar.models.EventModel;
	import inky.framework.components.calendar.parsers.EventDataParser;
	import inky.framework.components.calendar.parsers.IDateDataParser;
	import inky.framework.components.calendar.parsers.IEventDataParser;

	
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
	public class DateDataParser implements IDateDataParser
	{
		private var _eventDataParserClass:Class;


		
		
		//
		// accessors
		//


		/**
		 *
		 */
		public function get eventDataParserClass():Class
		{
			return this._eventDataParserClass || EventDataParser;
		}
		/**
		 * @private
		 */
		public function set eventDataParserClass(eventDataParserClass:Class):void
		{
			this._eventDataParserClass = eventDataParserClass;
		}


		
		
		//
		// public methods
		//

		
		/**
		 *	
		 */
		public function parse(data:XML):DateModel
		{
			var dateModel:DateModel = new DateModel();
			
			// Set the model properties
			for each (var prop:XML in data.attributes())
			{
				dateModel[String(prop.localName())] = String(prop);
			}
			
			for each (var event:XML in data.event)
			{
				var eventDataParser:IEventDataParser = new this.eventDataParserClass();
				var eventModel:EventModel = eventDataParser.parse(event);
				eventModel.dateModel = dateModel;
				eventModel.selectDate(new Date(event.@year, event.@month - 1, event.@date));
				dateModel.addEventModel(eventModel);
			}
			return dateModel;
		}

	}
	
}
